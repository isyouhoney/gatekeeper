import 'dart:convert';

import 'package:get/get_connect.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class UserProvider extends GetConnect {
  String token = '';
  int id = -1;
  String phone = '';
  String addr = '';
  int camId = -1;
  bool is_login = false;
  // Post request
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
          'https://gate-keeper-v1.herokuapp.com/auth/authenticate',
          headers: {'Authorization': 'Bearer ' + token});

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
