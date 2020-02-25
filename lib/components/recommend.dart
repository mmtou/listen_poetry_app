import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'empty.dart';
import 'poet_item.dart';
import 'poetry_item.dart';

import '../utils/http.dart';

class Recommend extends StatefulWidget {
  @override
  _RecommendState createState() => _RecommendState();
}

class _RecommendState extends State<Recommend>
    with AutomaticKeepAliveClientMixin {
  var list;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
      header:
          BezierCircleHeader(backgroundColor: Theme.of(context).primaryColor),
      onRefresh: () => refresh(),
      child: this.list == null
          ? Empty('暂无数据~')
          : ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: this.list.length,
              separatorBuilder: (BuildContext context, int index) => Container(
                height: 12,
              ),
              itemBuilder: (BuildContext context, int index) {
                var item = this.list[index];
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
    );
  }

  refresh() async {
    await getList();
    return true;
  }

  getList() async {
    List data = await Http().get('/recommend/list');
    if (data != null) {
      setState(() {
        this.list = data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.getList();
  }

  @override
  bool get wantKeepAlive => true;
}
