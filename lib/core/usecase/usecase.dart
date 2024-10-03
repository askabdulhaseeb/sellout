import '../sources/data_state.dart';
export '../sources/data_state.dart';

abstract interface class UseCase<Type, Params> {
  Future<DataState<Type>> call(Params params);
}
