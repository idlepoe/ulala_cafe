import 'package:dio/dio.dart';
import 'package:ulala_cafe/app/data/constants/app_constants.dart';

import 'dio_interceptor.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
)..interceptors.add(AppInterceptor());
