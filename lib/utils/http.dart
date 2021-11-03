import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

import './constant.dart';

class Http {
  Dio? _dio;

  // 工厂模式
  factory Http() => _getInstance();

  static Http get instance => _getInstance();
  static Http? _instance;

  Http._internal() {
    // 初始化

    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: Constant.host,
          connectTimeout: 60000,
          receiveTimeout: 60000,
          headers: {
            'Content-Type': 'application/json',
            'User-Agent-Ext': 'appName=watermarkapp'
          },
        ),
      );

      _dio!.interceptors.add(InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) {
        BotToast.showLoading();
        return handler.next(options);
      }, onResponse: (Response response, ResponseInterceptorHandler handler) {
        var data = response.data;
        if (data['code'] != null && data['code'] != '200') {
          BotToast.closeAllLoading();
          handler.reject(DioError(
              requestOptions: RequestOptions(path: ''), error: data['msg']));
          // throw (data['msg']);
        } else {
          return handler.next(response);
        }
      }, onError: (DioError e, ErrorInterceptorHandler handler) {
        // 301 400
        String msg = '内部错误 请稍后重试';
        var response = e.response;
        if (response != null) {
          msg = response.data['msg'] ?? msg;
        }
        BotToast.closeAllLoading();
        if ('DioErrorType.DEFAULT' == e.type.toString()) {
          BotToast.showText(text: e.error);
        } else {
          BotToast.showText(text: msg);
        }
        return handler.next(e);
      }));
    }
  }

  static Http _getInstance() {
    _instance ??= Http._internal();
    return _instance!;
  }

  Future get(uri, {queryParameters, options}) async {
    try {
      Map<String, dynamic> data = {...queryParameters ?? {}};
      Response response =
          await _dio!.get(uri, queryParameters: data, options: options);
      return response.data;
    } catch (e) {
      print('error: $e');
      throw e;
    }
  }

  Future post(uri, {Map? json}) async {
    try {
      var data = {...json ?? {}};
      Response response = await _dio!.post(
          uri + '?t=${DateTime.now().millisecondsSinceEpoch}',
          data: data);
      return response.data;
    } catch (e) {
      print('error: $e');
      throw e;
    }
  }

  Future postFormData(uri, FormData form) async {
    try {
      Response response = await _dio!.post(
          uri + '?t=${DateTime.now().millisecondsSinceEpoch}',
          data: form);
      return response.data;
    } catch (e) {
      print('error: $e');
      throw e;
    }
  }
}
