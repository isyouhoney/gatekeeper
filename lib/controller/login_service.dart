import 'dart:convert';
import 'dart:io';

import 'package:get/get_connect.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider extends GetConnect {
  String token = '';
  int id = -1;
  String phone = '';
  String addr = '';
  int camId = -1;
  bool is_login = false;

  Future<void> addUser(
      String aid, String pwd, String phone, String addr) async {
    final form = {'acct_id': aid, 'pwd': pwd, 'phone': phone, 'addr': addr};

    final response = await post(
        'https://gate-keeper-v1.herokuapp.com/auth/register',
        json.encode(form));
    print('add User : ${response.body} ${response.statusCode} ${response}');
    id = response.body['id'];
    phone = response.body['phone'];
    addr = response.body['addr'];
    camId = response.body['camId'];
  }

  // Future<String> findUser(GoogleSignInAccount acct) async {
  //   var response = await get(
  //       'https://gate-keeper-v1.herokuapp.com/accts/acctId/${acct.email}');
  //   print('response : ${response.body} ${response.statusCode}');
  //   print('pwd : ${response.body['pwd']}');
  //   String pwd = response.body['pwd'];
  //   return pwd;
  // }

  // Post request

  void deleteUser(String email) {
    String url = 'https://gate-keeper-v1.herokuapp.com/accts/${email}';
    delete(url).then((response) {
      print('delUser :  ${response.body} ${response.statusCode} ${url}');
    });

    sleep(Duration(seconds: 2));
  }

  Future<int> loginUser(String uid, String pwd) async {
    var data = {'acct_id': uid, 'pwd': pwd};
    final response = await post(
        'https://gate-keeper-v1.herokuapp.com/auth/login', json.encode(data));
    print('login : ${response.body}'); // accessToken

    if (response.statusCode == HttpStatus.created) {
      // 201
      is_login = true;
      token = response.body['accessToken'];
      final res_id = await get(
          // token이용하여 Acct 정보 조회
          'https://gate-keeper-v1.herokuapp.com/auth/authenticate',
          headers: {'Authorization': 'Bearer ' + token});
      print('response.statusCode : ${response.statusCode}');

      if (res_id.statusCode == HttpStatus.ok) {
        // 200
        print(res_id.body);
        id = res_id.body['id'];
        phone = res_id.body['phone'];
        addr = res_id.body['addr'];
        camId = res_id.body['camId'];
        print('response.statusCode : ${response.statusCode == HttpStatus.ok}');
        print('res_id.statusCode : ${res_id.statusCode == HttpStatus.ok}');
        return HttpStatus.ok;
      }
    }
    return -1;
  }
}
