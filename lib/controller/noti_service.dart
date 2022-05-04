import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController extends GetxController {
  // Service EntryPoint 객체화
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void onInit() async {
    // 권한 확인
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print(settings.authorizationStatus);
    _getToken();
    _onMessage();
    super.onInit();
  }

  // 디바이스 고유 토큰 확보 : firebase console 테스트 시 사용
  void _getToken() async {
    String? token = await messaging.getToken();
    try {
      print(token);
    } catch (e) {}
  }

  // *flutter_local_notification 라이브러리*
  // 1. channel 생성
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  // 2. 메인 채널로 정해줄 플러그인 생성
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _onMessage() async {
    // * local_notification 관련한 플러그인 활용 *
    // 1. 생성한 channel 메인 channel로 설정
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    // 2. 플러그인을 초기화하여 추가 설정
    await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
            android: AndroidInitializationSettings(
                '@mipmap/ic_launcher'), // 아이콘 설정 값
            iOS: IOSInitializationSettings()),
        // 해당 알림을 클릭했을 때 발동하는 콜백
        onSelectNotification: (String? payload) async {});

    // * onMessage 설정 *
    // 1. 콘솔에서 발송하는 메시지를 message 파라미터로 받아온다.
    // 메시지가 올 때마다 listen 내부 콜백이 실행
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // android 일 때만 flutterLocalNotification 을 대신 보여주는 거임. 그래서 아래와 같은 조건문 설정.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description),
          ),

          // 넘겨줄 데이터가 있으면 아래 코드를 써주면 됨.
          // payload: message.data['argument']
        );
      }
      print('foreground 상황에서 메시지를 받았다.');
      // 데이터 유무 확인
      print('Message data: ${message.data}');
      // notification 유무 확인
      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.body}');
      }
    });
  }
}
