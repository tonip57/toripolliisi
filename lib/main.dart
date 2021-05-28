import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toripolliisi/addThread.dart';
import 'package:toripolliisi/Place.dart';
import 'package:toripolliisi/Thread.dart';
import 'package:toripolliisi/Message.dart';
import 'package:toripolliisi/User.dart';
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
  User user;

  Function eq = const ListEquality().equals;


  //Creating place- and thread-objects
  @override
  void initState() {
    listOfPlaces.add(Place("Torinranta ja Toripolliisi", "sight", "toripolliisi1.jpg", "Torinranta on kesäaikaan täynnä tekemistä. Kahvilat ja terassit sekä kauniit maisemat houkuttelevat kaikenikäisiä oululaisia viettämään alueella aikaa.Torilta löytyy myös kenties Oulun tunnetuin nähtävyys, Toripolliisi -patsas. ", "Torinranta is full of things to do in summer. Cafés and terraces as well as beautiful landscapes attract Oulu residents of all ages to spend time in the area. There you can also find perhaps Oulu's most famous attraction, the Toripolliisi statue.", "Toripolliisi patsaan nimi tulee Oulun torilla vuosina 1934-1979 partioineilta kolmelta poliisilta. He valvoivat torialueen kuria ja järjestystä. ", "The name of the statue “Toripolliisi” comes from the three police officers who patrolled the Oulu market square in 1934-1979. They supervised the discipline and order of the market area.", [false, false], [65.013287, 25.464802], 566));
    listOfPlaces.add(Place("Yliopisto - Linnanmaa", "forStudent", "yliopisto_linnanmaa3.jpg", "Linnanmaan pääkampukselta löytyvät Oulun Yliopiston humanistinen, luonnontieteellinen, kasvatustieteiden, teknillinen ja tieto- ja sähkötekniikan tiedekunta, Oulun yliopiston kauppakorkeakoulu sekä Oulun ammattikorkeakoulu. ", "The main campus of Linnanmaa includes the Faculty of Humanities, Natural Sciences, Education, Technology and Information and Electrical Engineering of the University of Oulu, the University of Oulu School of Economics and the Oulu University of Applied Sciences.", "Oulun Yliopisto on perustettu vuonna 1958 ja se on top 3 % maailman yliopistojen vertailussa. Vuonna 2020 kirjoilla oli yli 13 500 opiskelijaa ja 3400 työntekijää.", "The University of Oulu was founded in 1958 and is in the top 3% of the world's universities. In 2020, there were more than 13,500 students and 3,400 employees enrolled.", [false, false], [65.059310, 25.466325], 315));
    listOfPlaces.add(Place("Yliopisto - Kontinkangas", "forStudent", "yliopisto_kontinkangas1.jpg", "Kontinkankaan kampukselta löytyvät Oulun Yliopiston lääketieteellinen tiedekunta, biokemian ja molekyylilääketieteen tiedekunta sekä Oulun yliopistosairaala. ", "The Kontinkangas campus houses the Faculty of Medicine of the University of Oulu, the Faculty of Biochemistry and Molecular Medicine and Oulu University Hospital.", "Oulun Yliopiston lääketieteellinen tiedekunta on tunnettu mm. syntymäkohortti- ja ympäristöterveystutkimuksesta sekä sydän- ja verisuonitautien ja lastentautien tutkimuksesta. Lääketieteelliseen tiedekuntaan valitaan vuosittain noin 270 uutta opiskelijaa, jotka valmistuvat lääketieteen ja hammaslääketieteen lisensiaateiksi sekä terveystieteiden kandidaateiksi ja maistereiksi. ", "The Faculty of Medicine of the University of Oulu is known for e.g. birth cohort and environmental health research, and cardiovascular and pediatric research. Approximately 270 new students are selected for the Faculty of Medicine each year, graduating with licentiates in medicine and dentistry as well as bachelors and masters in health sciences.", [false, false], [65.008554, 25.521638], 34));
    listOfPlaces.add(Place("YTHS", "forStudent", "YTHS1.jpg", "YTHS:n huolehtii opiskelijoiden terveydenhuollosta. Opiskeluterveydenhuollon palveluihin kuuluvat esimerkiksi terveystarkastukset, suunterveydenhuolto, sairaanhoitopalveluiden järjestäminen sekä mielenterveyspalvelut. ", "FSHS (In finnish YTHS) takes care of students' health care. Student health care services include for example health examinations, oral health care, organization of medical care services and mental health services.", "Tammikuusta 2021 alkaen YTHS:n palveluita on saatavilla 45 paikkakunnalla ja säätiön omia palvelupisteitä on 23. YTHS:n omien palvelupisteiden piirissä on 95 prosenttia kaikista korkeakouluopiskelijoista. Kaikilla YTHS:n palvelujen piiriin kuuluvilla on käytössä sama palveluvalikoima opiskelupaikkakunnasta riippumatta.", "As of January 2021, FSHS's services will be available in 45 different locations. ", [false, false], [65.057678, 25.471298], 233));
    listOfPlaces.add(Place("Nallikari", "sight", "nallikari1.jpg", "Nallikarin pitkä hiekkaranta ja uskomattomat auringonlaskut vievät lomatunnelmaan hetkessä. Uimaranta houkuttelee paitsi auringonpalvojia, myös sporttisen rantapäivän viettäjiä ja sadepäivänä voi suunnata Edenin kylpylään tain Nallisportin urheiluhalliin. Talvella pääsee kävelemään jäätä pitkin ja voi nauttia Talvikylän nähtävyyksistä. ", "Nallikari's long sandy beach and incredible sunsets are like the sights of southern Europe. The beach attracts not only sunbathers, but also those who want to spend a sporty beach day. On a rainy day you can head to Eden Spa or Nallisport Sports Hall. In winter you can walk along the ice and enjoy the sights of Talvikylä.", "Kesäaikaan Nallikarin ja keskustan välisen matkan voi taittaa Potna-Pekan kyydissä. Potnapekka on Oulussa liikennöivä katujuna joka kulkee kahdella eri kiertoajelureitillä. Tiesitkö muuten, että Nallikaria kutsutaan myös Pohjolan Rivieraksi.", "Beautiful sandy beaches and magnificent sunsets have earned Nallikari the moniker of the ‘Riviera of the North’.",  [false, false],  [65.030494, 25.411436], 900));
    listOfPlaces.add(Place("Raksilan marketit", "goodToKnow", "raksila2.jpg", "Raksilan marketit on Raksilan kaupunginosassa sijaitseva kauppakeskittymä, josta löytyvät  Prisma, K-Citymarket, Sale sekä Alko ja Posti. ", "'Raksilan marketit' as in Raksila supermarket area, you can find two big hypermarkets Prisma and K-Citymarket, liquor store Alko and postal services. ", "Oulun Yliopisto on kaavailee uutta kampusaluetta Raksilan marketeille. Alustava valmistumispäivä uudelle kampukselle on 2020 luvun lopulla, mutta idea on herättänyt paljon vastustusta niin Yliopiston opiskelijoiden kuin muidenkin Oulun asukkaiden keskuudessa. ", "The University of Oulu is planning a new campus area for Raksila supermarkets. The initial graduation date for the new campus is at the end of the 2020s, but the idea has aroused a lot of opposition among both University students and other Oulu residents. ", [false, false], [65.010914, 25.491291], 96));
    listOfPlaces.add(Place("Viihdemaailma Ilona", "restaurantOrBar", "ilona3.jpg", "Viihdemaailma Ilona on yksi Oulun keskustan suosituimmista yökerhoista. Viisi osastoa London, Live, Disco, Retro ja Karaoke takaavat onnistuneen elämyksen moneen erilaiseen makuun. Viikonloppuisin on tarjolla livemusiikkia ja arkisin paikka voidaan nähdä täynnä opiskelijoita. ", "Ilona is one of Oulu's most popular nightclubs. On weekends Ilona offers live music and on weekdays it may be full of students.", "1500 neliömetrinsä myötä Ilona on yksi Pohjoismaiden suurimmista yökerhoista. Yökerhon yhteydessä sijaitsevan sporthenkisen jenkkiravintolan Sticky Wingersin kanssa yhteenlaskettu asiakaspaikkojen määrä on noin 1000.", "With its 1,500 square meters, Ilona is one of the largest nightclubs in the Nordic countries. The total number of customer seats with Sticky Wingers, a sports-minded american style restaurant attached to the nightclub, is about 1,000.", [false, false], [65.010995, 25.466640], 111));
    listOfPlaces.add(Place("Linnanmaan liikuntahalli", "sports", "linnanmaan-liikunta2.jpg", "Linnanmaan liikuntahallilta löytyy mahdollisuudet monenlaiseen urheiluun kuten koripallo, kuntosaliharjoittelu, lentopallo, musiikkiliikunta, salibandy, sulkapallo ja telinevoimistelu. Opiskelijan kannattaa tutustua Oulun korkeakoululiikunnan palveluihin tarkemmin https://www.oulunkorkeakoululiikunta.fi/fi ", "The Linnanmaa Sports Hall offers opportunities for a wide range of sports such as basketball, gym training, volleyball, music exercise, floorball and badminton. University Sports of Oulu offer academic sport services and other welfare services for students and staff of universities in Oulu. https://www.oulunkorkeakoululiikunta.fi/en", "Oulu on tunnettu pyöräilykaupunki. Oulussa on pyöräteitä yli 600 kilometriä eli noin 4 metriä jokaista asukasta kohti. Linnanmaan liikuntahalli sijaitsee pyöräilyn pääreitti 2:n varrella. Pyöräilyn pääreitteihin voi tutustua tarkemmin osoitteessa https://oulunseudunpyoraily.fi/paareitit/", "Oulu is a well-known cycling city. There are more than 600 kilometers of cycle paths in Oulu, or about 4 meters per inhabitant. Linnanmaa Sports Hall is located along the main cycling route 2. You can find out more about the main cycling routes at https://oulunseudunpyoraily.fi/paareitit/", [false, false], [65.055071, 25.471575], 39));
    listOfPlaces.add(Place("Oulu10", "goodToKnow", "oulu10_1.jpg", "Oulu10-palvelut tarjoaa neuvontaa ja ohjausta kaikkiin Oulun kaupungin palveluihin liittyen, kuten esimerkiksi Lipunmyynti Oulun joukkoliikenteeseen. Tarjolla on myös neuvontaa ja ohjausta valtiohallinnon palveluista sekä etäpalveluyhteydet. ", "Oulu10 Services offer advice and guidance related to all services of the City of Oulu, such as ticket sales for Oulu's public transport and Advice and guidance on state administration services. ", "Oulun kaupunki on perustettu vuonna 1605 ja se sijaitsee Pohjanlahden rannalla, Oulujoen suistossa. Tiesitkö, että Oulun kaupungin nimi tulee saamenkielisestä tulvavettä tarkoittavasta sanasta.","The city of Oulu was founded in 1605 and is located on the shores of the Gulf of Bothnia. Did you know that the name of the city of Oulu comes from the Sámi word for flood water.", [false, false], [65.013780, 25.470417], 9));
    listOfPlaces.add(Place("PSOAS", "goodToKnow", "psoas1.jpg", "PSOAS tarjoaa asumispalveluja opiskelijoille. PSOASin valikoimassa on useita eri kokoisia moderneja ja viihtyisiä opiskelija-asuntoja. ", "PSOAS provides housing services for students. PSOAS offers a variety of modern and comfortable student apartments of various sizes.", "PSOASin historia on täynnä monia mielenkiintoisia henkilöitä, jotka ovat vaikuttaneet eri tavoin säätiön toimintaan tai ovat muuten vain tunnettuja suurelle yleisölle. Tältä PSOASin Hall of Fame -listalta löytyvät muunmuassa entinen NHL -jääkiekkoilija Jussi Jokinen ja Emma-kummitus. ", "The history of PSOAS is full of many interesting individuals who have influenced the activities of the foundation in various ways or are otherwise only known to the general public. This PSOAS Hall of Fame list includes former NHL hockey player Jussi Jokinen and the ghost Emma.", [false, false], [65.017182, 25.478804], 77));

    listOfThreads.add(Thread(1, "Ensimmainen lanka", "thread1.db", [false, false], [65.0, 25.4], 325, false, [Message("user521", "fjlejfsihfishosfhfiefefefef", "22.05.2021", "14:36"), Message("user521", "fjlejfsihfishosfhfiefefefef", "22.05.2021", "14:36"), Message("user521", "fjlejfsihfishosfhfiefefefef", "22.05.2021", "14:36"), Message("user521", "fjlejfsihfishosfhfiefefefef", "22.05.2021", "14:36"), Message("user521", "fjlejfsihfishosfhfiefefefef", "22.05.2021", "14:36"), Message("user521", "fjlejfsihfishosfhfiefefefef", "22.05.2021", "14:36"), Message("user521", "fjlejfsihfishosfhfiefefefef", "22.05.2021", "14:36")]));
    listOfThreads.add(Thread(2, "Keskustelu 2", "thread2.db", [false, false], [65.0, 25.5], 12, false, [Message("user123", "Oletteko käyneet täällä?", "22.05.2021", "14:32"), Message("user12", "Pittääpä käyä kattomassa. Mitäs kaikkea täältä oikeen löytyy?", "22.05.2021", "19:33")]));

    user = User("testUser", "1234", "email@email.com", "Test", "User");

    setUserMarker();
    setThreadMarker();
    super.initState();
  }

  //Sets user image
  void setUserMarker() async {
    userMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/userLocation.png");
  }

  //Sets thread image
  void setThreadMarker() async {
    threadMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/thread.png");
  }

  //Sets places to map
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

  //Sets threads to map
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

  //Sets user to map
  void setUserMarkerToMap() {
    _markers.add(
      Marker(
          markerId: MarkerId("user"),
          position: LatLng(userCoordinates[0], userCoordinates[1]),
          icon: userMarker,
          anchor: const Offset(0.5, 0.5),
          consumeTapEvents: true,
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

  //Function for clicking thread marker
  void goToThreadScreen(int i) async {
    Thread threadInformation = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => threadScreen(listOfThreads[i], user)),
    );
    print("Users vote: " + threadInformation.usersVote.toString());
  }

  //Function for clicking users own thread
  void goToUsersThreadScreen(int i) async {
    Thread threadInformation = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => usersThread(listOfThreads[i], user)),
    );
    print(threadInformation.isDeleted);
    if (threadInformation.isDeleted == true) {
      Marker marker = _markers.firstWhere((marker) => marker.markerId.value == threadInformation.id.toString() + "t",orElse: () => null);
      setState(() {
        _markers.remove(marker);
      });
      int count = 0;
      for (var elem in listOfUsedCoordinates) {
        if (eq(elem, threadInformation.coordinates)) {
          break;
        }
        count++;
      }
      listOfUsedCoordinates.removeAt(count);
      print("Thread deleted");
    }
    print("Users vote: " + threadInformation.usersVote.toString());
  }

  //Function for clicking place marker
  void goToPlaceInfoScreen(int i) async {
    List<bool> voteInformation = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => placeInfo(listOfPlaces[i])),
    );
    print(voteInformation);
  }

  //Checks if thread location is free
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

  //Function for clicking "Create a new thread" -button.
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

  //Sets new thread when user creates one in addThread.dart
  void setNewThread(List newThreadInformation) {

    listOfThreads.add(Thread(listOfThreads.length+1, newThreadInformation[0], "thread" + (listOfThreads.length+1).toString() + ".db", [false, false], newThreadInformation[1], 0, false, []));
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
                      initialCameraPosition: CameraPosition(
                      target: LatLng(65.013287, 25.464802),
                      zoom: 11,
                ),)
                  ),
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Create a new thread "),
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
      title: Text('Icons on the map:'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
                Text("Restaurant / bar"),
              ],),),
          Container(
            child: Row (
              children: [
                Icon(Icons.location_pin, color: Colors.indigo),
                Text("Sport facility"),
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
          Container(
            height: 10,
          ),
          Container(
            child: Text("Pressing the icon on the map opens more detailed information about the place. To join a conversation, select the thread icon. Add a new conversation thread from the (+) icon at the bottom."),
          ),
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
