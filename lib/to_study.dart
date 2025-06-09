import 'package:brain_learning/main.dart';
import 'package:flutter/material.dart';
import 'widget/text_highligh_widget.dart';
import 'data/sections_data.dart';
import 'widget/knowledge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'widget/progress_bar_painter.dart';
import '../widget/text_highligh_widget.dart';

class ToStudy extends StatefulWidget {
  final String selectedBook;
  ToStudy({super.key, required this.selectedBook});

  @override
  State<ToStudy> createState() => _ToStudyState();
}

class _ToStudyState extends State<ToStudy> {
  List<Section>? waitToStudy = [];
  List<String>? alreadyLearned = [];
  late List<Section> onlyThisBook;
  int toLearnCount = 0;
  int totalCount = 1;
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
    double calculation = (1 - a / totalCount);
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
    }
    setState(() {
      waitToStudy =
          onlyThisBook
              .where(
                (section) =>
                    !(alreadyLearned?.contains(section.sectionId) ?? false),
              )
              .toList();

      toLearnCount = waitToStudy!.length;
      totalCount = onlyThisBook.length;
    });
  }

  // 将已学习的 section的 id 添加入 alreadyLearned 列表
  void _addAlreadyLearned(String root) {
    alreadyLearned?.add(root);
  }

  // 处理星星点击事件
  Future<void> _handleStarPressed(Section section) async {
    _addAlreadyLearned(section.sectionId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(alreadyLearned); // 转换为 JSON 字符串
    prefs.setString('alreadyLearned', jsonString);

    setState(() {
      loadKnowledge();
    });
  }

  @override
  Widget build(BuildContext context) {
    String percentage = countPercentage(toLearnCount, totalCount);
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          '待学习',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
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
                      knowledge: waitToStudy,
                      whichStage: 'toLearn',
                      onStarPressed: _handleStarPressed,
                      topGap: 66,
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
                                    progress: (1 - toLearnCount / totalCount),
                                  ), // 传入进度值
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '共有',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    '$toLearnCount',
                                    style: TextStyle(
                                      fontSize: 12, // 高度12
                                      fontWeight: FontWeight.bold,
                                      color: kBilibiliPink,
                                    ),
                                  ),
                                  Text(
                                    '节待学习',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
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
