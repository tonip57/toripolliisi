import 'package:toripolliisi/Message.dart';

class Thread {
  int id;
  String threadName;
  String jsonName;
  List<bool> usersVote;
  List coordinates;
  int votes;
  bool isDeleted;
  List<Message> messages;

  Thread(this.id, this.threadName, this.jsonName, this.usersVote, this.coordinates, this.votes, this.isDeleted, this.messages);
}