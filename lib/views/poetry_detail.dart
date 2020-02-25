import 'package:flutter/material.dart';
import '../components/empty.dart';
import '../utils/common.dart';
import '../utils/http.dart';

class PoetryDetail extends StatefulWidget {
  final poetry;

  PoetryDetail(this.poetry);

  @override
  _PoetryDetailState createState() => _PoetryDetailState();
}

class _PoetryDetailState extends State<PoetryDetail> {
  var detail = {};

  @override
  Widget build(BuildContext context) {
    var poetryExtend = detail['poetryExtend'];

    List tabs = [
      {'name': '注', 'content': getAnnotationWidget(poetryExtend)},
      {'name': '译', 'content': getTranslationWidget(poetryExtend)},
      {'name': '诗', 'content': getPoetryWidget(widget.poetry)},
      {'name': '评', 'content': getIntroWidget(poetryExtend)},
      {'name': '赏', 'content': getAppreciationWidget(poetryExtend)}
    ];

    return DefaultTabController(
      initialIndex: 2,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: TabBar(
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            tabs: tabs.map((tab) {
              return Tab(
                child: Text(
                  tab['name'],
                  style: TextStyle(fontSize: 18),
                ),
              );
            }).toList(),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => Common.showDetailMore(
                  context, 1, widget.poetry['id'],
                  content:
                      '${widget.poetry['title']} \n${widget.poetry['authorName']} \n${widget.poetry['content']}'),
            )
          ],
        ),
        body: TabBarView(
          children: tabs.map((tab) {
            Widget widget = tab['content'];
            return widget;
          }).toList(),
        ),
      ),
    );
  }

  getDetail() async {
    var data = await Http().get('/poetry/${widget.poetry['id']}') ?? {};
    setState(() {
      this.detail = data;
    });
  }

  // 诗词widget
  getPoetryWidget(poetry) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(16),
//                    decoration: BoxDecoration(border: Border.all()),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Text(
                    poetry['title'],
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600, height: 1),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Text(
                    poetry['authorName'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    '${poetry['content']}',
                    style: TextStyle(fontSize: 18, height: 2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 翻译
  getTranslationWidget(poetryExtend) {
    return poetryExtend == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : poetryExtend['translation'] == null ||
                poetryExtend['translation'].isEmpty
            ? Empty('暂无翻译~')
            : Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    poetryExtend['translation'],
                    style: TextStyle(
                      height: 1.8,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
  }

  // 评析
  getIntroWidget(poetryExtend) {
    return poetryExtend == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : poetryExtend['intro'] == null || poetryExtend['intro'].isEmpty
            ? Empty('暂无评析~')
            : Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    poetryExtend['intro'],
                    style: TextStyle(
                      height: 1.8,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
  }

  // 注释
  getAnnotationWidget(poetryExtend) {
    return poetryExtend == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : poetryExtend['annotation'] == null ||
                poetryExtend['annotation'].isEmpty
            ? Empty('暂无注释~')
            : Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    poetryExtend['annotation'],
                    style: TextStyle(
                      height: 1.8,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
  }

  // 赏析
  getAppreciationWidget(poetryExtend) {
    return poetryExtend == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : poetryExtend['appreciation'] == null ||
                poetryExtend['appreciation'].isEmpty
            ? Empty('暂无赏析~')
            : Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    poetryExtend['appreciation'],
                    style: TextStyle(
                      height: 1.8,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
  }

  @override
  void initState() {
    super.initState();
    this.getDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
