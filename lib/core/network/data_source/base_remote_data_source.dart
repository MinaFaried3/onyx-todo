import 'package:onyx_todo/core/network/dio_factory/dio_factory.dart';

abstract class BaseRemoteDataSource<T> {
  final T apiService;
  final DioFactory? dioFactory;

  const BaseRemoteDataSource({
    required this.apiService,
    this.dioFactory,
  });
}
