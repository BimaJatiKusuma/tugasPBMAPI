import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
    Uri url = Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=mojokerto&appid=69bb7ab71dec32d98ebab160cf39cb85");
    final res = await http.get(url);
    return res.body; 
  }


  @override
  void initState() {
    // getDataCuaca();
    _data = getDataCuaca();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("APLIKASI PREDIKSI CUACA"),
        backgroundColor: Color.fromRGBO(140, 51, 95, 1),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _data,
        builder: (context, snapshot){
          if (snapshot.hasError){
            return Text("terjadi kesalahan ${snapshot.hasError}");
          }
          if (snapshot.hasData){
            final newData = jsonDecode(snapshot.data);
            final newData_new = jsonDecode(snapshot.data)["list"];
            final timezone = newData["city"]["timezone"];
            
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    child: Text("Prediksi Cuaca Terkini di ${newData["city"]["name"]}")
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: newData_new.length,
                      itemBuilder: (context, index) {
                        var current_data = newData_new[index];
                        var waktu = current_data["dt"];
                        double temp = (current_data["main"]["temp"] - 273);
                        var date = DateFormat('hh:mm d MMMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(waktu * 1000).add(Duration(seconds: timezone)));
                        return Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(239, 229, 237, 1),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            children: [
                              Text("${date}"),
                              Text(current_data["weather"][0]["main"]),
                              Text("Suhu: ${double.parse((temp).toStringAsFixed(2))} Celcius")
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
            
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        }
        ),
    );
  }
}
