class TASK {
  String taskId;
  final String task;
  final String category;

  void setTaskId(String taskId) {
    this.taskId = taskId;
  }

  String getTaskId() {
    return taskId;
  }

  /// Whether it's done.
  final bool status;

  /// Category Color
  final color;

  /// Date of creation.
  final pickedTime;

  TASK(
    this.task,
    this.category,
    this.color,
    this.status,
    this.pickedTime,
  );

  Map<String, dynamic> toJson() => {
        'Category': category,
        'Task': task,
        'Color': color.value,
        'SelectedTime': pickedTime,
        'Status': status
      };
}
