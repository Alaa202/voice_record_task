import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';



class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: "",
          receiveDataWhenStatusError: true,


          headers: {'Content-Type': 'application/json'}
      ),
    );
  }


  static Future<Response>  downloadFile({downloadUrl, savePath})async{

   return await dio!.download(
      downloadUrl,
      savePath,
      onReceiveProgress: (receivedBytes, totalBytes) {
        double progress = (receivedBytes / totalBytes) * 100;
        debugPrint('Download progress: $progress%');
      },
    );
  }
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio!.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',

    };

    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    dynamic body,
    String? token,
  }) async {
    dio!.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',

    };
    return await dio!.post(
      url,
      data: body,
      queryParameters: query,
    );
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? data,
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': 'en',
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };
    return await dio!.put(
      url,
      data: data,
      queryParameters: query,
    );
  }
}