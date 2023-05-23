import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dataCuaca = "";

  late Future _data;

  Future getDataCuaca() async {
    // Uri url = Uri.parse("https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=69bb7ab71dec32d98ebab160cf39cb85");
    Uri url = Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=jember&appid=69bb7ab71dec32d98ebab160cf39cb85");
    final res = await http.get(url);
    final decode = jsonDecode(res.body);
    final decodeData = jsonDecode(res.body)["city"]["name"];
    // return decodeData; 
    return res.body; 
    // print(res.body);
    // print(res.statusCode);
    // // cuaca = 
    // // print(decode);
    // print(decodeData);
    // setState(() {
    //   dataCuaca = res.body;
    // });
  }


  // getCurrentPosition() async {
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   print(position);
  // }

  // getCurrentPosition() async {
  //   /// Determine the current position of the device.
  //   ///
  //   /// When the location services are not enabled or permissions
  //   /// are denied the `Future` will return an error.
  //   Future<Position> _determinePosition() async {
  //     bool serviceEnabled;
  //     LocationPermission permission;

  //     // Test if location services are enabled.
  //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       // Location services are not enabled don't continue
  //       // accessing the position and request users of the 
  //       // App to enable the location services.
  //       return Future.error('Location services are disabled.');
  //     }

  //     permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         // Permissions are denied, next time you could try
  //         // requesting permissions again (this is also where
  //         // Android's shouldShowRequestPermissionRationale 
  //         // returned true. According to Android guidelines
  //         // your App should show an explanatory UI now.
  //         return Future.error('Location permissions are denied');
  //       }
  //     }
      
  //     if (permission == LocationPermission.deniedForever) {
  //       // Permissions are denied forever, handle appropriately. 
  //       return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //     } 

  //     // When we reach here, permissions are granted and we can
  //     // continue accessing the position of the device.
  //     return await Geolocator.getCurrentPosition();
  //   }
  // }


  @override
  void initState() {
    // getDataCuaca();
    _data = getDataCuaca();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: 
          ListView(

            children: [
              // ElevatedButton(onPressed: (){
              //   print("Testtt");
              //   _data = getDataCuaca();
              //   // initState(){
              //   //   getDataCuaca();
              //   // };
              //   // getDataCuaca();          
              //   },
              //   child: Text("Data Cuaca")
              // ),
              FutureBuilder(
                future: _data,
                builder: (context, snapshot){
                  if (snapshot.hasError){
                    return Text("terjadi kesalahan ${snapshot.hasError}");
                  }
                  if (snapshot.hasData){
                    final newData = jsonDecode(snapshot.data);
                    final newData_new = jsonDecode(snapshot.data)["list"];
                    final newData2 = json.decode(snapshot.data).length;
                    print(newData2);
                    print(newData["list"].length);
                    print(newData_new.length);
                    // print(newData["list"]);
                    
                    return Container(
                      width: double.infinity,
                      height: 350,
                      child: Column(
                        children: [
                          Text("Predisi Cuaca Terkini di ${newData["city"]["name"]}"),
                          Expanded(
                            child: ListView.builder(
                              itemCount: newData_new.length,
                              itemBuilder: (context, index) {
                                var current_data = newData_new[index];
                                var waktu = current_data["dt"];
                                // var tempFah = current_data["main"]["temp"]; 
                                double temp = (current_data["main"]["temp"] - 273);
                                var date = DateTime.fromMillisecondsSinceEpoch(waktu * 1000).add(Duration(hours: 7));
                                return Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  decoration: BoxDecoration(
                                    color: Colors.amber
                                  ),
                                  child: Column(
                                    children: [
                                      Text("${date}"),
                                      // Text("${waktu} = ${date}"),
                                      // Text("${current_data["dt"]}"),
                                      Text(current_data["weather"][0]["main"]),
                                      Text("${double.parse((temp).toStringAsFixed(2))} Celcius")
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                    
                    // return Container(
                    //   child: Column(
                    //     children: [
                    //       Text(snapshot.data),
                    //       TextFormField(
                    //         controller: TextEditingController(text: snapshot.data),
                    //       )
                    //     ],
                    //   )
                    // );
                  }
                  else{
                    return CircularProgressIndicator();
                  }
                }
                ),
              
              // Text(dataCuaca),
              // ElevatedButton(onPressed: (){
              //   print("Testtt2");
              //   print(getCurrentPosition());
              //   },
              //   child: Text("Data Posisi")
              // )
            ],
          )
        ,
      ),
    );
  }
}
