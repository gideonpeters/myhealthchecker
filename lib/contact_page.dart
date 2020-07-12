import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  ContactPage({Key key}) : super(key: key);
  final List<int> contacts = [1, 2, 3, 4, 5];
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Anesi Igebu',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 30),
            Text('EMERGENCY CONTACTS'),
            SizedBox(height: 30),
            Container(
                height: 400,
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) =>
                        ContactCard())),
          ],
        ));
  }
}

class ContactCard extends StatelessWidget {
  const ContactCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
          SizedBox(width: 30),
          Column(
            children: <Widget>[
              Text('Gideon Peters'),
              SizedBox(height: 10),
              Text('07089324817'),
            ],
          )
        ],
      ),
    );
  }
}
