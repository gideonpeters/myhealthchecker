import 'package:flutter/material.dart';
import 'package:mhc/core/contact_db.dart';
import 'package:mhc/core/contact_model.dart';
import 'package:provider/provider.dart';

class ContactPage extends StatelessWidget {
  ContactPage({Key key}) : super(key: key);
  final List<int> contacts = [1, 2, 3, 4, 5];
  @override
  Widget build(BuildContext context) {
    final contactDB = Provider.of<ContactDB>(context);
    contactDB.getContacts();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Anesi Igebu',
              style: TextStyle(fontSize: 30),
            ),
            // FlatButton(onPressed: _showMyDialog, child: Text('Add Contact')),
            SizedBox(height: 30),
            Text('EMERGENCY CONTACTS'),
            SizedBox(height: 30),
            Container(
                height: 400,
                child: ListView.builder(
                    itemCount: contactDB.contacts.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ContactCard(contact: contactDB.contacts[index]))),
          ],
        ));
  }
}

class ContactCard extends StatelessWidget {
  final Contact contact;
  const ContactCard({Key key, this.contact}) : super(key: key);

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
                child: Text(contact.name[0].toUpperCase()),
              ),
            ],
          ),
          SizedBox(width: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(contact.name),
              SizedBox(height: 10),
              Text(contact.number),
            ],
          )
        ],
      ),
    );
  }
}
