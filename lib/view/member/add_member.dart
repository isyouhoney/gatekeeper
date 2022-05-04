import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gatekeeper/controller/member_provider.dart';
import 'package:gatekeeper/model/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({Key? key}) : super(key: key);

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  late TextEditingController _controller;
  XFile? img;
  late GoogleSignInAccount _account;
  late Member<dynamic> _data;
  late String _type;
  late dynamic _args;
  int _idx = -1;
  late User user;

  _AddMemberPageState() {
    _controller = TextEditingController();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _args = Get.arguments;

    if (_args.containsKey('account')) {
      _account = Get.arguments['account'];
    } else {
      Get.offAllNamed('/login_screen');
    }

    _type = _args['type'];
    _data = _args['member'];

    if (_args.containsKey('index')) {
      _idx = _args['index'];
      user = _data.getMember(_args['index']);
      _controller.text = _data.getMember(_idx).name;
    } else {
      user = User('name', {});
      // _data.addMember(_data.getMember(_idx));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(207, 212, 174, 178),
        title: Text('My ' + _args['type']),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          labelText: 'Name', suffixIcon: Icon(Icons.person)),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(207, 216, 139, 146),
                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.add_a_photo),
                        onPressed: () async {
                          img = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          // _data.getMember(_idx).imgs.add(img!.path);
                          if (_idx < 0) {
                            _data.addMember(_controller.text).then((v1) {
                              _data.addImg(_idx, img!.path).then((v2) {
                                if (v2.isNotEmpty) {
                                  _idx = v1;
                                }
                                setState(() {});
                              });
                            });
                          } else {
                            _data.addImg(_idx, img!.path).then((value) {
                              setState(() {});
                            });
                          }

                          setState(() {});
                        },
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Visibility(
                visible: (_data.getMember(_idx).imgs.isEmpty) ? false : true,
                child: Container(
                    height: 150,
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Container(
                            width: 10,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: _data.getMember(_idx).imgs.length,
                        itemBuilder: (context, index) {
                          var itemImg =
                              _data.getMember(_idx).imgs.keys.toList()[index];
                          return Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(itemImg)),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: GestureDetector(
                                      onTap: (() {
                                        _data.deleteImg(_idx, itemImg);
                                        setState(() {});
                                      }),
                                      child: CircleAvatar(
                                          backgroundColor: Colors.redAccent,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ))))
                            ],
                          );
                        })),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(207, 223, 176, 181)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                        ),
                        onPressed: () {
                          if (_controller.text.isEmpty) {
                            Get.snackbar('Name Empty', '이름을 입력하세요.');
                          } else if (_data.getMember(_idx).imgs.isEmpty) {
                            Get.snackbar('Image Empty', '사진을 등록하세요.');
                          } else {
                            if (_args != null && _args.containsKey('index')) {
                              // _data.updateMember(_args['index'],
                              // _data.getMember(_idx)(_controller.text, _data.getMember(_idx).imgs));
                              Get.snackbar(
                                  'Information Registered', '등록되었습니다.');
                            }
                            _data.updateUserName(_idx, _controller.text);
                            Get.offAllNamed('/member_list', arguments: _args);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Text('Confirm'),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (_args != null && _args.containsKey('index'))
                      ? true
                      : false,
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(207, 202, 187, 189)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                          ),
                          onPressed: () {
                            Get.snackbar('Delete', '삭제되었습니다.');
                            // _data.deleteImg(_idx, img!.path);
                            _data.deleteMember(_idx);

                            Get.offAllNamed('/member_list', arguments: _args);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Text('Delete'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
