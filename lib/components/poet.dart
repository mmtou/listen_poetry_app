import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'poet_item.dart';
import '../utils/http.dart';
import 'empty.dart';

class Poet extends StatefulWidget {
  @override
  _PoetState createState() => _PoetState();
}

class _PoetState extends State<Poet> with AutomaticKeepAliveClientMixin {
  List ? list;
  int pageNum = 1;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
      header:
          BezierCircleHeader(backgroundColor: Theme.of(context).primaryColor),
      footer:
          BezierBounceFooter(backgroundColor: Theme.of(context).primaryColor),
      onRefresh: () => refresh(),
      onLoad: () => onLoad(),
      child: this.list == null
          ? Empty('暂无数据~')
          : ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: this.list!.length,
              separatorBuilder: (BuildContext context, int index) => Container(
                    height: 12,
                  ),
              itemBuilder: (BuildContext context, int index) {
                var item = this.list![index];
                return PoetItem(item);
              }),
    );
  }

  refresh() async {
    this.pageNum = 1;
    this.list = [];
    await this.getList();
    return true;
  }

  onLoad() async {
    pageNum += 1;
    await this.getList();
    return true;
  }

  // 诗人列表
  getList() async {
    var data = await Http().get('/poet/list?pageNum=$pageNum');
    if (data != null) {
      List list = data['list'];
      this.list = this.list ?? [];
      setState(() {
        this.list!.addAll(list);
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
