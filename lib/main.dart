import 'dart:async';
import 'dart:convert';
//import 'dart:html';
//import 'package:geocoding/geocoding.dart';
//import 'dart:html';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

//Api key:b036a111ab0f1bb3da5ae84737da45ad
//api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
void main() {
  runApp(MaterialApp(home: MyApp()));
}

TimeOfDay time1 = TimeOfDay.now();
DateTime date = DateTime.now();

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var temp;
  var description;
  var humidity;
  var windspeed;
  dynamic latitudeData = "";
  dynamic longitudeData = "";
  String currentCity;

  Future getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitudeData = geoposition.latitude.toString();
      longitudeData = geoposition.longitude.toString();
    });
  }

  getAddress() async {
    final coordinates = new Coordinates(latitudeData, longitudeData);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    currentCity = addresses.first.locality;
    setState(() {
      currentCity = addresses.first.locality;
    });
  }

  getWeather() async {
    // getCurrentLocation();
    var queryParameters = {
      'lat': latitudeData.toString(),
      'lon': longitudeData.toString(),
      'appid': 'b036a111ab0f1bb3da5ae84737da45ad',
      'units': 'metric'
    };
    var uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);
    //final url = "https://api.openweathermap.org/data/2.5/weather?";
    http.Response response = await http.get(uri);
    print(response.body);
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.humidity = results['main']['humidity'];
      this.windspeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();

    getCurrentLocation();
    Timer(Duration(seconds: 3), () {
      getAddress();
      getWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          title: Text(''),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
            icon: Icon(Icons.search),
            iconSize: 30,
            color: Colors.white,
          ),
        ),
        body: Container(
          child: Stack(
            children: [
              time1.hour >= 06 && time1.hour < 17
                  ? Image.asset('assets/sunny.jpg',
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity)
                  : Image.asset('assets/Night.jpg',
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity),
              Container(
                decoration: BoxDecoration(color: Colors.black38),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 100),
                              Text(
                                'The Weather in Your Location is',
                                style: GoogleFonts.lato(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '',
                                style: GoogleFonts.lato(
                                    fontSize: 13, color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  temp != null
                                      ? temp.toString() + '\u2103'
                                      : "Loading...",
                                  style: GoogleFonts.lato(
                                      fontSize: 85,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                                Row(
                                  children: [
                                    time1.hour >= 06 && time1.hour < 17
                                        ? SvgPicture.asset('assets/sun.svg',
                                            height: 32,
                                            width: 32,
                                            color: Colors.white)
                                        : SvgPicture.asset('assets/moon.svg',
                                            height: 32,
                                            width: 32,
                                            color: Colors.white),
                                    SizedBox(width: 7),
                                    Text(
                                      time1.hour >= 06 && time1.hour < 17
                                          ? 'Morning'
                                          : 'Night',
                                      style: GoogleFonts.lato(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ])
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Column(children: [
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white30))),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              Text(
                                "Wind Speed",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              FaIcon(FontAwesomeIcons.wind,
                                  color: Colors.white),
                              Text(
                                  windspeed != null
                                      ? windspeed.toString() + 'Km/h'
                                      : "Loading...",
                                  style: GoogleFonts.lato(
                                      fontSize: 13, color: Colors.white))
                            ]),
                            Column(
                              children: [
                                Text("Weather",
                                    style: GoogleFonts.lato(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                FaIcon(FontAwesomeIcons.cloud,
                                    color: Colors.white),
                                Text(
                                    description != null
                                        ? description.toString()
                                        : "Loading...",
                                    style: GoogleFonts.lato(
                                        fontSize: 13, color: Colors.white))
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Humidity",
                                  style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.water,
                                  color: Colors.white,
                                ),
                                Text(
                                    humidity != null
                                        ? humidity.toString() + '%'
                                        : "Loading...",
                                    style: GoogleFonts.lato(
                                        fontSize: 13, color: Colors.white))
                              ],
                            )
                          ])
                    ]),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var temperature, desc, humid, ws;
  String city;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.sun, color: Colors.black, size: 100),
              SizedBox(height: 70),
              Center(
                  child: SizedBox(
                      width: 250,
                      child: TextField(
                        onChanged: (val) {
                          city = val.toString();
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            hintText: 'Enter City Here',
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        textAlign: TextAlign.center,
                      ))),
              SizedBox(height: 70),
              ElevatedButton(
                  onPressed: () {
                    getOnSearch();
                    Timer(Duration(milliseconds: 1500), (){
                      setState(() {
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Weather",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.pacifico()),
                            content: Text(
                                'Temperature: $temperature \u2103\n'
                                        'Windspeed: $ws Km/hr\n'
                                        'Description: $desc\n'
                                        'Humidity: $humid' +
                                    '%',
                                style: GoogleFonts.lato()),
                          );
                        });
                        
                      });
                    });

                    
                  },
                  child: Text('Search',
                      style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)))
            ],
          ),
        ),
      ),
    );
  }

  getOnSearch() async {
    var queryParameters = {
      'q': city,
      'appid': 'b036a111ab0f1bb3da5ae84737da45ad',
      'units': 'metric'
    };
    var uri1 = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);
    http.Response response = await http.get(uri1);
    print(response.body);
    var results = jsonDecode(response.body);
    setState(() {
      this.temperature = results['main']['temp'];
      this.desc = results['weather'][0]['description'];
      this.humid = results['main']['humidity'];
      this.ws = results['wind']['speed'];
    });
  }
}
