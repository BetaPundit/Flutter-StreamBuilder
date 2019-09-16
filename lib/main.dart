import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  

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
                    'Demo Text',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),

                // Text 2
                Text(
                  '1',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold
                  ),
                ),                
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Text('Fetch'),
          onPressed: () {},
        ),
      ),
    );
  }

  Future<String> fetchPost() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/posts/1');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return response.body;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}