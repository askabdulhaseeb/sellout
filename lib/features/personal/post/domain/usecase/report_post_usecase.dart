import '../../../../../core/params/report_params.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/post_repository.dart';

class ReportUsecase implements UseCase<bool, ReportParams> {
  const ReportUsecase(this.repository);
  final PostRepository repository;

  @override
  Future<DataState<bool>> call(ReportParams params) async {
    return await repository.reportPost(params);
  }
}
