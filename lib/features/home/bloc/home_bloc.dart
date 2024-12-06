import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo/core/services/database.dart';
import 'package:todo/features/home/repository/home_repository.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/service_locater.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final homeRepository = sl.get<HomeRepository>();
  final db = sl.get<Database>();

  // Constructor: Initialize event handlers
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<FetchTasksEvent>(onFetchTasksEvent);
    on<AddTaskButtonClickedEvent>(onAddTaskButtonClickedEvent);
    on<DeleteTaskSwipeEvent>(onDeleteTaskSwipeEvent);
    on<SelectCheckboxEvent>(onSelectCheckboxEvent);
  }

  // Add a new task to the database and emit new state
  Future<void> onAddTaskButtonClickedEvent(
      AddTaskButtonClickedEvent event, Emitter<HomeState> emit) async {
    db.insertTask(event.title);
    final todoItems = await db.getTasks();
    final tasks = todoItems.map((item) {
      return Task(
          id: item.id,
          title: item.title,
          completed: item.completed,
          dbData: item.dbData);
    }).toList();

    emit(NewTaskCreatedState(dbTasks: tasks));
  }

  // Handle task deletion and emit updated state
  Future<void> onDeleteTaskSwipeEvent(
      DeleteTaskSwipeEvent event, Emitter<HomeState> emit) async {
    await db.deleteTask(event.id);
    emit(TaskDeleteState(index: event.index));
  }

  // Fetch tasks from the API and database, then emit the success state
  Future<void> onFetchTasksEvent(
      FetchTasksEvent event, Emitter<HomeState> emit) async {
    emit(HomePageLoadingState());
    List<Task> apiTasks = await homeRepository.getAllTasks();

    final todoItems = await db.getTasks();
    final dbTasks = todoItems.map((item) {
      return Task(
          id: item.id,
          title: item.title,
          completed: item.completed,
          dbData: item.dbData);
    }).toList();

    emit(HomePageLoadingSuccessState(apiTasks: apiTasks, dbTasks: dbTasks));
  }

  // Handle checkbox selection and update task completion status
  Future<void> onSelectCheckboxEvent(
      SelectCheckboxEvent event, Emitter<HomeState> emit) async {
    await db.updateTask(TodoItem(
        id: event.task.id,
        title: event.task.title,
        completed: !event.task.completed,
        dbData: event.task.dbData));
    emit(UpdateCheckboxState(index: event.index));
  }
}
