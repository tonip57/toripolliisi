import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:collection/collection.dart';
import 'package:toripolliisi/User.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:toripolliisi/Thread.dart';
import 'package:intl/intl.dart';
import 'package:toripolliisi/Message.dart';

class _threadScreen extends State<threadScreen> {
  Thread thread;
  User user;
  List<bool> isSelected;
  List<Bubble> messages = [];
  int initialVotes;
  final scrollDirection = Axis.vertical;
  AutoScrollController controller;
  final myController = TextEditingController();

  Function eq = const ListEquality().equals;

  _threadScreen(this.thread, this.user);

  //Sets initial values
  @override
  void initState() {
    isSelected = thread.usersVote;
    checkVotes();
    readMessages();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, 0),
        axis: scrollDirection
    );
    _scrollToIndex();
    super.initState();
  }

  //Reads messages from Thread-object. Users own messages are showed differently
  void readMessages() {
    for (var elem in thread.messages) {
      if (elem.user != user.userName) {
        messages.add(Bubble(margin: BubbleEdges.only(top: 10),
          alignment: Alignment.topLeft,
          nip: BubbleNip.leftTop,
          child: IntrinsicWidth(
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(elem.user,
                    style: TextStyle(fontSize: 12, color: Colors.indigoAccent)),
                Container(height: 8),
                Text(elem.message),
                Container(height: 8),
                Row(children: [
                  Text(elem.time,
                      style: TextStyle(fontSize: 10, color: Colors.black45)),
                  Text(" | ",
                      style: TextStyle(fontSize: 10, color: Colors.black45)),
                  Text(elem.date,
                      style: TextStyle(fontSize: 10, color: Colors.black45)),
                ]),
              ],
            ),
          ),
        ),
        );
      } else {
        messages.add(Bubble(margin: BubbleEdges.only(top: 10),
          alignment: Alignment.topRight,
          nip: BubbleNip.rightTop,
          child: IntrinsicWidth(
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(elem.user, style: TextStyle(fontSize: 12, color: Colors.purpleAccent)),
                Container(height: 8),
                Text(elem.message),
                Container(height: 8),
                Row(children: [
                  Text(elem.time, style: TextStyle(fontSize: 10, color: Colors.black45)),
                  Text(" | ", style: TextStyle(fontSize: 10, color: Colors.black45)),
                  Text(elem.date, style: TextStyle(fontSize: 10, color: Colors.black45)),
                ]),
              ],
            ),
          ),
        ),
        );
      }
    }
  }

  //Gets date for users message
  String getDate() {
    var dateNow = new DateTime.now();
    String day = DateFormat('d').format(dateNow);
    String month = DateFormat('M').format(dateNow);
    String year = DateFormat('y').format(dateNow);
    String formattedDate = day + "." + month + "." + year;
    return formattedDate;
  }

  //Gets time for users message
  String getTime() {
    var timeNow = new DateTime.now();
    //timeNow = timeNow.add(new Duration(hours: 3));
    String formattedTime = DateFormat('Hm').format(timeNow);
    return formattedTime;
  }

  //Adds a new message to list view
  void addMessage () {
    String formattedDate = getDate();
    String formattedTime = getTime();
    print(formattedDate);
    print(formattedTime);

    setState(() {
      messages.add(Bubble(margin: BubbleEdges.only(top: 10),
        alignment: Alignment.topRight,
        nip: BubbleNip.rightTop,
        child: IntrinsicWidth(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(user.userName, style: TextStyle(fontSize: 12, color: Colors.purpleAccent)),
              Container(height: 8),
              Text(myController.text),
              Container(height: 8),
              Row(children: [
                Text(formattedTime, style: TextStyle(fontSize: 10, color: Colors.black45)),
                Text(" | ", style: TextStyle(fontSize: 10, color: Colors.black45)),
                Text(formattedDate, style: TextStyle(fontSize: 10, color: Colors.black45)),
              ]),
            ],
          ),
        ),
      ),
      );
    });

    thread.messages.add(Message(user.userName, myController.text, formattedDate, formattedTime));
  }

  //Checks votes and if user has already voted
  void checkVotes() {
    if (eq(isSelected, [false, false])) {
      initialVotes = thread.votes;
    } else if (eq(isSelected, [true, false])) {
      initialVotes = thread.votes - 1;
    } else if (eq(isSelected, [false, true])) {
      initialVotes = thread.votes + 1;
    }
  }

  //Scrolls to bottom of message list view when new message is added
  void _scrollToIndex() {
    print(messages.length-1);
    controller.scrollToIndex(messages.length-1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:  Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: AppBar(
              actions: [
                IconButton(
                  icon: Icon(Icons.warning_amber_rounded),
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (context) => AboutWidget(),
                    ),
                  },
                )
              ],
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context, thread);
                },
              ),
              title: Text(thread.threadName),
              elevation: 0.0,
            ),
          ),
          body: SafeArea(
             child:
             ListView(
               children: [
             Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            thread.votes.toString() + " Votes!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 13,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Align(
                          alignment: Alignment.center,
                          child: ToggleButtons(
                            borderRadius: BorderRadius.circular(8.0),
                            children: <Widget>[
                              Container(width: (MediaQuery.of(context).size.width)/6.5, child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new Icon(Icons.plus_one),new SizedBox(width: 4.0,)],)),
                              Container(width: (MediaQuery.of(context).size.width)/6.5, child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new Icon(Icons.exposure_minus_1),new SizedBox(width: 4.0,)],)),
                            ],
                            selectedColor: Colors.white,
                            fillColor: Colors.blue,
                            isSelected: isSelected,
                            onPressed: (int index) {
                              setState(() {
                                if (isSelected[index] == true) {
                                  isSelected[0] = false;
                                  isSelected[1] = false;
                                } else {
                                  isSelected[0] = false;
                                  isSelected[1] = false;
                                  isSelected[index] = true;
                                }
                                if (isSelected[0] == true) {
                                  thread.votes = initialVotes;
                                  thread.votes = thread.votes + 1;
                                } else if (isSelected[1] == true) {
                                  thread.votes = initialVotes;
                                  thread.votes = thread.votes - 1;
                                } else {
                                  thread.votes = initialVotes;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 300,
                  color: Colors.grey,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2,
                  child: ListView.builder(
                      scrollDirection: scrollDirection,
                      controller: controller,
                      padding: const EdgeInsets.all(8),
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AutoScrollTag(
                            key: ValueKey(index),
                            controller: controller,
                            index: index,
                            child: messages[index]);
                      }
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter a message",
                      suffixIcon: IconButton(
                        onPressed: () {
                          addMessage();
                          FocusScope.of(context).requestFocus(FocusNode());
                          _scrollToIndex();
                          myController.clear();
                        },
                        icon: Icon(Icons.send),
                      ),
                    ),
                  ),
                ),
              ],
              ),
              ],
             ),
          ),
        ));
  }
}


class threadScreen extends StatefulWidget {
  Thread thread;
  User user;

  threadScreen(this.thread, this.user);

  @override
  _threadScreen createState() => _threadScreen(thread, user);
}

class AboutWidget extends StatelessWidget {

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('REPORT THREAD'),
      content: ListView(
        shrinkWrap: true,
      children: [
        Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            Text("If you find the content of this thread inappropriate, you can report it here."),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Report",
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (myController.text.isNotEmpty) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        print("Reported: " + myController.text.toString());
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: Text('Report sent!'),
                              );
                            });
                        myController.clear();
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                content: Text('Your report is empty!'),
                              );
                            });
                      }
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ],
      ),
      ],
      ),
      actions: [
        TextButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // background
            onPrimary: Colors.blue, // foreground
          ),
          child: Text("close"),
          onPressed: () {Navigator.pop(context);},
        ),
      ],
    );
  }
}