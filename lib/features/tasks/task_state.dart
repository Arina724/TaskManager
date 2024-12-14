import 'package:task_manager/features/tasks/model/task_model.dart';

class TaskState {
  final List<TaskModel>? list;
  final String? error;
  final bool isLoading;

  TaskState({required this.list, required this.isLoading, this.error});

  TaskState copyWith({List<TaskModel>? list, String? error, required bool isLoading}) {
    return TaskState(
      list: list ?? this.list,
      isLoading: isLoading,
      error: error ?? this.error,
    );
  }
}
