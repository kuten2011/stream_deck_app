import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Volume Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _volume = 0.5;

  Future<void> _setVolume(double volume) async {
    final url = Uri.parse('http://192.168.0.107:5000/set_volume');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'level': volume}),
    );
    if (response.statusCode == 200) {
      print('Volume set to $volume');
    } else {
      print('Failed to set volume');
    }
  }

  void _increaseVolume() {
    setState(() {
      if (_volume < 1.0) {
        _volume += 0.1;
        _setVolume(_volume);
      }
    });
  }

  void _decreaseVolume() {
    setState(() {
      if (_volume > 0.0) {
        _volume -= 0.1;
        _setVolume(_volume);
      }
    });
  }

  Widget buildSquare(int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: index == 0
            ? _increaseVolume
            : index == 1
                ? _decreaseVolume
                : null,
        child: Container(
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Center(
            child: index == 0
                ? Icon(Icons.volume_up, color: Colors.white, size: 130,)
                : index == 1
                    ? Icon(Icons.volume_down, color: Colors.white, size: 130,)
                    : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.cyan],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 35),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return buildSquare(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
