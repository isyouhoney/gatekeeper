import 'package:flutter/material.dart';
import 'package:gatekeeper/controller/login_service.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MDrawer extends StatefulWidget {
  UserProvider user;
  MDrawer({Key? key, required this.user}) : super(key: key);

  @override
  State<MDrawer> createState() => _MDrawerState(user: user);
}

class _MDrawerState extends State<MDrawer> {
  late GoogleSignInAccount _account;
  late UserProvider user;
  _MDrawerState({required this.user});

  @override
  void initState() {
    super.initState();
    if (Get.arguments.containsKey('account')) {
      _account = Get.arguments['account'];
    } else {
      Get.offAllNamed('/login_screen');
    }

    Get.arguments['user'] = user;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(_account.photoUrl!),
            ),
            accountName: Text(_account.displayName!),
            accountEmail: Text(_account.email),
            onDetailsPressed: () {},
            decoration: BoxDecoration(
                color: Color.fromARGB(207, 212, 174, 178),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
          ),
          ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey[850],
              ),
              title: Text('Home'),
              onTap: () {
                Get.toNamed('/home_screen',
                    arguments: {'account': _account, 'user': user});
              },
              trailing: Icon(Icons.arrow_forward_ios)),
          ListTile(
            leading: Icon(
              Icons.people,
              color: Colors.grey[850],
            ),
            title: Text('Family'),
            onTap: () {
              Get.toNamed('/member_list', arguments: {
                'account': _account,
                'type': 'family',
                'user': user
              });
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: Icon(
              Icons.record_voice_over,
              color: Colors.grey[850],
            ),
            title: Text('MyVistor'),
            onTap: () {
              Get.toNamed('/member_list', arguments: {
                'account': _account,
                'type': 'visitor',
                'user': user
              });
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: Icon(
              Icons.remove_red_eye,
              color: Colors.grey[850],
            ),
            title: Text('Monitoring'),
            onTap: () {},
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.grey[850],
            ),
            title: Text('MyPage'),
            onTap: () {
              Get.toNamed('/mypage', arguments: {'account': _account});
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
