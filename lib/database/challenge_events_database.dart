import 'dart:async';
import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/services/supabase_service.dart';

/// Callback types for realtime events.
typedef EventInsertCallback = void Function(EventModel event);
typedef EventUpdateCallback = void Function(EventModel event);
typedef EventDeleteCallback = void Function(String eventId);

/// Database operations for the challenge_events table.
class ChallengeEventsDatabase {
  ChallengeEventsDatabase._();

  static final ChallengeEventsDatabase _instance = ChallengeEventsDatabase._();
  static ChallengeEventsDatabase get instance => _instance;

  SupabaseClient get _client => SupabaseService.client;

  static const String _tableName = 'challenge_events';

  /// Active realtime channels by challenge ID.
  final Map<String, RealtimeChannel> _channels = {};

  /// Create a new event.
  Future<EventModel> create(EventModel event) async {
    final response = await _client
        .from(_tableName)
        .insert(event.toJson())
        .select()
        .single();

    return EventModel.fromJson(response);
  }

  /// Get all events for a challenge.
  Future<List<EventModel>> getForChallenge(
    String challengeId, {
    int? limit,
    int? offset,
  }) async {
    var query = _client
        .from(_tableName)
        .select()
        .eq('challenge_id', challengeId)
        .order('created_at', ascending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final response = await query;
    return (response as List).map((e) => EventModel.fromJson(e)).toList();
  }

  /// Get recent events for a challenge.
  Future<List<EventModel>> getRecentForChallenge(
    String challengeId, {
    int limit = 50,
  }) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('challenge_id', challengeId)
        .order('created_at', ascending: false)
        .limit(limit);

    // Reverse to get chronological order
    final events = (response as List)
        .map((e) => EventModel.fromJson(e))
        .toList()
        .reversed
        .toList();

    return events;
  }

  /// Update an event (e.g., edit a message).
  Future<EventModel> update(String id, Map<String, dynamic> updates) async {
    final response = await _client
        .from(_tableName)
        .update(updates)
        .eq('id', id)
        .select()
        .single();

    return EventModel.fromJson(response);
  }

  /// Update event message.
  Future<EventModel> updateMessage(String id, String newMessage) async {
    return update(id, {'message': newMessage});
  }

  /// Delete an event.
  Future<void> delete(String id) async {
    await _client.from(_tableName).delete().eq('id', id);
  }

  /// Delete all events for a challenge.
  Future<void> deleteForChallenge(String challengeId) async {
    await _client.from(_tableName).delete().eq('challenge_id', challengeId);
  }

  // ===========================================================================
  // REALTIME SUBSCRIPTIONS
  // ===========================================================================

  /// Subscribe to realtime changes for a specific challenge.
  /// Returns a function to unsubscribe.
  RealtimeChannel subscribeToChallenge(
    String challengeId, {
    EventInsertCallback? onInsert,
    EventUpdateCallback? onUpdate,
    EventDeleteCallback? onDelete,
  }) {
    // Unsubscribe from existing channel if any
    unsubscribeFromChallenge(challengeId);

    final channelName = 'challenge_events:$challengeId';
    final channel = _client.channel(channelName);

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: _tableName,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'challenge_id',
        value: challengeId,
      ),
      callback: (payload) {
        if (onInsert != null && payload.newRecord.isNotEmpty) {
          try {
            final event = EventModel.fromJson(payload.newRecord);
            onInsert(event);
          } catch (e) {
            developer.log(
              'Error parsing inserted event: $e',
              name: 'ChallengeEventsDatabase',
              error: e,
            );
          }
        }
      },
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: _tableName,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'challenge_id',
        value: challengeId,
      ),
      callback: (payload) {
        if (onUpdate != null && payload.newRecord.isNotEmpty) {
          try {
            final event = EventModel.fromJson(payload.newRecord);
            onUpdate(event);
          } catch (e) {
            developer.log(
              'Error parsing updated event: $e',
              name: 'ChallengeEventsDatabase',
              error: e,
            );
          }
        }
      },
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: _tableName,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'challenge_id',
        value: challengeId,
      ),
      callback: (payload) {
        if (onDelete != null && payload.oldRecord.isNotEmpty) {
          final eventId = payload.oldRecord['id'] as String?;
          if (eventId != null) {
            onDelete(eventId);
          }
        }
      },
    );

    channel.subscribe();
    _channels[challengeId] = channel;

    return channel;
  }

  /// Unsubscribe from realtime changes for a specific challenge.
  Future<void> unsubscribeFromChallenge(String challengeId) async {
    final channel = _channels.remove(challengeId);
    if (channel != null) {
      await channel.unsubscribe();
    }
  }

  /// Unsubscribe from all realtime channels.
  Future<void> unsubscribeAll() async {
    for (final channel in _channels.values) {
      await channel.unsubscribe();
    }
    _channels.clear();
  }
}
