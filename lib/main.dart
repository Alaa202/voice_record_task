import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_record_task/helper/dio_helper.dart';
import 'package:voice_record_task/record/cubit/record_cubit.dart';
import 'package:voice_record_task/record/record_page.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => RecordCubit()..path()..initialiseControllers()..getRecordings(),
  child: MaterialApp(
debugShowCheckedModeBanner: false,
      home: RecordListPage(),
    ),
);
  }
}


