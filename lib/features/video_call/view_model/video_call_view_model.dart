import 'dart:developer';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:equatable/equatable.dart';

class VideoCallState extends Equatable {
  final bool isJoined;
  final bool muted;
  final bool videoEnabled;
  final bool screenSharing;
  final List<int> remoteUids;
  final int remoteUdId;
  final String channelName;

  const VideoCallState({
    this.isJoined = false,
    this.muted = false,
    this.videoEnabled = true,
    this.screenSharing = false,
    this.remoteUids = const [],
    this.channelName = '',
    this.remoteUdId = 0,
  });

  VideoCallState copyWith({
    bool? isJoined,
    bool? muted,
    bool? videoEnabled,
    bool? screenSharing,
    List<int>? remoteUids,
    int? remoteUdId,
    String? channelName,
  }) {
    return VideoCallState(
      isJoined: isJoined ?? this.isJoined,
      muted: muted ?? this.muted,
      videoEnabled: videoEnabled ?? this.videoEnabled,
      screenSharing: screenSharing ?? this.screenSharing,
      remoteUids: remoteUids ?? this.remoteUids,
      remoteUdId: remoteUdId ?? this.remoteUdId,
      channelName: channelName ?? this.channelName,
    );
  }

  @override
  List<Object?> get props => [
    isJoined,
    muted,
    videoEnabled,
    screenSharing,
    remoteUids,
    remoteUdId,
    channelName,
  ];
}

const String kAgoraAppId = '';

class VideoCallParams {
  final String token;
  final String channelName;
  const VideoCallParams(this.token, this.channelName);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoCallParams &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          channelName == other.channelName;

  @override
  int get hashCode => token.hashCode ^ channelName.hashCode;
}

class VideoCallViewModel extends StateNotifier<VideoCallState> {
  VideoCallViewModel(this._token, this._channelName)
    : super(VideoCallState(channelName: _channelName));

  final String _token;
  final String _channelName;

  RtcEngine? _engine;
  RtcEngine? get engine => _engine;

  bool _isInitialized = false;

  Future<void> _ensurePermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();
      if (statuses[Permission.camera] != PermissionStatus.granted ||
          statuses[Permission.microphone] != PermissionStatus.granted) {
        throw Exception('Camera/Microphone permission not granted');
      }
    }
  }

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    await _ensurePermissions();

    try {
      _engine = createAgoraRtcEngine();
      await _engine?.initialize(
        const RtcEngineContext(
          appId: kAgoraAppId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          logConfig: LogConfig(level: LogLevel.logLevelInfo),
        ),
      );

      await _engine!.enableVideo();
      await _engine!.enableAudio();
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      _engine?.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            state = state.copyWith(isJoined: true);
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            final updated = [...state.remoteUids];
            if (!updated.contains(remoteUid)) {
              updated.add(remoteUid);
            }
            state = state.copyWith(remoteUids: updated, remoteUdId: remoteUid);
          },
          onUserOffline:
              (
                RtcConnection connection,
                int remoteUid,
                UserOfflineReasonType reason,
              ) {
                final updated = state.remoteUids
                    .where((u) => u != remoteUid)
                    .toList();
                state = state.copyWith(remoteUids: updated);
              },
          onError: (ErrorCodeType err, String msg) {
            print('Agora Error: $err - $msg');
          },
          onFirstRemoteVideoFrame:
              (
                RtcConnection connection,
                int remoteUid,
                int width,
                int height,
                int elapsed,
              ) {
                print('First remote video frame received from uid: $remoteUid');
              },
        ),
      );

      await _engine?.startPreview();

      await Future.delayed(const Duration(milliseconds: 500));

      await _engine?.joinChannel(
        token: _token,
        channelId: _channelName,
        uid: 0,
        options: const ChannelMediaOptions(
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          publishScreenCaptureVideo: false,
          publishScreenCaptureAudio: false,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );

      _isInitialized = true;
    } catch (e) {
      print('Initialization error: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  Future<void> toggleMute() async {
    if (_engine == null) return;
    final newMuted = !state.muted;
    await _engine!.muteLocalAudioStream(newMuted);
    state = state.copyWith(muted: newMuted);
  }

  Future<void> toggleVideo() async {
    if (_engine == null) return;
    final newVideoEnabled = !state.videoEnabled;
    await _engine!.enableLocalVideo(newVideoEnabled);
    await _engine!.muteLocalVideoStream(!newVideoEnabled);
    state = state.copyWith(videoEnabled: newVideoEnabled);
  }

  Future<void> toggleScreenShare() async {
    try {
      if (_engine == null || !state.isJoined) return;

      final enable = !state.screenSharing;

      if (enable) {
        const params = ScreenCaptureParameters2(
          captureAudio: true,
          captureVideo: true,
          videoParams: ScreenVideoParameters(
            dimensions: VideoDimensions(width: 1280, height: 720),
            frameRate: 15,
            bitrate: 2000,
          ),
          audioParams: ScreenAudioParameters(captureSignalVolume: 100),
        );
        await _engine?.startScreenCapture(
          params,
        ); 

        await _engine?.updateChannelMediaOptions(
          const ChannelMediaOptions(
            publishScreenCaptureVideo: true,
            publishScreenCaptureAudio: true,
            publishCameraTrack: false,
      
          ),
        ); 
        state = state.copyWith(screenSharing: true);
      } else {
        await _engine?.updateChannelMediaOptions(
          const ChannelMediaOptions(
            publishScreenCaptureVideo: false,
            publishScreenCaptureAudio: false,
            publishCameraTrack: true,
            publishMicrophoneTrack: true,
          ),
        );
        await _engine
            ?.stopScreenCapture();
        state = state.copyWith(screenSharing: false);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> switchCamera() async {
    if (_engine == null) return;
    await _engine!.switchCamera();
  }

  Future<void> leave() async {
    if (_engine != null) {
      try {
        await _engine?.stopPreview();
        await _engine?.leaveChannel();
        await _engine?.disableVideo();
        await _engine?.disableAudio();
      } catch (e) {
        print('Error during leave: $e');
      }

      _isInitialized = false;
    }

    state = state.copyWith(
      isJoined: false,
      muted: false,
      screenSharing: false,
      videoEnabled: true,
      remoteUids: const [],
      remoteUdId: 0,
    );
  }

  Future<void> disposeEngine() async {
    if (_engine != null) {
      try {
        await _engine?.stopPreview();
        await _engine?.disableVideo();
        await _engine?.disableAudio();
        await _engine?.leaveChannel();
        await _engine?.release();
      } catch (e) {
        print('Error during dispose: $e');
      }
      _engine = null;
      _isInitialized = false;
    }
  }

  @override
  void dispose() {
    disposeEngine();
    super.dispose();
  }
}

final videoCallViewModelProvider =
    StateNotifierProvider.family<
      VideoCallViewModel,
      VideoCallState,
      VideoCallParams
    >((ref, params) {
      final vm = VideoCallViewModel(params.token, params.channelName);

      return vm;
    });
