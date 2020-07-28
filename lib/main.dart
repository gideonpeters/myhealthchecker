import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mhc/bt-controller.dart';
import 'package:mhc/contact_page.dart';
import 'package:mhc/core/contact_db.dart';
import 'package:mhc/core/contact_model.dart';
import 'package:mhc/home.dart';
import 'package:mhc/map_page.dart';
import 'package:mhc/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'core/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ContactAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'My Health Checker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF45E4E1),
          primaryColorLight: Color(0xFF45E4E1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          MainScreen.routeName: (context) => MainScreen(),
          SplashScreen.routeName: (context) => SplashScreen(),
          // BluetoothApp.routeName: (context) => BluetoothApp()
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  static const routeName = '';
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIindex = 0;
  String sensorValue = "N/A";
  String oxygenValue = "N/A";
  bool ledState = false;

  @override
  initState() {
    super.initState();
    BTController.init(onData);
    scanDevices();
  }

  void onData(dynamic str) {
    setState(() {
      sensorValue = str;
    });
  }

  double getRandomNumber(double minimum, double maximum) {
    Random random = new Random();
    return random.nextDouble() * (maximum - minimum) + minimum;
  }

  void switchLed() {
    setState(() {
      ledState = !ledState;
      sensorValue = getRandomNumber(40.0, 150.0).toStringAsFixed(2);
      oxygenValue = getRandomNumber(95.0, 100.0).toStringAsFixed(2);
    });
    BTController.transmit(ledState ? '0' : '1');
  }

  Future<void> scanDevices() async {
    BTController.enumerateDevices().then((devices) {
      onGetDevices(devices);
    });
  }

  void onGetDevices(List<dynamic> devices) {
    Iterable<SimpleDialogOption> options = devices.map((device) {
      return SimpleDialogOption(
        child: Text(device.keys.first),
        onPressed: () {
          selectDevice(device.values.first);
        },
      );
    });

    SimpleDialog dialog = SimpleDialog(
      title: const Text('Choose a device'),
      children: options.toList(),
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  selectDevice(String deviceAddress) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    BTController.connect(deviceAddress);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    final contactDB = Provider.of<ContactDB>(context);
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Emergency Contact'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Contact Name'),
                    controller: nameController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Contact Number'),
                    controller: numberController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Visibility(
                visible: true,
                child: FlatButton(
                  child: Text('Save'),
                  onPressed: () async {
                    var newContact = Contact(
                        id: DateTime.now().toString(),
                        name: nameController.text,
                        number: numberController.text);

                    contactDB.addContact(newContact);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: _pageIindex == 0
            ? Home(sensorValue: sensorValue, oxygenValue: oxygenValue)
            : _pageIindex == 1 ? ContactPage() : MapPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIindex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: _pageIindex == 0
                    ? Theme.of(context).primaryColor
                    : Colors.black),
            title: new Text(''),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _pageIindex == 1
                      ? Theme.of(context).primaryColor
                      : Colors.black),
              title: new Text('')),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on,
                  color: _pageIindex == 2
                      ? Theme.of(context).primaryColor
                      : Colors.black),
              title: new Text('')),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.bluetooth,
          //         color: _pageIindex == 2
          //             ? Theme.of(context).primaryColor
          //             : Colors.black),
          //     title: new Text('')),
        ],
        onTap: (val) {
          setState(() {
            _pageIindex = val;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _pageIindex == 0
            ? switchLed
            : _pageIindex == 1 ? _showMyDialog : null,
        tooltip: 'Switch LED',
        child: _pageIindex == 0
            ? Icon(Icons.power_settings_new)
            : _pageIindex == 1 ? Icon(Icons.add) : null,
      ),
    );
  }
}
