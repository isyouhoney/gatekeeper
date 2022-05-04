import 'package:gatekeeper/controller/login_service.dart';
import 'package:gatekeeper/model/visitor.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class VisitorRecord extends GetConnect {
  late UserProvider user;
  VisitorRecord({required this.user});

  Future<List<VisitorData>> getRecord() async {
    print('user : ${user}');
    String url =
        'https://gate-keeper-v1.herokuapp.com/cam/${user.camId}/visitors';
    final response = await get(url);
    print('history :  ${response.body} ${response.statusCode} ${url}');

    List<VisitorData> result = [];
    if (response.statusCode == 200) {
      for (var i = 0; i < response.body.length; i++) {
        var data = response.body[i];
        var status = data['name'] == 'Unknown'
            ? Status.NON_REGISTRANT
            : Status.REGISTRANT;
        var visitdate = DateTime.parse(data['visitDate']).toLocal();
        var name = data['name'] == 'Unknown' ? "" : data['name'];
        var img = data['img'];
        print('${status} ${visitdate} ${name}');
        result.add(VisitorData(
          status: status,
          date: visitdate,
          name: name,
          img: img,
        ));
      }
    }
    return result;
  }
}
