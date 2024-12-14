import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String title;
  String description;
  bool isDone;
  DateTime time;
  String id;

  TaskModel({
    required this.title,
    required this.isDone,
    required this.time,
    required this.id,
    required this.description
  });

  TaskModel copyWith({String? title, bool? isDone, DateTime? time, String? id, String? description}) {
    return TaskModel(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      time: time ?? this.time,
      id: id ?? this.id,
      description: description ?? this.description
    );
  }

  factory TaskModel.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      isDone: data['isDone'] ?? false,
      time: (data['time'] as Timestamp).toDate(),
      description: data['description'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
      'time': Timestamp.fromDate(time) ,
      'id': id,
      'description':description
    };
  }
}
