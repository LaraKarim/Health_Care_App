import 'package:flutter/material.dart';
import 'package:healthapp/local_notification.dart';

class NotPage extends StatefulWidget {
  const NotPage({Key? key}) : super(key: key);

  @override
  State<NotPage> createState() => _NotpageState();
}

class _NotpageState extends State<NotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NOTIFICATIONAA"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            LocalNotification.showNotification(
                title: "noti", body: "this is TEST", payload: "this is simple");
          },
          child: Text('Show Notification'),
        ),
      ),
    );
  }
}
