import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'contact_model.g.dart';

@HiveType()
class Contact {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String number;

  Contact({
    this.id,
    this.name,
    this.number,
  });
}
