import 'package:firebase_core/firebase_core.dart';
import 'package:gatekeeper/controller/login_service.dart';
import 'package:gatekeeper/controller/noti_service.dart';
import 'package:gatekeeper/view/noti_page.dart';
import 'package:gatekeeper/view/_/join.dart';
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
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(_googleSignIn);
  // Get.put(UserProvider());

  runApp(GetMaterialApp(
      initialBinding:
          BindingsBuilder.put(() => NotificationController(), permanent: true),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        color: Color.fromARGB(207, 212, 174, 178),
      )),
      initialRoute: "/login_screen",
      getPages: [
        GetPage(name: "/join", page: () => JoinPage()),
        GetPage(name: "/member_list", page: () => AccountPage()),
        GetPage(name: "/add_member", page: () => AddMemberPage()),
        GetPage(name: "/login_screen", page: () => InitialPage()),
        GetPage(name: "/home_screen", page: () => VisitTimeline()),
        GetPage(name: "/mypage", page: () => MyPage()),
        GetPage(name: "/face_register", page: () => GetImage()),
        GetPage(name: "/noti_page", page: () => Notice())
      ]));
}
