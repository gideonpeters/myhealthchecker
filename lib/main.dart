import 'package:flutter/material.dart';
import 'package:mhc/bt-controller.dart';
import 'package:mhc/contact_page.dart';
import 'package:mhc/home.dart';
import 'package:mhc/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    return MaterialApp(
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

  void switchLed() {
    setState(() {
      ledState = !ledState;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child:
            _pageIindex == 0 ? Home(sensorValue: sensorValue) : ContactPage(),
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
        onPressed: switchLed,
        tooltip: 'Switch LED',
        child:
            _pageIindex == 0 ? Icon(Icons.power_settings_new) : Icon(Icons.add),
      ),
    );
  }
}
