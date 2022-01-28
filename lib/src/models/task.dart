class Task {
  int id;
  String title;
  String content;
  bool isCompleted;
  String fbid;

  Task(this.id, this.title, this.content, this.isCompleted, this.fbid);

  static Task copyTask(Task sourceTask) {
    return new Task(sourceTask.id, sourceTask.title, sourceTask.content,
        sourceTask.isCompleted, sourceTask.fbid);
  }
}
