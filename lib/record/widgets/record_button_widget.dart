import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_record_task/record/cubit/record_cubit.dart';

// recordButton() {
//   var _backgroundColor = Colors.grey.shade400;
//
//   var _colors = [
//     Colors.redAccent,
//     Colors.red,
//   ];
//
//   const _durations = [
//     5000,
//     4000,
//   ];
//
//   const _heightPercentages = [
//     0.55,
//     0.66,
//   ];
//   return BlocBuilder<RecordCubit, RecordState>(
//     builder: (context, state) {
//
//       return Container(
//         color: Colors.grey.shade400,
//         height: 80,
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               state is RecordOn
//                   ? InkWell(
//                 onTap: () {
//                   context.read<RecordCubit>().stopRecording();
//
//
//                   ///We need to refresh [FilesState] after recording is stopped
//                   context.read<RecordCubit>().getRecordings();
//                 },
//                 child: const CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.red,
//                   child: Icon(
//                     Icons.mic,
//                     color: Colors.white,
//                   ),
//                 ),
//               )
//                   : InkWell(
//                 onTap: () {
//                   context.read<RecordCubit>().startRecording();
//                 },
//                 child: const CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.mic),
//                 ),
//               ),
//
//               if( state is RecordOn)
//                 Expanded(
//                   child: WaveWidget(
//                     config: CustomConfig(
//                       colors: _colors,
//                       durations: _durations,
//                       heightPercentages: _heightPercentages,
//                     ),
//                     backgroundColor: _backgroundColor,
//                     size: const Size(400, 200),
//                     waveAmplitude: 0,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

class RecordSection extends StatelessWidget {
  const RecordSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, state) {
        var cubit = context.read<RecordCubit>();
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: state is RecordOn
                      ? MediaQuery.of(context).size.width / 1.3
                      : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B26),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AudioWaveforms(
                      enableGesture: true,
                      size: Size(MediaQuery.of(context).size.width / 1.3, 50),
                      recorderController: cubit.recorderController!,
                      waveStyle: const WaveStyle(
                        waveColor: Colors.white,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: const Color(0xFF1E1B26),
                      ),
                      padding: const EdgeInsets.only(left: 18),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  )),
              const SizedBox(width: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: state is RecordOn
                      ? const Color(0xFF1E1B26)
                      : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    cubit.startOrStopRecording();
                  },
                  icon: Icon(state is RecordOn ? Icons.stop : Icons.mic),
                  color: state is RecordOn
                      ? Colors.white
                      : const Color(0xFF1E1B26),
                  iconSize: 28,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
