import 'package:gatekeeper/controller/login_service.dart';
import 'package:gatekeeper/setting/input.dart';
import 'package:flutter/material.dart';
import 'package:gatekeeper/view/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addrController;
  late TextEditingController _pwdController;
  late GoogleSignInAccount _account;
  late UserProvider userProvider = UserProvider();

  _JoinPageState() {
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addrController = TextEditingController();
    _pwdController = TextEditingController();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments.containsKey('account')) {
      _account = Get.arguments['account'];
    } else {
      Get.offAllNamed('/login_screen');
    }
    // if (args != null) {
    //   var find = Get.find<Member>();
    //   User user = find.getMember(args['index']);
    _emailController.text = _account.email;
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
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "E-mail",
                suffixIcon: Icon(Icons.email_outlined),
              ),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                suffixIcon: Icon(Icons.phone),
              ),
            ),
            TextField(
              controller: _addrController,
              decoration: InputDecoration(
                labelText: 'Address',
                suffixIcon: Icon(Icons.home),
              ),
            ),
            // TextField(
            //   controller: _pwdController,
            //   decoration: InputDecoration(
            //     labelText: 'Password',
            //     suffixIcon: Icon(Icons.lock),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(40),
              child: FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(207, 223, 176, 181)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    )),
                  ),
                  onPressed: () {
                    userProvider.addUser(
                        _emailController.text,
                        _emailController.text,
                        _phoneController.text,
                        _addrController.text);
                    userProvider
                        .loginUser(_account.email, _account.email)
                        .then((value) {
                      Get.offAllNamed('/home_screen', arguments: {
                        'account': _account,
                        'user': userProvider
                      });
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Text('Register')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
