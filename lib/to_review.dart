import 'package:brain_learning/main.dart';
import 'package:flutter/material.dart';
import 'widget/text_highligh_widget.dart';
import 'data/sections_data.dart';
import 'widget/knowledge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widget/text_highligh_widget.dart';
import 'widget/progress_bar_painter.dart';

class ToReview extends StatefulWidget {
  final String selectedBook;
  ToReview({super.key, required this.selectedBook});

  @override
  State<ToReview> createState() => _ToReviewState();
}

class _ToReviewState extends State<ToReview> {
  List<Section>? waitToReview = [];
  List<String>? alreadyLearned = [];
  List<String>? studyAgain = [];
  late List<Section> onlyThisBook;
  int alreadyLearnedCount = 0;
  int totalCount = 1;
  double finishedPercent = 0;
  late Size screenSize;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialTask();
    loadKnowledge();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  String countPercentage(int a, int b) {
    double calculation = a / b;
    double tenTimesCalculation = calculation * 100;
    String result = tenTimesCalculation.toStringAsFixed(2);
    return result;
  }

  void _initialTask() {
    setState(() {
      onlyThisBook =
          getSections
              .where((section) => section.bookName == widget.selectedBook)
              .toList();
    });
  }

  Future<void> loadKnowledge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('alreadyLearned');
    if (jsonString != null) {
      List<String> loadedList = List<String>.from(
        json.decode(jsonString),
      ); // 反序列化为列表
      alreadyLearned = loadedList;

      setState(() {
        waitToReview =
            onlyThisBook
                .where(
                  (section) =>
                      (alreadyLearned?.contains(section.sectionId) ?? false),
                )
                .toList();
        alreadyLearnedCount = waitToReview!.length;
        totalCount = onlyThisBook.length;
      });
    }
  }

  void _deleteAlreadyLearned(String root) {
    studyAgain?.add(root);
    alreadyLearned?.removeWhere(
      (element) => studyAgain?.contains(element) ?? false,
    );
  }

  Future<void> _clearAll() async {
    alreadyLearned?.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(alreadyLearned); // 转换为 JSON 字符串
    prefs.setString('alreadyLearned', jsonString);

    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // 设置圆角半径
            ),
            backgroundColor: Colors.white,

            content: Text(
              '已全部清除！',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 关闭弹窗
                  // 在这里执行确认操作
                },
                child: Text(
                  '确定',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        },
      );
      loadKnowledge();
    });
  }

  // 处理星星点击事件
  Future<void> _handleStarPressed(Section section) async {
    _deleteAlreadyLearned(section.sectionId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(alreadyLearned); // 转换为 JSON 字符串
    prefs.setString('alreadyLearned', jsonString);

    setState(() {
      loadKnowledge();
    });
  }

  @override
  Widget build(BuildContext context) {
    String percentage = countPercentage(alreadyLearnedCount, totalCount);
    screenSize = MediaQuery.of(context).size;
    finishedPercent = alreadyLearnedCount / totalCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '待复习',
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
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    child: Knowledge(
                      knowledge: waitToReview,
                      whichStage: 'toReview',
                      onStarPressed: _handleStarPressed,
                      topGap: 100,
                    ),
                  ), // 传递回调函数
                  Positioned(
                    child: Container(
                      width: screenSize.width * 0.75,
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Card(
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              SizedBox(height: 5), // 高度5
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('学习进度：', style: TextStyle(fontSize: 10)),
                                  Text(
                                    '$percentage %',
                                    style: TextStyle(
                                      fontSize: 12, // 高度12
                                      fontWeight: FontWeight.bold,
                                      color: kBilibiliPink,
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                child: CustomPaint(
                                  size: Size(
                                    screenSize.width * 0.7,
                                    5, // 高度
                                  ), // 设置进度条的宽度和高度
                                  painter: ProgressBarPainter(
                                    progress: finishedPercent,
                                  ), // 传入进度值
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '您已搞定',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    '$alreadyLearnedCount',
                                    style: TextStyle(
                                      fontSize: 12, // 高度12
                                      fontWeight: FontWeight.bold,
                                      color: kBilibiliPink,
                                    ),
                                  ),
                                  Text(
                                    '节',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: cyberpunkGreen.withOpacity(0.2),
                                      border: Border.all(
                                        color: coolapkGreen.withOpacity(
                                          0.8,
                                        ), // 设置边框颜色
                                        width: 1, // 设置边框宽度
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      '一键归零',
                                      style: TextStyle(
                                        color: coolapkGreen,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            0,
                                          ), // 设置圆角半径
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Text(
                                          '请注意！',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        content: Text(
                                          '你确定要归零吗？',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(
                                                context,
                                              ).pop(); // 关闭弹窗
                                            },
                                            child: Text(
                                              '再想想',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _clearAll();
                                              Navigator.of(
                                                context,
                                              ).pop(); // 关闭弹窗
                                              // 在这里执行确认操作
                                            },
                                            child: Text(
                                              '确定',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
