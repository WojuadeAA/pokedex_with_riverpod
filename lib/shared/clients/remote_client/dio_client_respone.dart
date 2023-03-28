import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'errors/http_error.dart';
import 'network_client.dart';

class DioNetworkClientImpl extends NetworkClient {
  DioNetworkClientImpl() : super();

  // final String _baseUrl;
  static const connectTimeOut = Duration(seconds: 15);
  static const receiveTimeOut = Duration(seconds: 15);
  late Dio dio = Dio(BaseOptions(
    connectTimeout: connectTimeOut,
    receiveTimeout: receiveTimeOut,
    // baseUrl: _baseUrl,
  ));
  @override
  Future<Response> get(String endpoint) async {
    try {
      final response = await dio.get(
        endpoint,
      );
      _checkForError(response);
      return response;
    } on HttpError catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  @override
  Future<Response> post(String endpoint, {dynamic body}) async {
    try {
      final response = await dio.post(endpoint, data: body);
      _checkForError(response);
      return response;
    } on HttpError catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  @override
  Future<Response> put(String endpoint, {dynamic body}) async {
    try {
      final response = await dio.put(endpoint, data: body);
      _checkForError(response);
      return response;
    } on HttpError catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  @override
  Future<Response> delete(String endpoint) async {
    try {
      final response = await dio.delete(endpoint);
      _checkForError(response);
      return response;
    } on HttpError catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  void _checkForError(Response response) {
    if (response.statusCode! < 200 || response.statusCode! >= 300) {
      throw HttpError(
        statusCode: response.statusCode!,
        message: response.statusMessage!,
      );
    }
  }
}

final dioNetworkClientProvider = Provider<NetworkClient>(((ref) {
  return DioNetworkClientImpl();
}));

///so service use