import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/home/bloc/home_bloc.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/service_locater.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeBloc homeBloc = sl.get<HomeBloc>();

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color.fromARGB(255, 202, 201, 201);
    const blueNeuColor = Color.fromARGB(255, 24, 116, 192);
    List<Task> mergedTasks = [];
    List<Task> apiTasks = [];
    List<Task> dbTasks = [];
    TextEditingController taskEditingController = TextEditingController();

    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {},
      builder: (context, state) {
        // If the HomePage is in an initial state, fetch tasks from API and DB
        if (state is HomeInitial) {
          homeBloc.add(FetchTasksEvent());
        } else if (state is HomePageLoadingState) {
          // Show loading indicator while fetching tasks
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else if (state is HomePageLoadingSuccessState) {
          // Combine tasks from API and DB
          apiTasks = state.apiTasks;
          dbTasks = state.dbTasks;
          mergedTasks = [...apiTasks, ...dbTasks];
        } else if (state is NewTaskCreatedState) {
          // Update the task list after creating a new task
          dbTasks = state.dbTasks;
          mergedTasks = [...apiTasks, ...dbTasks];
        } else if (state is TaskDeleteState) {
          // Remove task from the list when deleted
          mergedTasks.removeAt(state.index);
        } else if (state is UpdateCheckboxState) {
          // Toggle the completion status of a task
          bool previousStatus = mergedTasks[state.index].completed;
          mergedTasks[state.index].completed = !previousStatus;
        }
        return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text(
                "To Do",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: ListView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TaskElement(
                  task: mergedTasks[index],
                  onChanged: (bool? newValue) {
                    // Trigger checkbox change event when checked/unchecked
                    homeBloc
                        .add(SelectCheckboxEvent(mergedTasks[index], index));
                  },
                  onDelete: () {
                    // Trigger task delete event on swipe
                    homeBloc.add(DeleteTaskSwipeEvent(
                        id: mergedTasks[index].id, index: index));
                  },
                );
              },
              itemCount: mergedTasks.length,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                // Show dialog to add new task when FAB is pressed
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Add Task',
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: backgroundColor,
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                        offset: Offset(5, 5),
                                        color: Color.fromARGB(255, 9, 73, 125)),
                                    BoxShadow(
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                        offset: Offset(-5, -5),
                                        color:
                                            Color.fromARGB(255, 30, 149, 247)),
                                  ]), // Styling for the Add button
                              child: TextButton(
                                  onPressed: () {
                                    if (taskEditingController.text.isNotEmpty) {
                                      // Add task when text is not empty
                                      homeBloc.add(AddTaskButtonClickedEvent(
                                          title: taskEditingController.text));
                                      taskEditingController.text = "";
                                      Navigator.of(context).pop();
                                    } else {
                                      // Show error if the title is empty
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Title cannot be empty")),
                                      );
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Add",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                        backgroundColor: blueNeuColor,
                        content: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          // Neumorphic design with inner shadows and rounded corners
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(15), // Rounded corners
                            color: blueNeuColor, // Background color
                            boxShadow: const [
                              // Inner shadow (top-left)
                              BoxShadow(
                                blurStyle: BlurStyle.inner,
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: Offset(-2, -2),
                                color: Color.fromARGB(255, 9, 73, 125),
                              ),
                              // Inner shadow (bottom-right)
                              BoxShadow(
                                blurStyle: BlurStyle.inner,
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: Offset(2, 2),
                                color: Color.fromARGB(255, 30, 149, 247),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter new task',
                                  hintStyle: TextStyle(color: Colors.white60)),
                              maxLines: 1,
                              controller: taskEditingController,
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: const Icon(Icons.add),
            ));
      },
    );
  }
}

class TaskElement extends StatelessWidget {
  final Task task;
  final Function(bool? newValue) onChanged;
  final Function onDelete;

  const TaskElement({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Dismissible(
          key: Key("${task.id}-${task.dbData}"),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // Delete task when swiped
            onDelete();
          },
          background: Container(
            width: MediaQuery.of(context).size.width - 50,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width - 50,
            // Neumorphic design with inner shadows and rounded corners
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 202, 201, 201),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset(-5, -5),
                      color: Colors.white),
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset(5, 5),
                      color: Color.fromARGB(255, 168, 167, 167))
                ]),
            child: CheckboxListTile(
                value: task.completed,
                activeColor: Colors.green,
                checkboxShape:
                    const RoundedRectangleBorder(side: BorderSide(width: 20)),
                onChanged: onChanged, // Handle checkbox change
                title: task.completed
                    ? Text(
                        task.title,
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.black54),
                      )
                    : Text(task.title),
                secondary: task.dbData
                    ? Icon(
                        Icons.phone_android,
                        color: Colors.purple[300],
                      )
                    : Icon(
                        Icons.wifi,
                        color: Colors.green[300],
                        semanticLabel: "API",
                      )),
          ),
        ),
      ),
    );
  }
}
