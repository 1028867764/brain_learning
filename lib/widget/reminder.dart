import 'package:flutter/material.dart';

class Reminder extends StatefulWidget {
  final bool isShowed;
  Reminder({super.key, required this.isShowed});
  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.25,
      child:
          widget.isShowed
              ? Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('已复制内容', style: TextStyle(color: Colors.white)),
              )
              : SizedBox(),
    );
  }
}
