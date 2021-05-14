import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:toripolliisi/main.dart';

class _addThread extends State<addThread> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:  Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              title: Text("Luo lanka"),
              elevation: 0.0,
              actions: [
                IconButton(onPressed: () => {
                  showDialog(
                    context: context,
                    builder: (context) => AboutWidget(),
                  ),
                },
                    icon: Icon(Icons.search))
              ],
            ),
          ),
          body: SafeArea(
             child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.6,
                    color: Colors.blueGrey,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2.6,
                    color: Colors.red,
                  ),
                ],
              ),
          ),
        ));
  }
}


class addThread extends StatefulWidget {

  @override
  _addThread createState() => _addThread();
}

class AboutWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(' HELP'),
      content: Column(
        children: [
          Container(
            child: Text("NativeAlloc concurrent copying GC freed 55213(2493KB) AllocSpace objects, 0(0B) LOS objects, 49% free, 8042KB/15MB, paused 355us total 146.650ms "
                "NativeAlloc concurrent copying GC freed 55213(2493KB) AllocSpace objects, 0(0B) LOS objects, 49% free, 8042KB/15MB, paused 355us total 146.650ms"),
          ),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.purple,),
                Text("Nähtävyys"),
              ],),),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.redAccent,),
                Text("Nähtävyys"),
              ],),),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.greenAccent,),
                Text("Nähtävyys"),
              ],),),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.blue.shade400,),
                Text("Nähtävyys"),
              ],),),
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