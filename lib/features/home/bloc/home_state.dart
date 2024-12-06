part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

sealed class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

final class HomePageLoadingState extends HomeState {}

class HomePageLoadingSuccessState extends HomeState {
  final List<Task> apiTasks;
  final List<Task> dbTasks;

  HomePageLoadingSuccessState({required this.apiTasks, required this.dbTasks});
}

class NewTaskCreatedState extends HomeState {
  final List<Task> dbTasks;
  NewTaskCreatedState({required this.dbTasks});
}

class TaskDeleteState extends HomeState {
  final int index;
  TaskDeleteState({required this.index});
}

class UpdateCheckboxState extends HomeState {
  final int index;

  UpdateCheckboxState({required this.index});
}
