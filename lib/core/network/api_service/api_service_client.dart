import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_service_client.g.dart';

@RestApi()
abstract class ApiServiceClient {
  factory ApiServiceClient(Dio dio, {String baseUrl}) = _ApiServiceClient;
}
