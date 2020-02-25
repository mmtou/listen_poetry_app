import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_tags/tag.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/empty.dart';
import '../components/poet_item.dart';
import '../components/poetry_item.dart';
import '../utils/http.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController textController = new TextEditingController();
  List<String> localHistory = [];
  List hotSearch = [];
  List searchResult = [];
  int pageNum = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: <Widget>[
          Container(
            width: 60,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '取消',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ),
          )
        ],
        title: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black.withOpacity(0.1)),
          child: TextField(
            cursorColor: Colors.white,
            controller: textController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white.withOpacity(0.7),
              ),
              border: InputBorder.none,
              hintText: this.hotSearch.length > 0
                  ? this.hotSearch[0]['keyword']
                  : '搜索诗词、诗人',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            style: TextStyle(color: Colors.white),
            textInputAction: TextInputAction.search,
            onEditingComplete: onSearch,
          ),
        ),
      ),
      body: textController.text != null && textController.text.isNotEmpty
          ? buildResult()
          : buildSearch(),
      backgroundColor: Colors.white.withOpacity(0.94),
    );
  }

  Widget buildSearch() {
    return ListView(
      children: <Widget>[
        Offstage(
          offstage: localHistory == null || localHistory.length == 0,
          child: ListTile(
            title: Text(
              '搜索历史',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            trailing:
                IconButton(icon: Icon(Icons.clear_all), onPressed: clearAll),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Tags(
            alignment: WrapAlignment.start,
            spacing: 14,
            itemCount: localHistory.length,
            itemBuilder: (int index) {
              return ItemTags(
                index: index,
                title: localHistory[index],
                activeColor: Colors.white,
                textActiveColor: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                onPressed: (Item i) => onTapItem(i.title),
              );
            },
          ),
        ),
        ListTile(
          title: Text(
            '热门搜索',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Tags(
            alignment: WrapAlignment.start,
            itemCount: hotSearch.length,
            spacing: 14,
            itemBuilder: (int index) {
              return ItemTags(
                index: index,
                title: hotSearch[index]['keyword'],
                activeColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                onPressed: (Item i) => onTapItem(i.title),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildResult() {
    return Container(
      child: EasyRefresh(
        header:
            BezierCircleHeader(backgroundColor: Theme.of(context).primaryColor),
        footer:
            BezierBounceFooter(backgroundColor: Theme.of(context).primaryColor),
        onRefresh: () => refresh(),
        onLoad: () => onLoad(),
        child: this.searchResult == null || this.searchResult.length == 0
            ? Empty('暂时没有您要找的内容~')
            : ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: this.searchResult.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Container(
                  height: 12,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var item = this.searchResult[index];
                  int recommendType = item['recommendType'];
                  if (recommendType == 1) {
                    return PoetryItem(item);
                  } else if (recommendType == 2) {
                    return PoetItem(item);
                  } else {
                    return Container();
                  }
                },
              ),
      ),
    );
  }

  getHotSearch() async {
    var data = await Http().get('/search/list');
    if (data != null) {
      setState(() {
        this.hotSearch = data;
      });
    }
  }

  getLocalHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keywords = (prefs.getStringList('localHistory') ?? []);
    setState(() {
      this.localHistory = keywords;
    });
  }

  setLocalHistory(String value) async {
    if (value != null) {
      value = value.trim();
      if (value != '') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> keywords = this.localHistory;
        if (!keywords.contains(value.trim())) {
          keywords.insert(0, value);
          if (keywords.length > 20) {
            keywords = keywords.sublist(0, 20);
          }
          await prefs.setStringList('localHistory', keywords);
        }
      }
    }
  }

  cleanLocalHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('localHistory');
    Navigator.of(context).pop();
    BotToast.showText(text: '清空成功');
    setState(() {
      this.localHistory = [];
    });
  }

  clearAll() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("确定清空搜索历史吗？"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "取消",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              FlatButton(
                onPressed: cleanLocalHistory,
                child: Text("确认"),
              ),
            ],
          );
        });
  }

  onTapItem(String input) {
    textController.text = input;
    this.onSearch();
  }

  onSearch() {
    // 关闭键盘
    FocusScope.of(context).requestFocus(FocusNode());
    if (textController.text == null || textController.text.trim().isEmpty) {
      if (this.hotSearch != null && this.hotSearch.length > 0) {
        textController.text = this.hotSearch[0]['keyword'];
      }
    }
    this.setLocalHistory(textController.text);
    setState(() {
      textController.text;
    });

    this.getResult();
  }

  getPoetry() async {
    var poetryData = await Http().get(
        '/poetry/list?keyword=${textController.text}&pageNum=$pageNum&pageSize=20');
    if (poetryData != null) {
      List poetryList = poetryData['list'] ?? [];
      poetryList = poetryList.map((item) {
        item['recommendType'] = 1;
        return item;
      }).toList();
      this.searchResult.addAll(poetryList);
    }
  }

  getResult() async {
    this.pageNum = 1;
    this.searchResult = [];
    var poetData = await Http()
        .get('/poet/list?keyword=${textController.text}&pageSize=10');
    if (poetData != null) {
      List poetList = poetData['list'] ?? [];
      poetList = poetList.map((item) {
        item['recommendType'] = 2;
        return item;
      }).toList();
      this.searchResult.addAll(poetList);
    }

    await this.getPoetry();

    setState(() {
      this.searchResult = this.searchResult;
    });
  }

  refresh() async {
    await this.getResult();
    return true;
  }

  onLoad() async {
    pageNum += 1;
    await this.getPoetry();
    setState(() {
      this.searchResult = this.searchResult;
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
    this.getLocalHistory();
    this.getHotSearch();
  }
}
