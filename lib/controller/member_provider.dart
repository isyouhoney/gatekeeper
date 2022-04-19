import 'dart:convert';
import 'package:gatekeeper/controller/login_service.dart';
import 'package:gatekeeper/model/member.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path/path.dart';

// import 'package:dio/dio.dart';

class MemberType {}

class FamilyType extends MemberType {}

class VisitorType extends MemberType {}

class Member<T extends MemberType> extends GetConnect {
  // 네트워크 통신(http)
  UserProvider user;
  late List<MapEntry<int, User>> person;
  late String memberType;

  // 생성자
  Member({required this.user}) {
    person = [];
    if (this is Member<FamilyType>) {
      memberType = 'member';
    } else if (this is Member<VisitorType>) {
      memberType = 'guest';
    }
  }

  Future<int> addMember(String name) async {
    var aid = user.id;
    // var name = '';
    // var img = u.imgs[0];

    final form = FormData({
      // 'file': MultipartFile(File(img).readAsBytes(), filename: img),
      'name': name
    });
    final response = await post(
        'https://gate-keeper-v1.herokuapp.com/acct/${aid}/${memberType}', form);
    print('${response.body} ${response.statusCode} ${url} ${response}');

    print('acct: ${response.body}');
    // u.imgs[0] = response.body['url'];
    User u = User(name, {});
    int idx = person.length;
    person.add(MapEntry(response.body['id'], u));
    return idx;
  }

  // void updateMember(int idx, User u) {
  //   person[idx] = u;
  // }

  User getMember(int idx) {
    return person[idx].value;
  }

  Future<String> addImg(int idx, String filePath) async {
    var aid = user.id;
    var mid = person[idx].key;
    final form = FormData(
        {'file': MultipartFile(filePath, filename: basename(filePath))});
    String url =
        'https://gate-keeper-v1.herokuapp.com/${memberType}/${aid}/${mid}/img';
    final response = await post(url, form);
    print(
        'addImg : ${response.body} ${response.statusCode} ${url} ${response}');

    if (response.statusCode == null) {
      Get.snackbar('이미지 업로드 실패',
          '서버에 이미지를 전송하던 중 오류가 발생했습니다. 이미지 파일이 크거나 잘못된 파일일 경우 문제가 발생할 수 있습니다. 다시 업로드하시기 바랍니다.');
      return '';
    }
    person[idx].value.imgs[response.body['url']] = response.body['id'];

    return response.body['url'];
  }

  void deleteImg(int idx, String url) {
    var aid = user.id;
    var id = person[idx].value.imgs[url];
    delete('https://gate-keeper-v1.herokuapp.com/${memberType}/${aid}/img/${id}')
        .then((response) {
      print('delImg : ${response.body} ${response.statusCode} ${url}');
    });

    person[idx].value.imgs.remove(url);
  }

  void updateUserName(int idx, String name) {
    var mid = person[idx].key;
    // final form = FormData({'name': name});
    String url =
        'https://gate-keeper-v1.herokuapp.com/acct/${memberType}/${mid}';
    put(url, json.encode({'name': name})).then((response) {
      print(
          'update : ${response.body} ${response.statusCode} ${url} ${response}');
    });
    person[idx].value.name = name;
  }

  Future<int> getSize() async {
    person = [];
    String url =
        'https://gate-keeper-v1.herokuapp.com/acct/${user.id}/${memberType}s';
    var response = await get(url);
    print('gethistory :  ${response.body} ${response.statusCode} ${url}');

    for (var j = 0; j < response.body.length; j++) {
      var data = response.body[j];
      var name = data['name'];
      var id = data['id'];
      var img = <String, int>{};

      url = 'https://gate-keeper-v1.herokuapp.com/${memberType}/${id}/imgs';
      var img_response = await get(url);
      print('getImgs :  ${response.body} ${response.statusCode} ${url}');
      for (var i = 0; i < img_response.body.length; i++) {
        img[img_response.body[i]['url']] = img_response.body[i]['id'];
      }

      person.add(MapEntry(id, User(name, img)));
    }

    return person.length;
  }

  void deleteMember(int idx) {
    var mid = person[idx].key;
    String url =
        'https://gate-keeper-v1.herokuapp.com/acct/${memberType}/${mid}';
    delete(url).then((response) {
      print('delhistory :  ${response.body} ${response.statusCode} ${url}');
    });

    person.removeAt(idx);
    sleep(Duration(seconds: 2));
  }
}
