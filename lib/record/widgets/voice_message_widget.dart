import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:voice_record_task/record/cubit/record_cubit.dart';

class VoiceWidget extends StatefulWidget {
  final String src;
  final Function onPlaying;
  const VoiceWidget({super.key, required this.src, required this.onPlaying});

  @override
  State<VoiceWidget> createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends State<VoiceWidget> {
  late VoiceController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = VoiceController(
      audioSrc: widget.src ?? 'https://dl.musichi.ir/1401/06/21/Ghors%202.mp3',
      maxDuration: const Duration(seconds: 120),
      isFile: false,
      onComplete: () {
        print('onComplete');
      },
      onPause: () {
        print('onPause');
      },
      onPlaying: () {
        widget.onPlaying();
        context.read<RecordCubit>().controller = controller;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return VoiceMessageView(
      controller: controller,
      innerPadding: 12,
      cornerRadius: 20,
    );
  }
}
