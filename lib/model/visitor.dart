import 'package:flutter/cupertino.dart';

enum Status {
  NON_REGISTRANT,
  REGISTRANT,
}

class VisitorData {
  const VisitorData(
      {required this.date,
      required this.name,
      required this.status,
      required this.img});

  final Status status;
  final String name;
  final DateTime date;
  final String img;
}
