import 'package:gatekeeper/controller/login_service.dart';
import 'package:gatekeeper/controller/member_provider.dart';
import 'package:flutter/material.dart';
import 'package:gatekeeper/model/member.dart';
import 'package:gatekeeper/setting/size_config.dart';
import 'package:gatekeeper/view/home/Drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late GoogleSignInAccount _account;
  late dynamic _data;
  late String _type;
  int _size = 0;

  @override
  void initState() {
    super.initState();
    var arg = Get.arguments;
    if (arg.containsKey('account')) {
      _account = arg['account'];
    } else {
      Get.offAllNamed('/login_screen');
    }
    if (arg.containsKey('type')) {
      _type = arg['type'];
      if (arg['type'] == 'family') {
        if (arg.containsKey('member')) {
          _data = arg['member'];
        } else {
          _data = Member<FamilyType>(user: arg['user']);
        }
      } else if (arg['type'] == 'visitor') {
        if (arg.containsKey('member')) {
          _data = arg['member'];
        } else {
          _data = Member<VisitorType>(user: arg['user']);
        }
      }
    }

    _data.getSize().then((value) {
      setState(() {
        _size = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Member List"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: Icon(Icons.add_reaction_outlined,
                    size: 38, color: Color.fromARGB(145, 254, 226, 83)),
                onPressed: () {
                  TextEditingController controller = TextEditingController();

                  Get.defaultDialog(
                      title: '신규 사용자 추가',
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: controller,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'Name',
                                hintMaxLines: 1,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 4.0))),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          RaisedButton(
                            onPressed: () async {
                              if (controller.text.isNotEmpty) {
                                int index =
                                    await _data.addMember(controller.text);
                                Get.toNamed('/add_member', arguments: {
                                  'index': index,
                                  'account': _account,
                                  'type': _type,
                                  'member': _data
                                })?.then((value) {
                                  print('back');
                                  var arg = value;
                                  if (arg.containsKey('type')) {
                                    _type = arg['type'];
                                    if (arg['type'] == 'family') {
                                      if (arg.containsKey('member')) {
                                        _data = arg['member'];
                                      } else {
                                        _data = Member<FamilyType>(
                                            user: arg['user']);
                                      }
                                    } else if (arg['type'] == 'visitor') {
                                      if (arg.containsKey('member')) {
                                        _data = arg['member'];
                                      } else {
                                        _data = Member<VisitorType>(
                                            user: arg['user']);
                                      }
                                    }
                                    // setState(() {});
                                  }
                                });
                              } else {
                                Get.snackbar('이름이 없습니다.', "Enter name");
                              }
                            },
                            child: Text(
                              '확인',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            color: Colors.redAccent,
                          )
                        ],
                      ),
                      radius: 10.0);

                  // Get.toNamed('/add_member', arguments: {
                  //   'account': _account,
                  //   'type': _type,
                  //   'member': _data
                  // })?.then((value) => setState(() {}));
                }),
          ),
        ],
      ),
      drawer: MDrawer(user: _data.user),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              // constraints: const BoxConstraints(maxHeight: 145),
              height: 70,
              decoration: BoxDecoration(
                color: Color.fromARGB(100, 212, 174, 178),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: _FamilyCnt(
                cnt: _size,
                type: _type,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SizedBox(
                width: 300,
                height: 650,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _size,
                  itemBuilder: (context, index) {
                    return Wrap(
                      children: [
                        Container(
                          height: 200,
                          width: 140,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(100, 212, 174, 178),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: GestureDetector(
                            child: Container(
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    _data.getMember(index).name,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.dosis(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                  child: _data.getMember(index).imgs.isEmpty
                                      ? Image.network(
                                          'https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-6.png')
                                      : Image.network(
                                          _data
                                              .getMember(index)
                                              .imgs
                                              .keys
                                              .toList()[0],
                                          width: 150,
                                          height: 150,
                                        ),
                                )
                              ]),
                            ),
                            onTap: () {
                              Get.toNamed('/add_member', arguments: {
                                'index': index,
                                'account': _account,
                                'type': _type,
                                'member': _data
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      //body: Container(child: ,),
    );
  }
}

class _FamilyCnt extends StatelessWidget {
  const _FamilyCnt({Key? key, required this.cnt, required this.type})
      : super(key: key);

  final int cnt;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            (type == 'family') ? '가족' : '등록방문자',
            style: GoogleFonts.dosis(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints(minWidth: 50, minHeight: 50),
          decoration: const BoxDecoration(
            color: Color.fromARGB(70, 46, 148, 173),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              '$cnt',
              style: GoogleFonts.dosis(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
