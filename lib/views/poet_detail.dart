import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../components/avatar.dart';
import '../utils/favorite.dart';

import '../components/poetry_item.dart';
import '../utils/common.dart';
import '../utils/http.dart';

class PoetDetail extends StatefulWidget {
  final id;

  PoetDetail(this.id);

  @override
  _PoetDetailState createState() => _PoetDetailState();
}

class _PoetDetailState extends State<PoetDetail> {
  var detail;
  List ? list;
  int ? pageNum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => Common.showDetailMore(context, 2, widget.id,
                content: this.detail != null
                    ? this.detail['poetExtend']['description']
                    : ''),
          ),
        ],
      ),
      body: buildBody(),
      backgroundColor: Colors.white.withOpacity(0.94),
    );
  }

  Widget buildBody() {
    list![0] = (this.detail == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // 头像
                    Container(
                      padding: EdgeInsets.only(right: 16),
                      child: Avatar(detail['poet']['name']),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            detail['poet']['name'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          InkWell(
                            onTap: () => favorite(widget.id),
                            // 点赞数量
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    '${detail['poet']['likeCount'] == 0 ? '' : detail['poet']['likeCount']}'),
                                ((detail['favorited'] ?? false) ||
                                        detail['poet']['isLiked'])
                                    ? Icon(
                                        Icons.favorite,
                                        color: Theme.of(context).primaryColor,
                                        size: 18,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        size: 18,
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    detail['poetExtend']['description'] ?? '',
                    style: TextStyle(height: 1.5),
                  ),
                )
              ],
            ),
          ));

    return EasyRefresh(
      header:
          BezierCircleHeader(backgroundColor: Theme.of(context).primaryColor),
      footer:
          BezierBounceFooter(backgroundColor: Theme.of(context).primaryColor),
      onRefresh: () => refresh(),
      onLoad: () => onLoad(),
      child: ListView.separated(
        itemCount: list!.length,
        padding: EdgeInsets.all(16),
        separatorBuilder: (BuildContext context, int index) => Container(
          height: 12,
        ),
        itemBuilder: (context, index) {
          var item = list![index];
          if (index == 0) {
            return item;
          }
          return PoetryItem(item);
        },
      ),
    );
  }

  fetch() async {
    this.list = [null];
    this.pageNum = 1;
    await this.getDetail();
    await this.getPoetry();
  }

  getDetail() async {
    var data = await Http().get('/poet/${widget.id}');
    if (data != null) {
      data['poet']['isLiked'] = Favorite.isFavorite(2, data['poet']['id']);
      setState(() {
        this.detail = data;
      });
    }
  }

  getPoetry() async {
    var data =
        await Http().get('/poetry/list?authorId=${widget.id}&pageNum=$pageNum');
    if (data != null) {
      List list = data['list'];
      this.list!.addAll(list);
      setState(() {
        this.list = this.list;
      });
    }
  }

  refresh() async {
    await this.fetch();
    return true;
  }

  onLoad() async {
    this.pageNum = this.pageNum! + 1;
    await this.getPoetry();
    return true;
  }

  // 喜欢
  favorite(id) async {
    if (!(detail['favorited'] ?? false)) {
      var data = await Http().get('/favorite/2/$id');
      if (data != null) {
        setState(() {
          detail['favorited'] = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this.fetch();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
