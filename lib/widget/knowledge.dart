import 'package:brain_learning/main.dart';
import 'package:flutter/material.dart';
import '../widget/text_highligh_widget.dart';
import '../data/sections_data.dart';

class Knowledge extends StatefulWidget {
  List<Section>? knowledge;
  final String whichStage;
  final Function(Section) onStarPressed; // 添加回调函数参数
  final double topGap;
  Knowledge({
    super.key,
    required this.knowledge,
    required this.whichStage,
    required this.onStarPressed,
    required this.topGap,
  });
  @override
  State<Knowledge> createState() => _KnowledgeState();
}

class _KnowledgeState extends State<Knowledge> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: widget.topGap),
        if (widget.knowledge != null)
          for (int i = 0; i < (widget.knowledge?.length ?? 0); i++)
            Container(
              margin: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Container(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: IntrinsicWidth(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[300],
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(0),
                                              bottomLeft: Radius.circular(0),
                                              bottomRight: Radius.circular(12),
                                            ),
                                          ),
                                          child: SelectableText(
                                            widget.knowledge![i].bookName,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10),

                              // 替换你原来的"文字背景下半部分填充颜色"部分
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: TextHighlightWidget(
                                  text: widget.knowledge![i].sectionTitle,
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.white,
                                  ),
                                  highlightHeight: 10, // 填充高度
                                  highlightColor: Colors.lightBlue.withOpacity(
                                    0.3,
                                  ), // 填充颜色
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SelectableText(
                                  widget.knowledge![i].chapterTitle,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        if (widget.whichStage == 'toLearn')
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: kBilibiliPink.withOpacity(0.2),
                                  border: Border.all(
                                    color: Colors.pink.withOpacity(
                                      0.1,
                                    ), // 设置边框颜色
                                    width: 2, // 设置边框宽度
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                child: Text(
                                  '学',
                                  style: TextStyle(
                                    color: kBilibiliPink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              // 调用回调函数，传递当前section
                              widget.onStarPressed(widget.knowledge![i]);
                            },
                          ),
                        if (widget.whichStage == 'toReview')
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.centerLeft,
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
                                  '归',
                                  style: TextStyle(
                                    color: coolapkGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              // 调用回调函数，传递当前section
                              widget.onStarPressed(widget.knowledge![i]);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
