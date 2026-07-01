import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../data/datasource/exam_remote_datasource.dart';
import '../data/repository/exam_repository_impl.dart';
import '../domain/repository/exam_repository.dart';
import '../domain/usecase/get_exam_list_usecase.dart';
import '../presentation/bloc/exam/exam_bloc.dart';

Future<void> initExamDI() async {
  /// DataSource
  sl.registerLazySingleton<ExamRemoteDataSource>(
    () => ExamRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  /// Repository
  sl.registerLazySingleton<ExamRepository>(
    () => ExamRepositoryImpl(remoteDataSource: sl<ExamRemoteDataSource>()),
  );

  /// UseCase
  sl.registerLazySingleton(() => GetExamListUseCase(repository: sl()));

  /// Bloc
  sl.registerFactory(
    () => ExamBloc(getExamListUseCase: sl<GetExamListUseCase>()),
  );
}
