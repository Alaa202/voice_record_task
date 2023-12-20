import 'dart:async';

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:voice_record_task/helper/dio_helper.dart';

import '../models/recording.dart';


part 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  RecordCubit() : super(RecordInitial());



  Future<String> path() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String directoryPath = '${appDir.path}/recording';
    Directory directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directoryPath;
  }

  // // var path  ;
  // void startRecording() async {
  //   Map<Permission, PermissionStatus> permissions = await [
  //     Permission.storage,
  //     Permission.microphone,
  //   ].request();
  //
  //   bool permissionsGranted = permissions[Permission.storage]!.isGranted &&
  //       permissions[Permission.microphone]!.isGranted;
  //
  //   if (permissionsGranted) {
  //     String res = await path();
  //     Directory appFolder = Directory(res);
  //     bool appFolderExists = await appFolder.exists();
  //     if (!appFolderExists) {
  //       final created = await appFolder.create(recursive: true);
  //       print(created.path);
  //     }
  //
  //     final filepath = "$res/${DateTime.now()}.wav";
  //     if (kDebugMode) {
  //       print(filepath);
  //     }
  //
  //     await record.start(const RecordConfig(), path: filepath);
  //
  //     emit(RecordOn());
  //   } else {
  //     if (kDebugMode) {
  //       print('Permissions not allow');
  //     }
  //   }
  // }



  RecorderController ?recorderController;


  void startOrStopRecording() async {
    try {

      debugPrint("Recorded 1");

      if (state is RecordOn ) {
        recorderController!.reset();

        final path = await recorderController!.stop(false);

        if (path != null) {

          debugPrint(path);
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }

        await uploadAudio(File(path!));

        emit(RecordStopped());
      } else {
        debugPrint("Recorded 2");
        String res = await path();

        final filepath = "$res/${DateTime.now()}.wav";
        await recorderController?.record(path: filepath );

        emit(RecordOn());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final AudioPlayer audioPlayer = AudioPlayer();

 int voicePlayerIndex = 0;
changeVoicePlayerIndex(value){
  voicePlayerIndex= value;
    emit(ChangeVoicePlayerIndexState());
}
  void initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }
  // void stopRecording() async {
  //   String? path = await record.stop();
  //
  //   File audioFile = File(path!);
  //   await uploadAudio(audioFile);
  //
  //   emit(RecordStopped());
  //
  //   if (kDebugMode) {
  //     print(
  //         '>>>>>>>>>> \n Output path $path \n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
  //   }
  // }

  
  List<String> voicesUrl=[];
  Future<void> uploadAudio( File audioFile) async {

    emit(FilesLoading());
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(audioFile.path),
      "key": "aman@123"
    });
    DioHelper.postData(
            url: "file/upload",
            token:
                "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3Fhbm9ueS5hcHAvYXBpL3YzL3VzZXIvbG9naW4iLCJpYXQiOjE3MDE5NDY0NDUsImV4cCI6MjA2MTk0NjQ0NSwibmJmIjoxNzAxOTQ2NDQ1LCJqdGkiOiJYZWpHbDdCYUNUbXRqUFVzIiwic3ViIjoxNjQ4LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0._BtR6spmP-7iqwJ29McL5gh1d_nuOwQGtlDOysiBATw",
            body: formData)
        .then((value) {
      debugPrint("upload file >>>>>>>> ${value.data} \n >>>>>>>>>>>>>>>>>>");

      voicesUrl.add(value.data["path"]);
      // _downloadFile("https://qanony.app/${value.data["path"]}");
      emit(FilesLoaded());
    }).catchError((e) {


      debugPrint("upload file erorr >>>>>>>> ${e} \n >>>>>>>>>>>>>>>>>>");
    });
  }

  Future<void> _downloadFile(String downloadUrl) async {
    try {

      String res = await path();
DioHelper.downloadFile(downloadUrl:downloadUrl, savePath:"$res/${DateTime.now()}.wav"  );

      debugPrint('File downloaded successfully: $res');
      getRecordings();
    } catch (e) {
      debugPrint('Error downloading file: $e');
    }
  }
  List<RecordedFile> recordings = [];
  Future<void> getRecordings() async {
    emit(FilesLoading());
    String res = await path();
    Directory directory = Directory(res);
    if (directory.existsSync()) {
      List<FileSystemEntity> files = directory.listSync();
      recordings = files
          .where((file) => file.path.endsWith('.wav'))
          .map((file) =>
              RecordedFile(name: file.path.split('/').last, path: file.path))
          .toList();

      for (RecordedFile file in recordings) {
        if (kDebugMode) {
          print(file.path);
        }
      }
    } else {
      if (kDebugMode) {
        print('Directory does not exist');
      }
    }
    emit(FilesLoaded());
  }
}
