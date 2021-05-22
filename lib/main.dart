import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toripolliisi/addThread.dart';
import 'package:toripolliisi/Place.dart';
import 'package:toripolliisi/Thread.dart';
import 'package:toripolliisi/usersThread.dart';
import 'package:toripolliisi/threadScreen.dart';
import 'package:toripolliisi/placeInfo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: new Color(0xff622F74),
      ),
      home: MyHomePage(),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {

  Set<Marker> _markers = {};
  BitmapDescriptor threadMarker;
  BitmapDescriptor userMarker;
  List listOfPlaces = [];
  List listOfThreads = [];
  List userCoordinates = [65.03, 25.54];
  List listOfUsedCoordinates = [];

  Function eq = const ListEquality().equals;

  @override
  void initState() {
    listOfPlaces.add(Place("Torinranta ja Toripolliisi", "sight", "toripolliisi1.jpg", "Torinranta on kesäaikaan täynnä tekemistä. Kahvilat ja terassit sekä kauniit maisemat houkuttelevat kaikenikäisiä oululaisia viettämään alueella aikaa.Torilta löytyy myös kenties Oulun tunnetuin nähtävyys, Toripolliisi -patsas. ", [false, false], [65.013287, 25.464802], 566));
    listOfPlaces.add(Place("Yliopisto - Linnanmaa", "forStudent", "yliopisto_linnanmaa3.jpg", "Linnanmaan pääkampukselta löytyvät Oulun Yliopiston humanistinen, luonnontieteellinen, kasvatustieteiden, teknillinen ja tieto- ja sähkötekniikan tiedekunta, Oulun yliopiston kauppakorkeakoulu sekä Oulun ammattikorkeakoulu. ", [false, false], [65.059310, 25.466325], 315));
    listOfPlaces.add(Place("Yliopisto - Kontinkangas", "forStudent", "yliopisto_kontinkangas1.jpg", "Kontinkankaan kampukselta löytyvät Oulun Yliopiston lääketieteellinen tiedekunta, biokemian ja molekyylilääketieteen tiedekunta sekä Oulun yliopistosairaala. ", [false, false], [65.008554, 25.521638], 34));
    listOfPlaces.add(Place("YTHS", "forStudent", "YTHS1.jpg", "YTHS:n huolehtii opiskelijoiden terveydenhuollosta. Opiskeluterveydenhuollon palveluihin kuuluvat esimerkiksi terveystarkastukset, suunterveydenhuolto, sairaanhoitopalveluiden järjestäminen sekä mielenterveyspalvelut. ", [false, false], [65.057678, 25.471298], 233));
    listOfPlaces.add(Place("Nallikari", "sight", "nallikari1.jpg", "Nallikarin pitkä hiekkaranta ja uskomattomat auringonlaskut vievät lomatunnelmaan hetkessä. Uimaranta houkuttelee paitsi auringonpalvojia, myös sporttisen rantapäivän viettäjiä ja sadepäivänä voi suunnata Edenin kylpylään tain Nallisportin urheiluhalliin. Talvella pääsee kävelemään jäätä pitkin ja voi nauttia Talvikylän nähtävyyksistä. ", [false, false],  [65.030494, 25.411436], 900));
    listOfPlaces.add(Place("Raksilan marketit", "goodToKnow", "raksila2.jpg", "Raksilan marketit on Raksilan kaupunginosassa sijaitseva kauppakeskittymä, josta löytyvät  Prisma, K-Citymarket, Sale sekä Alko ja Posti. ", [false, false], [65.010914, 25.491291], 96));
    listOfPlaces.add(Place("Viihdemaailma Ilona", "restaurantOrBar", "ilona3.jpg", "Viihdemaailma Ilona on yksi Oulun keskustan suosituimmista yökerhoista. Viisi osastoa London, Live, Disco, Retro ja Karaoke takaavat onnistuneen elämyksen moneen erilaiseen makuun. Viikonloppuisin on tarjolla livemusiikkia ja arkisin paikka voidaan nähdä täynnä opiskelijoita. ", [false, false], [65.010995, 25.466640], 111));
    listOfPlaces.add(Place("Linnanmaan liikuntahalli", "sports", "linnanmaan-liikunta2.jpg", "Linnanmaan liikuntahallilta löytyy mahdollisuudet monenlaiseen urheiluun kuten koripallo, kuntosaliharjoittelu, lentopallo, musiikkiliikunta, salibandy, sulkapallo ja telinevoimistelu. Opiskelijan kannattaa tutustua Oulun korkeakoululiikunnan palveluihin tarkemmin https://www.oulunkorkeakoululiikunta.fi/fi ", [false, false], [65.055071, 25.471575], 39));
    listOfPlaces.add(Place("Oulu10", "goodToKnow", "oulu10_1.jpg", "Oulu10-palvelut tarjoaa neuvontaa ja ohjausta kaikkiin Oulun kaupungin palveluihin liittyen, kuten esimerkiksi Lipunmyynti Oulun joukkoliikenteeseen. Tarjolla on myös neuvontaa ja ohjausta valtiohallinnon palveluista sekä etäpalveluyhteydet. ", [false, false], [65.013780, 25.470417], 9));
    listOfPlaces.add(Place("PSOAS", "goodToKnow", "psoas1.jpg", "PSOAS tarjoaa asumispalveluja opiskelijoille. PSOASin valikoimassa on useita eri kokoisia moderneja ja viihtyisiä opiskelija-asuntoja. ", [false, false], [65.017182, 25.478804], 77));

    listOfThreads.add(Thread(1, "Ensimmainen lanka", "thread1.json", [false, false], [65.0, 25.4], 325));
    listOfThreads.add(Thread(2, "Keskustelu 2", "thread2.json", [false, false], [65.0, 25.5], 12));

    setUserMarker();
    setThreadMarker();
    super.initState();
  }

  void setUserMarker() async {
    userMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/userLocation.png");
  }

  void setThreadMarker() async {
    threadMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/thread.png");
  }

  void setStaticMarkers () {
    for (int i = 0; i<listOfPlaces.length; i++) {
      double x = listOfPlaces[i].coordinates[0];
      double y = listOfPlaces[i].coordinates[1];
      BitmapDescriptor iconColor;
      if (listOfPlaces[i].category == "goodToKnow") {
        iconColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
      } else if (listOfPlaces[i].category == "sports") {
        iconColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      } else if (listOfPlaces[i].category == "restaurantOrBar") {
        iconColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      } else if (listOfPlaces[i].category == "sight") {
        iconColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      } else if (listOfPlaces[i].category == "forStudent") {
        iconColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      }
      _markers.add(
        Marker(
            markerId: MarkerId(listOfPlaces[i].name),
            position: LatLng(x, y),
            icon: iconColor,
            onTap: () {
              goToPlaceInfoScreen(i);
            }
        ),
      );
      listOfUsedCoordinates.add([x, y]);
    }
  }

  void setThreadMarkers () {
    for (int i = 0; i<listOfThreads.length; i++) {
      double x = listOfThreads[i].coordinates[0];
      double y = listOfThreads[i].coordinates[1];
      _markers.add(
        Marker(
            markerId: MarkerId((i + 1).toString() + "t"),
            position: LatLng(x, y),
            icon: threadMarker,
            anchor: const Offset(0.5, 0.5),
            onTap: () {
                goToThreadScreen(i);
            }
        ),
      );
      listOfUsedCoordinates.add([x, y]);
    }
  }

  void setUserMarkerToMap() {
    _markers.add(
      Marker(
          markerId: MarkerId("user"),
          position: LatLng(userCoordinates[0], userCoordinates[1]),
          icon: userMarker,
          anchor: const Offset(0.5, 0.5),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyle);
    setState(() {
      //sets static markers
      setStaticMarkers();
      //sets threads
      setThreadMarkers();
      //set user marker
      setUserMarkerToMap();
    });
  }

  void goToThreadScreen(int i) async {
    List<bool> voteInformation = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => threadScreen(listOfThreads[i])),
    );
    print(voteInformation);
  }

  void goToUsersThreadScreen(int i) async {
    List voteAndDeleteInformation = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => usersThread(listOfThreads[i])),
    );
    print(voteAndDeleteInformation);
    if (voteAndDeleteInformation.length == 3) {
      Marker marker = _markers.firstWhere((marker) => marker.markerId.value == voteAndDeleteInformation[0],orElse: () => null);
      setState(() {
        _markers.remove(marker);
      });
      int count = 0;
      for (var elem in listOfUsedCoordinates) {
        if (eq(elem, voteAndDeleteInformation[2])) {
          listOfUsedCoordinates.removeAt(count);
        }
        count++;
      }
      print("Thread deleted");
    }
  }

  void goToPlaceInfoScreen(int i) async {
    List<bool> voteInformation = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => placeInfo(listOfPlaces[i])),
    );
    print(voteInformation);
  }

  bool isThreadLocationEmpty(List coordinates) {
    for (var elem in listOfUsedCoordinates) {
      if (eq(coordinates, elem)) {
        print("Location is not free");
        return false;
      }
    }
    print("Location is free");
    return true;
  }

  void goToAddThreadScreen() async {

    if (isThreadLocationEmpty([userCoordinates[0], userCoordinates[1]])) {
      List newThreadInformation = await Navigator.push(
        context,
        CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => addThread([userCoordinates[0], userCoordinates[1]])),
      );
      print(newThreadInformation);
      if (newThreadInformation != null && newThreadInformation[0] != "") {
        if (newThreadInformation[1][0] != null &&
            newThreadInformation[1][0] != null) {
          setNewThread(newThreadInformation);
        }
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: Text('Thread or marker already exists in this location.'),
            );
          });
    }
  }

  void setNewThread(List newThreadInformation) {

    listOfThreads.add(Thread(listOfThreads.length+1, newThreadInformation[0], "thread2.json", [false, false], newThreadInformation[1], 0));
    double x = newThreadInformation[1][0];
    double y = newThreadInformation[1][1];
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId((listOfThreads.length).toString() + "t"),
            position: LatLng(x, y),
            icon: threadMarker,
            anchor: const Offset(0.5, 0.5),
            onTap: () {
              goToUsersThreadScreen(listOfThreads.length-1);
            }
        ),
      );
      listOfUsedCoordinates.add([x, y]);
    });

    print(newThreadInformation);

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:  Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0), // here the desired height
              child: AppBar(
                title: Text("Toripolliisi"),
                elevation: 0.0,
                actions: [
                  IconButton(
                      icon: Image.asset('assets/help.png'),
                      onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (context) => AboutWidget(),
                    ),
                  },
                  )
                ],
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height /1.4,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      markers: _markers,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                      target: LatLng(65.013287, 25.464802),
                      zoom: 11,
                ),)
                  ),
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Add a new thread "),
                          FloatingActionButton(
                            onPressed: () {goToAddThreadScreen();},
                            tooltip: "Google",
                            child: Icon(Icons.add),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width /30,
                            height: MediaQuery.of(context).size.height /8,
                          ),
                        ]
                      ),
                  ),
                ]
              ),
            ),
        ));
  }
}


class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Utils {
  static String mapStyle = '''
  [
  {
    "featureType": "poi",
    "elementType": "labels.text",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  }
]
  ''';
}

class AboutWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Help'),
      content: Column(
        children: [
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.red,),
                Text("For student"),
              ],),),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.purple[600],),
                Text("Sight"),
              ],),),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.deepOrangeAccent,),
                Text("Restaurant or bar"),
              ],),),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.indigo),
                Text("Sports"),
              ],),),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.purpleAccent,),
                Text("Good to know"),
              ],),),
          Container(
            child: Row (
              children: [
                ImageIcon(AssetImage("assets/thread.png"), color: Colors.purple[200]),
                Text("Thread"),
              ],),),
        ],
      ),
      actions: [
        TextButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // background
            onPrimary: Colors.blue, // foreground
          ),
          child: Text("Close"),
          onPressed: () {Navigator.pop(context);},
        ),
      ],
    );
  }
}
