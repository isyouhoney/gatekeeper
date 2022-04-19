import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gatekeeper/controller/login_service.dart';
import 'package:gatekeeper/controller/visit_record.dart';

import 'package:gatekeeper/model/visitor.dart';
import 'package:gatekeeper/view/home/Drawer.dart';
import 'package:gatekeeper/view/home/home_header.dart';
import 'package:gatekeeper/view/home/timeline.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get_connect.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class VisitTimeline extends StatefulWidget {
  const VisitTimeline({Key? key}) : super(key: key);
  @override
  _VisitTimelineState createState() => _VisitTimelineState();
}

class _VisitTimelineState extends State<VisitTimeline> {
  late GoogleSignInAccount _account;
  late UserProvider _user;

  @override
  void initState() {
    super.initState();
    if (Get.arguments.containsKey('account')) {
      _account = Get.arguments['account'];
    } else {
      Get.offAllNamed('/login_screen');
    }

    if (Get.arguments.containsKey('user')) {
      _user = Get.arguments['user'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.white,
            Colors.white,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Gate Keeper'),
        ),
        drawer: MDrawer(user: _user),
        body: Timeline(user: _user),
      ),
    );
  }
}
