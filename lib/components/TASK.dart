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

  final int alarmId;

  /// Whether it's done.
  final bool status;

  /// Category Color
  final color;

  /// Date of creation.
  final pickedTime;

  TASK(
    this.alarmId,
    this.task,
    this.category,
    this.color,
    this.status,
    this.pickedTime,
  );

  Map<String, dynamic> toJson() => {
        'AlarmId': alarmId,
        'Category': category,
        'Task': task,
        'Color': color.value,
        'SelectedTime': pickedTime,
        'Status': status
      };
}
