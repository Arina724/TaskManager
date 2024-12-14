import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/features/auth/screens/signout_screen.dart';
import 'package:task_manager/features/tasks/model/task_model.dart';
import 'package:task_manager/features/tasks/task_cubit.dart';
import 'package:task_manager/features/tasks/task_state.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});
  static const path = '/taskScreen';

  @override
  Widget build(BuildContext context) {
    context.read<TaskCubit>().fetchTask();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои задачи'),
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
              onPressed: context.read<TaskCubit>().fetchTask,
              icon: const Icon(Icons.restart_alt),
            ),
          ),
          IconButton(onPressed: () => context.push(SignoutScreen.path), icon: const Icon(Icons.settings)),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.list!.isNotEmpty && state.error == null) {
            return ListView.builder(
              itemCount: state.list!.length,
              itemBuilder: (context, index) {
                TaskModel oneTask = state.list![index];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    title: Center(child: Text(oneTask.title)),
                    titleAlignment: ListTileTitleAlignment.center,
                    isThreeLine: true,
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(oneTask.description),
                        Text(DateFormat('dd MMMM yyyy').format(oneTask.time)),
                      ],
                    ),
                    trailing: Checkbox(
                        value: oneTask.isDone,
                        onChanged: (value) {
                          context.read<TaskCubit>().changeIsDone(oneTask);
                        }),
                    onLongPress: () => context.read<TaskCubit>().deletTask(oneTask),
                  ),
                );
              },
            );
            
          }else if(state.error != null  ){
            return Center(
              child: Text(state.error!),
            );
          } else  {
            return const Center(
              child: Text('Нет задач'),
            );
            
          }  
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addDialog(context),
        child: const Icon(Icons.add_circle_sharp),
      ),
    );
  }

  void _addDialog(BuildContext context) async {
    TextEditingController newTitle = TextEditingController();
    TextEditingController newDescription = TextEditingController();
    TextEditingController dateText = TextEditingController();
    DateTime date = DateTime(0);
    final DateFormat dateFormat = DateFormat('dd--MM--yyyy');

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Новая задача'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newTitle,
                  decoration: const InputDecoration(hintText: 'Название'),
                ),
                TextField(
                  controller: newDescription,
                  decoration: const InputDecoration(hintText: 'Что нужно'),
                ),
                TextFormField(
                  controller: dateText,
                  decoration: const InputDecoration(
                    hintText: 'Нажмите, чтобы указать дату',
                  ),
                  onTap: () {
                    showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2026)).then((onValue) {
                      dateText.text = dateFormat.format(onValue!);
                      date = onValue;
                    });
                  },
                )
              ],
            ),
            actions: [
              TextButton(onPressed: (){
                newTitle.dispose();
                  dateText.dispose();
                  newDescription.dispose();
                  Navigator.pop(context);
                
              }, child:  const Text('Отмена')),
              MaterialButton(
                onPressed: () {
                  context.read<TaskCubit>().createTask(newTitle.text, Timestamp.fromDate(date), newDescription.text);
                  newTitle.dispose();
                  dateText.dispose();
                  newDescription.dispose();
                  Navigator.pop(context);
                },
                child: const Text('Создать'),
              )
            ],
          );
        });
  }
}
