import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String sensorValue;
  Home({Key key, this.sensorValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 700,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 25),
          Text(
            'Good Morning,',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            decoration: BoxDecoration(
              color: Color(0xFF45E4E1),
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Heart Rate'.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(sensorValue ?? '0',
                        style: TextStyle(color: Colors.white, fontSize: 50)),
                    Text(
                      'BPM',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
