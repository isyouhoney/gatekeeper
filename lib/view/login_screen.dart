// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gatekeeper/controller/login_service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googleSignIn = Get.find<GoogleSignIn>();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        debugPrint('$account');
        // 로그인 시도
        UserProvider user = UserProvider();
        user.loginUser(account!.email, account.email).then((value) {
          // Get.put(user);
          Get.offAllNamed('/home_screen',
              arguments: {'account': account, 'user': user});
        });
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color.fromARGB(207, 212, 174, 178), Color(0xFF135058)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 80),
              child: Text(
                'GATE KEEPER',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    // fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 50,
                    color: Colors.white),
              ),
            ),
            Lottie.network(
                'https://assets5.lottiefiles.com/packages/lf20_Zl28Ck.json'),
            SizedBox(height: 100),
            OutlineButton(
              splashColor: Colors.white,
              onPressed: _handleSignIn,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              highlightElevation: 0,
              borderSide: BorderSide(color: Colors.white, width: 2),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage("image/google_logo_icon.png"),
                        height: 35.0),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            // fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 150),
          ],
        ),
      ),
    ));
  }
}
