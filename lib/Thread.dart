class Thread {
  int id;
  String threadName;
  String jsonName;
  List<bool> usersVote;
  List coordinates;
  int votes;

  Thread(this.id, this.threadName, this.jsonName, this.usersVote, this.coordinates, this.votes);
}