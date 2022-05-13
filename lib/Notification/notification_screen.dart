import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {

  late FirebaseMessaging messaging;
  bool noti = true;
  String msg = "Waiting ......";


  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    // TODO: implement initState
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) =>
    {
      print(value)
    });

    messaging.subscribeToTopic("messaging");

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      msg = event.notification!.body!;
      _getMsg(event.notification!.body!);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message Click!');
      print(message.notification!.body!);

      _setMsg(message.notification!.body!);
    });
  }

  _getMsg(String value) {
    print(value);
    setState(() {
      msg = value;
    });
  }

  _setMsg(String message) {
    print("Noti Msg : $message");
    setState(() {
      msg = message;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    // super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // _setMsg("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    noti = !noti;
                    !noti ? messaging.subscribeToTopic("messaging") : messaging
                        .unsubscribeFromTopic("messaging");
                  });
                },
                child: const Text(
                  "Notification",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
              ),
              noti
                  ? const Icon(Icons.toggle_off_outlined, color: Colors.black,)
                  : const Icon(Icons.toggle_on_outlined, color: Colors.green,),
            ],
          ),
          const SizedBox(height: 200,),
          Text(msg),
        ],
      ),
    );
  }
}
