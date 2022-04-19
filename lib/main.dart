import 'package:gatekeeper/controller/login_service.dart';
import 'package:gatekeeper/controller/member_provider.dart';
import 'package:gatekeeper/controller/visit_record.dart';
import 'package:gatekeeper/model/visitor.dart';
import 'package:gatekeeper/noti_page.dart';
import 'package:gatekeeper/setting/colors.dart';
import 'package:gatekeeper/view/home/home_screen.dart';
import 'package:gatekeeper/view/login_screen.dart';
import 'package:gatekeeper/view/member/member_list.dart';
import 'package:gatekeeper/view/member/add_member.dart';
import 'package:gatekeeper/view/mypage/face_register.dart';
import 'package:gatekeeper/view/mypage/mypage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:core';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(_googleSignIn);
  // Get.put(UserProvider());
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // scaffoldBackgroundColor: mobileBackgroundColor,
          appBarTheme: AppBarTheme(
        color: Color.fromARGB(207, 212, 174, 178),
      )),
      initialRoute: "/login_screen",
      getPages: [
        GetPage(name: "/member_list", page: () => AccountPage()),
        GetPage(name: "/add_member", page: () => AddMemberPage()),
        GetPage(name: "/login_screen", page: () => InitialPage()),
        GetPage(name: "/home_screen", page: () => VisitTimeline()),
        GetPage(name: "/mypage", page: () => MyPage()),
        GetPage(name: "/face_register", page: () => GetImage()),
        GetPage(name: "/noti_page", page: () => Notice())
      ]));
}
