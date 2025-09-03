abstract class DataState<T> {
  DataState({this.data, this.entity, this.exception});
  final String? data;
  T? entity;
  final CustomException? exception;
}

class DataSuccess<T> extends DataState<T> {
  DataSuccess(String data, T? entity) : super(data: data, entity: entity);
}

class DataFailer<T> extends DataState<T> {
  DataFailer(CustomException exception) : super(exception: exception);
}

class CustomException {
  CustomException(
    this.message, {
    this.code,
    this.detail,
    String? reason,
  }) : reason = reason ?? message;
  final int? code;
  final String? detail;
  final String? reason;
  final String message;
}
