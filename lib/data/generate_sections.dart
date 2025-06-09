import 'dart:convert';
import 'dart:io';

class Section {
  final String sectionId;
  final String sectionTitle;
  final String chapterTitle;
  final String bookName;
  int progress;

  Section({
    required this.sectionId,
    required this.sectionTitle,
    required this.chapterTitle,
    required this.bookName,
    this.progress = 0,
  });

  @override
  String toString() {
    return '''
Section(
  sectionId: '$sectionId',
  sectionTitle: '$sectionTitle',
  chapterTitle: '$chapterTitle',
  bookName: '$bookName',
  progress: $progress,
)
''';
  }
}

void main() async {
  try {
    // 读取JSON文件
    String filePath = 'D:/brain_learning/lib/data/filtered_titles.json';
    String jsonString = await File(filePath).readAsString();
    List<dynamic> jsonData = jsonDecode(jsonString);

    // 初始化列表
    List<Section> sections = [];
    List<String> bookNameList = []; // 存储唯一的 bookName

    // 用于跟踪当前的 bookName 和 chapterTitle
    String? currentBookName;
    String? currentChapterTitle;

    // 递归解析函数
    void _parseItems(List<dynamic> items) {
      for (var item in items) {
        if (item is Map) {
          int level = item['level'] ?? 0;
          String title = item['title'] ?? '';
          String id = item['id'] ?? '';

          if (level == 0) {
            // 遇到新的 book，更新 bookName 并加入 bookNameList（去重）
            currentBookName = title;
            if (!bookNameList.contains(currentBookName!)) {
              bookNameList.add(currentBookName!);
            }
            currentChapterTitle = null; // 重置 chapterTitle
          } else if (level == 1) {
            // 遇到新的 chapter，更新 chapterTitle
            currentChapterTitle = title;
          } else if (level == 2) {
            // 创建 Section 对象
            sections.add(
              Section(
                sectionId: id,
                sectionTitle: title,
                chapterTitle: currentChapterTitle ?? '',
                bookName: currentBookName ?? '',
              ),
            );
          }

          // 递归解析子项
          if (item.containsKey('children') && item['children'] is List) {
            _parseItems(item['children']);
          }
        }
      }
    }

    _parseItems(jsonData);

    // 生成 Dart 文件内容
    String output = '''
// This file is auto-generated. Do not edit manually.

import 'package:flutter/material.dart';

// 定义 Section 类
class Section {
  final String sectionId;
  final String sectionTitle;
  final String chapterTitle;
  final String bookName;
  int progress;

  Section({
    required this.sectionId,
    required this.sectionTitle,
    required this.chapterTitle,
    required this.bookName,
    this.progress = 0,
  });
}

// 唯一的 bookName 列表
List<String> bookNameList = <String>[
${bookNameList.map((e) => '  \'$e\','.replaceAll("'", r"\'")).join('\n')}
];

// 获取所有 Sections
List<Section> getSections() {
  return <Section>[
${sections.map((e) => '  ${e.toString().replaceAll("'", r"\'")},').join('\n')}
  ];
}
''';

    // 写入到 Dart 文件
    String outputFilePath = 'D:/brain_learning/lib/data/sections_data.dart';
    await File(outputFilePath).writeAsString(output);
    print('Sections and book names have been written to $outputFilePath');
  } catch (e) {
    print('Error: $e');
  }
}
