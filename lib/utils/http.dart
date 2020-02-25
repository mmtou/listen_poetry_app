import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

import './constant.dart';

class Http {
  Dio _dio;

  // 工厂模式
  factory Http() => _getInstance();

  static Http get instance => _getInstance();
  static Http _instance;

  Http._internal() {
    // 初始化

    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
            baseUrl: Constant.host,
            connectTimeout: 10000,
            receiveTimeout: 6000,
            headers: {'Content-Type': 'application/json'}),
      );

      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        BotToast.showLoading();
        return options; //continue
      }, onResponse: (Response response) async {
        BotToast.closeAllLoading();
        var data = response.data;
        if (!data['success']) {
          BotToast.showText(text: data['message']);
          throw (data['message']);
        }
        return response.data['result']; // continue
      }, onError: (DioError e) async {
        BotToast.closeAllLoading();
        if ('DioErrorType.DEFAULT' == e.type.toString()) {
          BotToast.showText(text: e.error);
        } else {
          BotToast.showText(text: '服务器异常');
        }
        // Do something with response error
        return e; //continue
      }));
    }
  }

  static Http _getInstance() {
    if (_instance == null) {
      _instance = Http._internal();
    }
    return _instance;
  }

  Future get(uri, {queryParameters}) async {
    try {
      Response response = await _dio.get(uri, queryParameters: queryParameters);
      print(response);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future post(uri, {json}) async {
    try {
      Response response = await _dio.post(uri, data: json);
      print(response);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
