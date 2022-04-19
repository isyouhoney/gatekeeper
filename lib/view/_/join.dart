import 'package:gatekeeper/setting/input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 다른 파일이나 패키지를 가져옴
import 'package:get/get.dart';
import 'package:gatekeeper/controller/member_provider.dart';
import 'package:gatekeeper/model/member.dart';

class JoinPage extends StatefulWidget {
  // 앱 메인페이지
  const JoinPage({Key? key}) : super(key: key);

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  late TextEditingController _controller;
  XFile? img;

  _JoinPageState() {
    _controller = TextEditingController();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dynamic args = Get.arguments;
    if (args != null) {
      var find = Get.find<Member>();
      User user = find.getMember(args['index']);
      _controller.text = user.name;
      // img = XFile(user.imgs[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Input(
              labelText: "E-mail",
              suffixIcon: Icon(Icons.email_outlined),
            ),
            Input(
                labelText: 'Name',
                suffixIcon: Icon(Icons.account_circle_outlined)),
            Input(
                labelText: 'Assign Code',
                suffixIcon: Icon(Icons.account_circle)),
            Input(labelText: 'Password', suffixIcon: Icon(Icons.lock)),
            Input(
                labelText: 'Confirm Password',
                suffixIcon: Icon(Icons.lock_open)),
            Padding(
              padding: EdgeInsets.all(40),
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
                      child: Text('Register')),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Text('I forgot my Password'),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        )),
                      ),
                      onPressed: () {},
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          child: Text('Facebook')),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        )),
                      ),
                      onPressed: () {},
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          child: Text('Twitter')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
