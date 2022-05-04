import 'package:flutter/material.dart';
import 'package:gatekeeper/controller/login_service.dart';
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
  late UserProvider _userProvider = UserProvider();

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
                  Get.defaultDialog(
                      title: '로그아웃 하시겠습니까?',
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            RaisedButton(
                                child: Text('아니요'),
                                color: Color.fromARGB(207, 121, 121, 121),
                                onPressed: () async {
                                  Get.back();
                                }),
                            Spacer(),
                            RaisedButton(
                                child: Text('네'),
                                color: Color.fromARGB(207, 223, 176, 181),
                                onPressed: () async {
                                  // _userProvider.deleteUser(_account.email);

                                  GoogleSignIn _googleSignIn =
                                      Get.find<GoogleSignIn>();
                                  Get.put(_googleSignIn);
                                  _googleSignIn.signOut();
                                  Get.offAllNamed("/login_screen",
                                      arguments: null);
                                  Get.snackbar('Log Out', '로그아웃되었습니다.');
                                }),
                          ],
                        ),
                      ));
                  // Get.toNamed("/login_screen", arguments: null);
                },
              ),
              ProfileMenu(
                text: "Out",
                icon: "assets/icons/Log out.svg",
                press: () {
                  Get.defaultDialog(
                      title: '탈퇴 하시겠습니까?',
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            RaisedButton(
                                child: Text('아니요'),
                                color: Color.fromARGB(207, 121, 121, 121),
                                onPressed: () async {
                                  Get.back();
                                }),
                            Spacer(),
                            RaisedButton(
                                child: Text('네'),
                                color: Color.fromARGB(207, 223, 176, 181),
                                onPressed: () async {
                                  _userProvider.deleteUser(_account.email);

                                  GoogleSignIn _googleSignIn =
                                      Get.find<GoogleSignIn>();
                                  Get.put(_googleSignIn);
                                  _googleSignIn.signOut();
                                  Get.offAllNamed("/login_screen",
                                      arguments: null);
                                  Get.snackbar(
                                      "Account Withdrawal", "탈퇴되었습니다.");
                                }),
                          ],
                        ),
                      ));
                },
              ),
            ],
          ),
        ));
  }
}
