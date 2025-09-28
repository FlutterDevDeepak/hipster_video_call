import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:uuid/uuid.dart';

class CallKitService {
  static final CallKitService instance = CallKitService._internal();
  CallKitService._internal();

  final Uuid _uuid = const Uuid();

  final StreamController<CallEvent> _eventsCtrl =
      StreamController<CallEvent>.broadcast();
  StreamSubscription<CallEvent?>? _pluginSub;

  Stream<CallEvent> get events => _eventsCtrl.stream;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _pluginSub = FlutterCallkitIncoming.onEvent.listen((CallEvent? e) {
      if (e != null) {
        _eventsCtrl.add(e);
        if (kDebugMode) {
          debugPrint('[CallKitService] event=${e.event} body=${e.body}');
        }
      }
    });
    _initialized = true;
  }

  Future<String> showIncoming({
    String? id,
    String nameCaller = 'Caller',
    String handle = '0000000000',
    bool video = false,
    Map<String, dynamic>? extra,
  }) async {
    final callId = id ?? _uuid.v4();
    final params = CallKitParams(
      id: callId,
      nameCaller: nameCaller,
      handle: handle,
      type: video ? 1 : 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      callingNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Calling…',
        callbackText: 'Hang up',
      ),
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      extra: extra ?? const {},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        audioSessionMode: 'default',
        audioSessionActive: true,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
    return callId;
  }

  Future<void> endCall(String id) async {
    if (id.isEmpty) return;
    await FlutterCallkitIncoming.endCall(id);
  }

  Future<void> endAll() async {
    final calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      for (final c in calls) {
        final id = c['id']?.toString() ?? '';
        if (id.isNotEmpty) {
          await FlutterCallkitIncoming.endCall(id);
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> activeCalls() async {
    final calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      return calls.cast<Map<String, dynamic>>();
    }
    return const [];
  }

  Future<void> dispose() async {
    await _pluginSub?.cancel();
    await _eventsCtrl.close();
  }

  notificationPermission() async {
    await FlutterCallkitIncoming.requestNotificationPermission({
      "title": "Notification permission",
      "rationaleMessagePermission": "Needed to show call notifications.",
      "postNotificationMessageRequired":
          "Please enable notifications in Settings.",
    });
  }
}
