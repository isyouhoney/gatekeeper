import 'package:flutter/material.dart';
import 'package:gatekeeper/view/mypage/profile_menu.dart';
import 'package:gatekeeper/view/mypage/profile_pic.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late GoogleSignInAccount _account;

  @override
  void initState() {
    super.initState();
    if (Get.arguments.containsKey('account')) {
      _account = Get.arguments['account'];
    } else {
      Get.offAllNamed('/login_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Mypage')),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              ProfilePic(),
              Text(_account.displayName!),
              Text(_account.email),
              SizedBox(height: 20),
              ProfileMenu(
                text: "Facial Information",
                icon: "assets/icons/User Icon.svg",
                press: () => {Get.toNamed("/face_register")},
              ),
              ProfileMenu(
                text: "address Information",
                icon: "assets/icons/Bell.svg",
                press: () {},
              ),
              ProfileMenu(
                text: "Log Out",
                icon: "assets/icons/Log out.svg",
                press: () {
                  Get.toNamed("/login_screen", arguments: null);
                },
              ),
            ],
          ),
        ));
  }
}
