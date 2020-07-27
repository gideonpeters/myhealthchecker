import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'contact_model.dart';

class ContactDB extends ChangeNotifier {
  static const String _boxName = 'contactBox';

  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  void getContacts() async {
    try {
      var box = await Hive.openBox<Contact>(_boxName);

      _contacts = box.values.toList();
      // box.close();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void addContact(Contact contact) async {
    try {
      var box = await Hive.openBox<Contact>(_boxName);

      await box.put(contact.id, contact);

      _contacts = box.values.toList();
      box.close();

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
