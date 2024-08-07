import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wakelock/wakelock.dart'; // Import Wakelock package
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  // Enable Wakelock to keep the screen on
  Wakelock.enable();

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
  bool _mute = false;
  String baseUrl = 'http://192.168.0.107:5000';

  @override
  void initState() {
    super.initState();
    _loadBaseUrl();
  }

  Future<void> _loadBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      baseUrl = prefs.getString('baseUrl') ?? 'http://192.168.0.107:5000';
    });
  }

  Future<void> _setBaseUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', url);
    setState(() {
      baseUrl = url;
    });
  }

  Future<void> _setVolume(double volume) async {
    final url = Uri.parse('$baseUrl/set_volume');
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

  Future<void> _shutdown() async {
    final url = Uri.parse(
        '$baseUrl/shutdown'); // Assuming '/shutdown' endpoint exists on your server
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'action': 'shutdown'}),
    );
    if (response.statusCode == 200) {
      print('Shutdown initiated');
    } else {
      print('Failed to initiate shutdown');
    }
  }

  Future<void> _openFacebook() async {
    final url = Uri.parse('$baseUrl/open_facebook');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'action': 'open_facebook'}),
    );

    if (response.statusCode == 200) {
      print('Opening Facebook');
    } else {
      print('Failed to open Facebook');
    }
  }

  Future<void> _restart() async {
    final url = Uri.parse(
        '$baseUrl/restart'); // Assuming '/restart' endpoint exists on your server
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'action': 'restart'}),
    );
    if (response.statusCode == 200) {
      print('Restart initiated');
    } else {
      print('Failed to initiate restart');
    }
  }

  Future<void> _openYoutube() async {
    final url = Uri.parse('$baseUrl/open_youtube');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'action': 'open_youtube'}),
    );
    if (response.statusCode == 200) {
      print('Opening Youtube');
    } else {
      print('Failed to open Youtube');
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

  void _muteVolume() {
    setState(() {
      if (!_mute) {
        _mute = true;
        _setVolume(0);
      } else {
        _mute = false;
        if (_volume >= 0.99) {
          _setVolume(0.99);
        } else {
          _setVolume(_volume);
        }
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

  Future<void> _openCustomweb() async {
    final url = Uri.parse('$baseUrl/open_customweb');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'action': 'open_customweb'}),
    );
    if (response.statusCode == 200) {
      print('Opening Custom Web');
    } else {
      print('Failed to open Custom Web');
    }
  }

  Future<void> _showSettingsDialog() async {
    TextEditingController _controller = TextEditingController(text: baseUrl);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Settings'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Base URL',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _setBaseUrl(_controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildSquare(int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (index == 0) {
            _decreaseVolume();
          } else if (index == 1) {
            _increaseVolume();
          } else if (index == 2) {
            _muteVolume();
          } else if (index == 3) {
            _openFacebook();
          } else if (index == 4) {
            _openYoutube();
          } else if (index == 7) {
            _openCustomweb();
          } else if (index == 8) {
            _restart();
          } else if (index == 9) {
            _shutdown();
          }
        },
        child: Container(
          margin: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              colors: [Colors.green, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Center(
            child: index == 0
                ? Icon(
                    Icons.volume_down,
                    color: Colors.white,
                    size: 130,
                  )
                : index == 1
                    ? Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 130,
                      )
                    : index == 2
                        ? Icon(
                            _mute == false
                                ? Icons.volume_off
                                : Icons.volume_mute,
                            color: Colors.white,
                            size: 130,
                          )
                        : index == 3
                            ? Icon(
                                Icons.facebook,
                                color: Colors.white,
                                size: 130,
                              )
                            : index == 4
                                ? Icon(
                                    Icons.video_collection,
                                    color: Colors.white,
                                    size: 130,
                                  )
                            : index == 7
                                ? Icon(
                                    Icons.open_in_browser,
                                    color: Colors.white,
                                    size: 130,
                                  )
                            : index == 8
                                ? Icon(
                                    Icons.restart_alt_sharp,
                                    color: Colors.white,
                                    size: 130,
                                  )
                                : index == 9
                                    ? Icon(
                                        Icons.power_settings_new,
                                        color: Colors.white,
                                        size: 130,
                                      )
                                    : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          Positioned(
            right: 16,
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                _showSettingsDialog();
              },
            ),
          ),
        ],
      ),
    );
  }
}
