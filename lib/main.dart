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
  String _advice = '';
  int _counter = 0;
  bool _isButtonDisabled = false;
  Color _adviceColor = Colors.black;
  Color _actionColor = Colors.blue;

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
        _advice = savedAdvice;
        _counter = savedCounter;
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
                // Text 1 - advice
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '$_advice',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: _adviceColor,
                    ),
                  ),
                ),

                // Text 2 - counter
                Text(
                  '$_counter',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),

        // Floating button
        floatingActionButton: AbsorbPointer(
          absorbing: _isButtonDisabled,
          child: FloatingActionButton(
            child: _isButtonDisabled
                ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )
                : Icon(Icons.file_download),
            onPressed: _fetchPost,
            backgroundColor: _actionColor,
          ),
        ),
      ),
    );
  }

  _fetchPost() async {
    setState(() {
      _isButtonDisabled = true;
      _actionColor = Colors.blue;
    });
    final url = 'https://api.adviceslip.com/advice';
    final response = await http.get(url);

    setState(() {
      _isButtonDisabled = false;
      _actionColor = Colors.blue;
    });

    dynamic body = json.decode(response.body);

    // If server returns an OK response, parse the JSON.
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _advice = body['slip']['advice'];
        _counter += 1;
      });

      // get SharedPrefrence Instance
      final prefs = await SharedPreferences.getInstance();
      // set value
      prefs.setString('advice', _advice);
      prefs.setInt('counter', _counter);
    } else {
    // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      print('Failed to load post');
      setState(() {
        _advice = "Something's Wrong!";
        _adviceColor = Colors.red[800];
      });
    }
  }
}