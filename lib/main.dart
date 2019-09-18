import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences sharedPreferences;
  String advice = '';
  int counter = 0;

  @override
  void initState() {
    super.initState();

    // Load data at startup from shared preferences
    SharedPreferences.getInstance().then((SharedPreferences pref) {
      sharedPreferences = pref;
      String savedAdvice = sharedPreferences.getString('advice');
      int savedCounter = sharedPreferences.getInt('counter');

      if (savedAdvice == null) {
        savedAdvice = '';
      }
      if (savedCounter == null) {
        savedCounter = 0;
      }

      setState(() {
        advice = savedAdvice;
        counter = savedCounter;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('App 1'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                // Text 1
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '$advice',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),

                // Text 2
                Text(
                  '$counter',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Text('Fetch'),
          onPressed: _fetchPost,
        ),
      ),
    );
  }

  _fetchPost() async {
    final url = 'https://api.adviceslip.com/advice';
    final response = await http.get(url);
    dynamic body = json.decode(response.body);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print(response.body);
      setState(() {
        advice = body['slip']['advice'];
        counter += 1;
      });

      // get SharedPrefrence Instance
      final prefs = await SharedPreferences.getInstance();
      // set value
      prefs.setString('advice', advice);
      prefs.setInt('counter', counter);
    } else {
      // If that response was not OK, throw an error.
      print('Failed to load post');
      // throw Exception('Failed to load post');
    }
  }
}
