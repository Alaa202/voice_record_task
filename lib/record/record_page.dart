import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:voice_record_task/record/cubit/record_cubit.dart';
import 'package:voice_record_task/record/widgets/record_button_widget.dart';
import 'package:voice_record_task/record/widgets/voice_message_widget.dart';

import 'package:voice_record_task/record/widgets/voice_player.dart';


class RecordListPage extends StatefulWidget {
  RecordListPage({Key? key}) : super(key: key);

  @override
  State<RecordListPage> createState() => _RecordListPageState();
}

class _RecordListPageState extends State<RecordListPage> {
  Future<void> requestStoragePermission() async {
    await Permission.storage.request();
    await Permission.microphone.request();
  }

  @override
  void initState() {
    requestStoragePermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<RecordCubit, RecordState>(
        builder: (context, state) {
          var cubit = context.read<RecordCubit>();
          if (state is FilesLoaded ||
              state is RecordOn ||
              state is RecordStopped|| state is ChangeRecord|| state is ChangeVoicePlayerIndexState) {
            if (cubit.voicesUrl.isNotEmpty) {
              return SafeArea(

                // child: ListView.separated(
                //     shrinkWrap:  true,
                //     padding: const EdgeInsets.all(16),
                //     itemBuilder: (context, index) =>
                //         voiceWidget(src: "https://qanony.app/${cubit.voicesUrl[index]}"),
                //     separatorBuilder: (context, index) => const SizedBox(
                //       height: 10,
                //     ),
                //     itemCount: cubit.voicesUrl.length),
                child: ListView.separated(
                  shrinkWrap:  true,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) =>

                        Column(
                          children: [

                            Text("$index"),

                            voiceWidget(src: "https://qanony.app/${cubit.voicesUrl[index]}",
                            onPlaying: (){




                            }
                            )
                          ],
                        )

                    ,
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemCount: cubit.voicesUrl.length),
              );
            } else {
              return const Center(
                child: Text(
                  'You have not recorded',
                ),
              );
            }
          } else if (state is FilesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FilesPermisionNotGranted) {
            return Center(
              child: Column(
                children: [
                  const Spacer(),
                  const Text('You need to allow storage permission plz'),
                  ElevatedButton(
                    onPressed: () async {
                      await Permission.storage.request();
                      await Permission.microphone.request();

                    },
                    child: const Text('Allow Permission'),
                  ),
                  const Spacer(),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Error'),
            );
          }
        },
      ),
      bottomNavigationBar: RecordSection(),
    );
  }
}
