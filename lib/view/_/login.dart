import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  // 앱 메인페이지
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Column(
        children: [
          Container(
            child: Text('SKIP'),
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 10, top: 20, bottom: 20),
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          Text(
            'Welcome to',
            style: TextStyle(fontSize: 40),
          ),
          Text(
            'Facelock',
            style: TextStyle(fontSize: 40),
          ),
          Padding(padding: EdgeInsets.only(bottom: 30)),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username, Email or Phone Number'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
                suffixIcon: Icon(Icons.remove_red_eye_outlined),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Checkbox(value: false, onChanged: (v) => print("checked $v")),
                Text('Remember Me?'),
                Spacer(),
                Text('Forgot Password?'),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: FractionallySizedBox(
              widthFactor: 1,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  )),
                ),
                onPressed: () => Get.toNamed("/mypage"),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Text('Login'),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: FractionallySizedBox(
              widthFactor: 1,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  )),
                ),
                onPressed: () {},
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Text('Sign in with Facebook')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
