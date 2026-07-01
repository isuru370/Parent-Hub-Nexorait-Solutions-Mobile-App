// lib/features/results/presentation/bloc/result_event.dart

part of 'result_bloc.dart';

sealed class ResultEvent extends Equatable {
  const ResultEvent();

  @override
  List<Object> get props => [];
}

class GetResultEvent extends ResultEvent {
  final int examId;

  const GetResultEvent({required this.examId});

  @override
  List<Object> get props => [examId];
}

class ClearResultEvent extends ResultEvent {}