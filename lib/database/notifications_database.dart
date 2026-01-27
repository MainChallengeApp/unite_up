import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/models/notification_item_model.dart';
import 'package:unite_up/services/supabase_service.dart';

/// Database operations for the notifications table.
class NotificationsDatabase {
  NotificationsDatabase._();

  static final NotificationsDatabase _instance = NotificationsDatabase._();
  static NotificationsDatabase get instance => _instance;

  SupabaseClient get _client => SupabaseService.client;

  static const String _tableName = 'notifications';

  /// Fetch all notifications for the current user.
  Future<List<NotificationItemModel>> getAll({int limit = 50}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tableName)
        .select('*, action_user:action_user_id(display_name)')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => NotificationItemModel.fromJson(json))
        .toList();
  }

  /// Fetch unread notifications count for the current user.
  Future<int> getUnreadCount() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return 0;

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .eq('is_read', false)
        .count(CountOption.exact);

    return response.count;
  }

  /// Mark a notification as read.
  Future<void> markAsRead(String notificationId) async {
    await _client
        .from(_tableName)
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  /// Mark all notifications as read for the current user.
  Future<void> markAllAsRead() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client
        .from(_tableName)
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }

  /// Delete a notification.
  Future<void> delete(String notificationId) async {
    await _client.from(_tableName).delete().eq('id', notificationId);
  }

  /// Delete all notifications for the current user.
  Future<void> deleteAll() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client.from(_tableName).delete().eq('user_id', userId);
  }

  /// Subscribe to realtime notifications for the current user.
  RealtimeChannel subscribeToNotifications({
    required String userId,
    required void Function(NotificationItemModel notification) onInsert,
    required void Function(NotificationItemModel notification) onUpdate,
    required void Function(String notificationId) onDelete,
  }) {
    return _client
        .channel('notifications:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: _tableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) async {
            // Fetch the full notification with joined data
            final response = await _client
                .from(_tableName)
                .select('*, action_user:action_user_id(display_name)')
                .eq('id', payload.newRecord['id'])
                .single();
            onInsert(NotificationItemModel.fromJson(response));
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: _tableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) async {
            final response = await _client
                .from(_tableName)
                .select('*, action_user:action_user_id(display_name)')
                .eq('id', payload.newRecord['id'])
                .single();
            onUpdate(NotificationItemModel.fromJson(response));
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: _tableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            onDelete(payload.oldRecord['id'] as String);
          },
        )
        .subscribe();
  }

  /// Unsubscribe from realtime notifications.
  Future<void> unsubscribe(RealtimeChannel channel) async {
    await _client.removeChannel(channel);
  }
}




