import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/database/notifications_database.dart';
import 'package:unite_up/models/notification_item_model.dart';
import 'package:unite_up/services/supabase_service.dart';

/// Provider for managing notification state.
class NotificationsProvider extends ChangeNotifier {
  NotificationsProvider() {
    _init();
  }

  final _notificationsDb = NotificationsDatabase.instance;

  List<NotificationItemModel> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<AuthState>? _authSubscription;
  RealtimeChannel? _realtimeChannel;
  final Set<String> _deletingIds = {};

  // Getters
  List<NotificationItemModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUnread => _unreadCount > 0;
  Set<String> get deletingIds => _deletingIds;

  void _init() {
    _authSubscription = SupabaseService.authStateChanges.listen(
      _onAuthStateChanged,
    );
    // Load notifications if already authenticated
    _loadNotifications();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _unsubscribeFromRealtime();
    super.dispose();
  }

  /// Handle auth state changes.
  Future<void> _onAuthStateChanged(AuthState state) async {
    switch (state.event) {
      case AuthChangeEvent.signedIn:
      case AuthChangeEvent.tokenRefreshed:
        await _loadNotifications();
        _subscribeToRealtime();
        break;
      case AuthChangeEvent.signedOut:
        _notifications = [];
        _unreadCount = 0;
        _unsubscribeFromRealtime();
        notifyListeners();
        break;
      default:
        break;
    }
  }

  /// Load all notifications from the database.
  Future<void> _loadNotifications() async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await _notificationsDb.getAll();
      _unreadCount = _notifications.where((n) => !n.isRead).length;
      _subscribeToRealtime();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reload notifications from the database.
  Future<void> reload() async {
    await _loadNotifications();
  }

  /// Subscribe to realtime notification updates.
  void _subscribeToRealtime() {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null || _realtimeChannel != null) return;

    _realtimeChannel = _notificationsDb.subscribeToNotifications(
      userId: userId,
      onInsert: _handleInsert,
      onUpdate: _handleUpdate,
      onDelete: _handleDelete,
    );
  }

  /// Unsubscribe from realtime notifications.
  void _unsubscribeFromRealtime() {
    if (_realtimeChannel != null) {
      _notificationsDb.unsubscribe(_realtimeChannel!);
      _realtimeChannel = null;
    }
  }

  /// Handle new notification insert.
  void _handleInsert(NotificationItemModel notification) {
    _notifications.insert(0, notification);
    if (!notification.isRead) {
      _unreadCount++;
    }
    notifyListeners();
  }

  /// Handle notification update.
  void _handleUpdate(NotificationItemModel notification) {
    final index = _notifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      final wasUnread = !_notifications[index].isRead;
      final isNowRead = notification.isRead;

      _notifications[index] = notification;

      if (wasUnread && isNowRead) {
        _unreadCount = (_unreadCount - 1).clamp(0, _notifications.length);
      }
      notifyListeners();
    }
  }

  /// Handle notification delete.
  void _handleDelete(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      if (!_notifications[index].isRead) {
        _unreadCount = (_unreadCount - 1).clamp(0, _notifications.length);
      }
      _notifications.removeAt(index);
      _deletingIds.remove(notificationId);
      notifyListeners();
    }
  }

  // ============================================================================
  // Public Methods
  // ============================================================================

  /// Mark a notification as read.
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1 || _notifications[index].isRead) return;

    // Optimistic update
    _notifications[index] = _notifications[index].copyWith(isRead: true);
    _unreadCount = (_unreadCount - 1).clamp(0, _notifications.length);
    notifyListeners();

    try {
      await _notificationsDb.markAsRead(notificationId);
    } catch (e) {
      // Revert on error
      _notifications[index] = _notifications[index].copyWith(isRead: false);
      _unreadCount++;
      notifyListeners();
      rethrow;
    }
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    if (_unreadCount == 0) return;

    // Optimistic update
    final previousNotifications = List<NotificationItemModel>.from(_notifications);
    final previousUnreadCount = _unreadCount;

    _notifications = _notifications
        .map((n) => n.isRead ? n : n.copyWith(isRead: true))
        .toList();
    _unreadCount = 0;
    notifyListeners();

    try {
      await _notificationsDb.markAllAsRead();
    } catch (e) {
      // Revert on error
      _notifications = previousNotifications;
      _unreadCount = previousUnreadCount;
      notifyListeners();
      rethrow;
    }
  }

  /// Delete a notification with animation support.
  Future<void> delete(String notificationId) async {
    // Mark as deleting for animation
    _deletingIds.add(notificationId);
    notifyListeners();

    // Wait for animation
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1) {
      _deletingIds.remove(notificationId);
      return;
    }

    // Optimistic update
    final removedNotification = _notifications[index];
    _notifications.removeAt(index);
    if (!removedNotification.isRead) {
      _unreadCount = (_unreadCount - 1).clamp(0, _notifications.length);
    }
    _deletingIds.remove(notificationId);
    notifyListeners();

    try {
      await _notificationsDb.delete(notificationId);
    } catch (e) {
      // Revert on error
      _notifications.insert(index, removedNotification);
      if (!removedNotification.isRead) {
        _unreadCount++;
      }
      notifyListeners();
      rethrow;
    }
  }

  /// Delete all notifications.
  Future<void> deleteAll() async {
    if (_notifications.isEmpty) return;

    // Optimistic update
    final previousNotifications = List<NotificationItemModel>.from(_notifications);
    final previousUnreadCount = _unreadCount;

    _notifications = [];
    _unreadCount = 0;
    notifyListeners();

    try {
      await _notificationsDb.deleteAll();
    } catch (e) {
      // Revert on error
      _notifications = previousNotifications;
      _unreadCount = previousUnreadCount;
      notifyListeners();
      rethrow;
    }
  }

  /// Clear error state.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}




