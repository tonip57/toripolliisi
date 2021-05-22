import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:collection/collection.dart';

import 'Thread.dart';

class _threadScreen extends State<threadScreen> {
  Thread thread;
  List<bool> isSelected;
  List<Bubble> messages = [];
  int initialVotes;

  Function eq = const ListEquality().equals;

  _threadScreen(this.thread);

  @override
  void initState() {
    isSelected = thread.usersVote;
    checkVotes();
    messages.add(Bubble(margin: BubbleEdges.only(top: 10), alignment: Alignment.topLeft, nip: BubbleNip.leftTop, child: Text('Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? '),),);
    messages.add(Bubble(margin: BubbleEdges.only(top: 10), alignment: Alignment.topLeft, nip: BubbleNip.leftTop, child: Text('Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? '),),);
    messages.add(Bubble(margin: BubbleEdges.only(top: 10), alignment: Alignment.topLeft, nip: BubbleNip.leftTop, child: Text('Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? '),),);
    messages.add(Bubble(margin: BubbleEdges.only(top: 10), alignment: Alignment.topLeft, nip: BubbleNip.leftTop, child: Text('Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? '),),);
    messages.add(Bubble(margin: BubbleEdges.only(top: 10), alignment: Alignment.topLeft, nip: BubbleNip.leftTop, child: Text('Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? '),),);
    messages.add(Bubble(margin: BubbleEdges.only(top: 10), alignment: Alignment.topLeft, nip: BubbleNip.leftTop, child: Text('Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? Onko kaikilla hyvä meininki? Mitäs täällä oikeen tapahtuu? '),),);
    super.initState();
  }

  void addMessage () {
    setState(() {
      messages.add(Bubble(margin: BubbleEdges.only(top: 10), alignment: Alignment.topRight, nip: BubbleNip.rightTop, child: Text('Haloo'),),);
    });
  }

  void checkVotes() {
    if (eq(isSelected, [false, false])) {
      initialVotes = thread.votes;
    } else if (eq(isSelected, [true, false])) {
      initialVotes = thread.votes - 1;
    } else if (eq(isSelected, [false, true])) {
      initialVotes = thread.votes + 1;
    }
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
                  Navigator.pop(context, isSelected);
                },
              ),
              title: Text(thread.threadName),
              elevation: 0.0,
            ),
          ),
          body: SafeArea(
             child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 11,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Align(
                          alignment: Alignment.center,
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
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: ToggleButtons(
                          children: [
                            Icon(Icons.plus_one),
                            Icon(Icons.exposure_minus_1),
                          ],
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
                    Container(
                      width: MediaQuery.of(context).size.width / 20,
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 300,
                  color: Colors.blueGrey,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: ListView(
                    children: messages,
                  ),
                ),
                ElevatedButton(
                    onPressed: addMessage,
                    child: Text("Add Message"),
                ),
              ],
            ),
          ),
        ));
  }
}


class threadScreen extends StatefulWidget {
  Thread thread;

  threadScreen(this.thread);

  @override
  _threadScreen createState() => _threadScreen(thread);
}

class AboutWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('REPORT THREAD'),
      content: Container(
        child: Column(
          children: [
            Text("If you find the content of this thread inappropriate, you can report it here."),
          ],
        ),
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