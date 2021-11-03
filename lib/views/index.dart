import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/common.dart';
import '../components/poet.dart';
import '../components/poetry.dart';
import '../components/recommend.dart';
import 'search.dart';

class Index extends StatefulWidget {
  @override
  _Index createState() => _Index();
}

class _Index extends State<Index> with SingleTickerProviderStateMixin {
  List ? tabs;

  @override
  Widget build(BuildContext context) {
    this.tabs = [
      {'name': '广场', 'contentWidget': Poetry()},
      {'name': '推荐', 'contentWidget': Recommend()},
      {'name': '诗人', 'contentWidget': Poet()}
    ];

    return DefaultTabController(
      length: tabs!.length,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabs!.map((tab) {
              return Tab(text: tab['name']);
            }).toList(),
          ),
          leading: IconButton(icon: Icon(Icons.menu), onPressed: showMenu),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: toSearch)
          ],
        ),
        body: TabBarView(
          children: tabs!.map((tab) {
            Widget widget = tab['contentWidget'];
            return widget;
          }).toList(),
        ),
        backgroundColor: Colors.white.withOpacity(0.94),
      ),
    );
  }

  // 路由到搜索
  toSearch() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => Search()));
  }

  showMenu() {
    List menus = [
//      {
//        'name': '乖，摸摸头',
//        'icon': CircleAvatar(
//          backgroundColor: Theme.of(context).primaryColor,
//          child: Image.network(
//              'https://mirror-gold-cdn.xitu.io/168e08ac959cac0a28f?imageView2/1/w/100/h/100/q/85/format/webp/interlace/1'),
//        ),
//        'type': 'personal'
//      },
//      {
//        'name': '我的消息',
//        'icon': Icons.mail,
//      },
//      {
//        'name': '喜欢的诗词',
//        'icon': Icons.list,
//      },
//      {
//        'name': '喜欢的诗人',
//        'icon': Icons.person,
//      },
//      {
//        'name': '分享',
//        'icon': Icons.share,
//      },
//      {
//        'name': '反馈',
//        'icon': Icons.feedback,
//      },
//      {
//        'name': '设置',
//        'icon': Icons.settings,
//      },
      {
        'name': '退出',
        'icon': Icons.exit_to_app,
        'click': () {
          SystemNavigator.pop(animated: true);
        }
      }
    ];
    double width = (MediaQuery.of(context).size.width - 32 - 12 * 4) / 5;
    Common.showBottomSheet(
        context,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: menus.map((item) {
            return InkWell(
              onTap: () {
                item['click']();
              },
              child: Container(
                width: width,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: item['type'] == 'personal'
                          ? item['icon']
                          : Icon(
                              item['icon'],
//                            color: Colors.black38,
                              color: Theme.of(context).primaryColor,
                              size: 36,
                            ),
                    ),
                    Text(
                      item['name'],
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
