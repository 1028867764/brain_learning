import 'data/sections_data.dart';
import 'package:flutter/material.dart';
import 'book_shelf.dart';

//B站粉红
const Color kBilibiliPink = Color(0xFFFB7299);
// 闲鱼科技蓝
const Color xianyuBlue = Color(0xFF00E5FF);
// 酷安绿
const Color coolapkGreen = Color(0xFF2E8B57);
// 赛博朋克绿
const Color cyberpunkGreen = Color(0xFF00FFD1);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '节节高升',
      home: GridViewExample(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // 设置背景为纯白色
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // 可选：设置 AppBar 的背景色为白色
          titleTextStyle: TextStyle(color: Colors.black), // 可选：设置标题文字颜色为黑色
        ),
      ),
    );
  }
}

class GridViewExample extends StatelessWidget {
  const GridViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          BookShelf(items: bookNameList),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.2,
                color: Colors.yellow,
                alignment: Alignment.center,
                child: Text('好棒哦', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
