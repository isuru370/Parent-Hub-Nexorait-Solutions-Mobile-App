// lib/features/results/presentation/bloc/result_state.dart

part of 'result_bloc.dart';

sealed class ResultState extends Equatable {
  const ResultState();

  @override
  List<Object> get props => [];
}

final class ResultInitial extends ResultState {}

final class ResultLoading extends ResultState {}

final class ResultLoaded extends ResultState {
  final ResultDataModel data;

  const ResultLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

final class ResultNotPublished extends ResultState {
  final String message;

  const ResultNotPublished({required this.message});

  @override
  List<Object> get props => [message];
}

final class ResultError extends ResultState {
  final String message;

  const ResultError({required this.message});

  @override
  List<Object> get props => [message];
}
