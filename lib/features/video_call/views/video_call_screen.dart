import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:go_router/go_router.dart';
import 'package:hipster/core/constants/route_name.dart';
import 'package:hipster/features/video_call/view_model/video_call_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  final String token;
  final String channelName;

  const VideoCallScreen({
    super.key,
    required this.token,
    required this.channelName,
  });

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  late final VideoCallParams _params;

  @override
  void initState() {
    super.initState();
    _params = VideoCallParams(widget.token, widget.channelName);

    // Initialize with a longer delay to ensure UI is ready
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        await ref.read(videoCallViewModelProvider(_params).notifier).init();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(videoCallViewModelProvider(_params));
    final vm = ref.read(videoCallViewModelProvider(_params).notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          
          _buildMainVideo(state, vm),
          if (state.remoteUids.isNotEmpty) _buildLocalPreview(vm),
          _buildControls(state, vm),
          _buildStatus(state),
        ],
      ),
    );
  }

  Widget _buildMainVideo(VideoCallState state, VideoCallViewModel vm) {
    if (vm.engine == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (state.remoteUids.isNotEmpty) {
      // Show remote user's video when available
      return SizedBox.expand(
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: vm.engine!,
            canvas: VideoCanvas(
              uid: state.remoteUdId,
              //  sourceType: VideoSourceType.videoSourceScreen,
              renderMode: RenderModeType.renderModeHidden,
            ),
            connection: RtcConnection(channelId: state.channelName),
          ),
        ),
      );
    } else {
      // Show local video when no remote users
      return SizedBox.expand(
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: vm.engine!,
            canvas: const VideoCanvas(
              uid: 0,
              renderMode: RenderModeType.renderModeHidden,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildLocalPreview(VideoCallViewModel vm) {
    if (vm.engine == null) return const SizedBox.shrink();

    return Positioned(
      top: 50,
      right: 20,
      width: 120,
      height: 160,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: vm.engine!,
              canvas: const VideoCanvas(
                uid: 0,
                renderMode: RenderModeType.renderModeHidden,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls(VideoCallState state, VideoCallViewModel vm) {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: "mute",
            onPressed: vm.toggleMute,
            backgroundColor: state.muted ? Colors.red : Colors.white24,
            child: Icon(
              state.muted ? Icons.mic_off : Icons.mic,
              color: Colors.white,
            ),
          ),
          FloatingActionButton(
            heroTag: "end",
            onPressed: () async {
              await vm.leave();
              if (mounted)
                GoRouter.of(context).pushReplacement(RouteName.login);
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.call_end, color: Colors.white),
          ),
          FloatingActionButton(
            heroTag: "video",
            onPressed: vm.toggleVideo,
            backgroundColor: state.videoEnabled ? Colors.white24 : Colors.red,
            child: Icon(
              state.videoEnabled ? Icons.videocam : Icons.videocam_off,
              color: Colors.white,
            ),
          ),
          FloatingActionButton(
            heroTag: "switch",
            onPressed: vm.switchCamera,
            backgroundColor: Colors.white24,
            child: const Icon(Icons.switch_camera, color: Colors.white),
          ),
          FloatingActionButton(
            heroTag: "Screen Share",
            onPressed: vm.toggleScreenShare,
            backgroundColor: !state.screenSharing ? Colors.white24 : Colors.red,
            child: Icon(
              state.screenSharing ? Icons.close : Icons.screen_share_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus(VideoCallState state) {
    return Positioned(
      top: 50,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: state.isJoined ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              state.isJoined
                  ? 'Connected (${state.remoteUids.length} users)'
                  : 'Connecting...',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Only call disposeEngine when permanently leaving the app
    // For temporary navigation, just leave() is called in the button
    super.dispose();
  }
}
