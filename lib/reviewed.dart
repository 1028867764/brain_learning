import 'package:flutter/material.dart';

class Reviewed extends StatefulWidget {
  @override
  State<Reviewed> createState() => _ReviewedState();
}

class _ReviewedState extends State<Reviewed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '已复习',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        leadingWidth: 80,
        leading: Row(
          children: [
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(children: []),
    );
  }
}
