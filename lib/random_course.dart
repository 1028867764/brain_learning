import 'package:brain_learning/main.dart';
import 'package:flutter/material.dart';
import 'data/sections_data.dart';
import 'widget/knowledge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'widget/reminder.dart';

class RandomCourse extends StatefulWidget {
  RandomCourse({super.key});

  @override
  State<RandomCourse> createState() => _RandomCourseState();
}

class _RandomCourseState extends State<RandomCourse> {
  List<String> unFinishedID = [];
  List<String> randomUnFinishedID = [];
  List<Section> randomSection = [];
  List<Section> unFinished = [];
  List<String>? totalSectionID = [];
  List<String>? alreadyLearned = [];
  late List<Section> onlyThisBook;
  int toLearnCount = 0;
  int totalCount = 1;
  late Size screenSize;
  bool _isLoading = true;
  bool _isRefresh = false;
  bool _isReminding = false;

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

  void _longPressCopy(bool newValue) {
    setState(() {
      _isReminding = newValue;
    });
  }

  // 从 before 中随机选择 n 个元素并添加到 after 中
  void selectRandomItems(List<String> before, List<String> after, int n) {
    final random = Random();

    // 如果 before 的长度小于 n，则直接将 before 的所有元素赋值给 after
    if (before.length <= n) {
      after.addAll(before);
    } else {
      // 否则，随机选取 n 个元素
      final selected = <String>{}; // 使用 Set 来避免重复选择

      // 确保从 before 中选出 n 个不重复的元素
      while (selected.length < n) {
        selected.add(before[random.nextInt(before.length)]);
      }

      after.addAll(selected);
    }
  }

  void _initialTask() {
    setState(() {
      totalSectionID = getSections.map((section) => section.sectionId).toList();
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
      unFinishedID =
          totalSectionID!
              .where((root) => !(alreadyLearned?.contains(root) ?? false))
              .toList();

      // 从 unFinishedID 中随机选择 7 个元素到 randomUnFinishedID
      selectRandomItems(unFinishedID, randomUnFinishedID, 7);

      randomSection =
          getSections
              .where(
                (section) => randomUnFinishedID.contains(section.sectionId),
              )
              .toList();
    });
  }

  // 处理星星点击事件
  Future<void> _handleStarPressed(Section section) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(alreadyLearned); // 转换为 JSON 字符串
    prefs.setString('alreadyLearned', jsonString);

    setState(() {
      loadKnowledge();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          '随机学习',
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
                  _isRefresh
                      ? const Center(child: CircularProgressIndicator())
                      : Positioned(
                        child: Knowledge(
                          knowledge: randomSection,
                          whichStage: 'randomCourse',
                          onStarPressed: _handleStarPressed,
                          topGap: 50,
                          longPressCopy: _longPressCopy,
                        ),
                      ),
                  Positioned(
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: cyberpunkGreen.withOpacity(0.2),
                            border: Border.all(
                              color: coolapkGreen.withOpacity(0.8), // 设置边框颜色
                              width: 1, // 设置边框宽度
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          child: Text(
                            '再来一次',
                            style: TextStyle(
                              color: coolapkGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        loadKnowledge();
                        randomUnFinishedID.clear();
                        _isRefresh = true;
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            _isRefresh = false;
                          });
                        });
                      },
                    ),
                  ),
                  Reminder(isShowed: _isReminding),
                ],
              ),
    );
  }
}
