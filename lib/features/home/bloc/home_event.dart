part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class FetchTasksEvent extends HomeEvent {}

class AddTaskButtonClickedEvent extends HomeEvent {
  final String title;

  AddTaskButtonClickedEvent({required this.title});
}

class DeleteTaskSwipeEvent extends HomeEvent {
  final int index;
  final int id;
  DeleteTaskSwipeEvent({required this.index, required this.id});
}

class SelectCheckboxEvent extends HomeEvent {
  final Task task;
  final int index;

  SelectCheckboxEvent(this.task, this.index);
}
