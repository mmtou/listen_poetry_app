import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluwx/fluwx.dart';

import '../views/feedback.dart';
import '../views/poet_detail.dart';
import '../views/poetry_detail.dart';
import '../views/search.dart';

class Common {
  // 格式化时长
  static secondToDate(num second) {
    prefixInteger(num) {
      var temp = '00$num';
      return temp.substring(temp.length - 2);
    }

    format(h, m, s) {
      List result = [];
      if (h != null && h != 0) {
        result.add(prefixInteger(h));
      }
      if (h != null && h != 0 || m != null && m != 0) {
        result.add(prefixInteger(m));
      }
      if (h != null && h != 0 || m != null && m != 0 || s != null && s != 0) {
        result.add(prefixInteger(s));
      }
      return result.join(':');
    }

    var h = (second / 3600).floor();
    var m = (second / 60 % 60).floor();
    var s = (second % 60).floor();

    return format(h, m, s);
  }

  // 作者名字简称
  static getShortName(String authorName) {
    authorName = authorName ?? '';
    int nameLength = authorName.length;
    if (nameLength <= 1) {
      return authorName;
    } else {
      return authorName.substring(nameLength - 2, nameLength);
    }
  }

  // 路由到详情
  static toPoetryDetail(context, poetry) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PoetryDetail(poetry)));
  }

  // 路由到详情
  static toPoetDetail(context, id) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => PoetDetail(id)));
  }

  // 路由到详情
  static toSearch(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => Search()));
  }

  static showBottomSheet(context, child) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        double width = (MediaQuery.of(context).size.width - 32 - 12 * 4) / 5;
        return Container(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: child,
        );
      },
    );
  }

  static shareWechatSession(content) {
    fluwx.registerWxApi(
        appId: "wx564c6903ab358b6a",
        universalLink: "https://your.univeral.link.com/placeholder/");
    fluwx.shareToWeChat(WeChatShareTextModel(
        text: content,
        transaction: "transaction}",
        scene: WeChatScene.SESSION));
  }

  static shareWechatFavorite(content) {
    fluwx.registerWxApi(
        appId: "wx564c6903ab358b6a",
        universalLink: "https://your.univeral.link.com/placeholder/");
    fluwx.shareToWeChat(WeChatShareTextModel(
        text: content,
        transaction: "transaction}",
        scene: WeChatScene.FAVORITE));
  }

  static shareWechatTimeline(content) {
    fluwx.registerWxApi(
        appId: "wx564c6903ab358b6a",
        universalLink: "https://your.univeral.link.com/placeholder/");
    fluwx.shareToWeChat(WeChatShareTextModel(
        text: content,
        transaction: "transaction}",
        scene: WeChatScene.TIMELINE));
  }

  // 详情页更多
  static showDetailMore(context, subjectType, subjectId, {content}) {
    Common.showBottomSheet(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('分享给微信好友'),
            leading: Image.asset(
              'assets/images/wechat-session.png',
              width: 30,
              height: 30,
            ),
            onTap: () => shareWechatSession(content),
          ),
          ListTile(
            title: Text('微信收藏'),
            leading: Image.asset(
              'assets/images/wechat-favorite.png',
              width: 30,
              height: 30,
            ),
            onTap: () => shareWechatFavorite(content),
          ),
          ListTile(
            title: Text('分享到微信朋友圈'),
            leading: Image.asset(
              'assets/images/wechat-timeline.png',
              width: 30,
              height: 30,
            ),
            onTap: () => shareWechatTimeline(content),
          ),
          ListTile(
            title: Text('反馈'),
            leading: Image.asset(
              'assets/images/feedback.png',
              width: 30,
              height: 30,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => FeedbackPage(
                        subjectId: subjectId,
                        subjectType: subjectType,
                      )));
            },
          ),
        ],
      ),
    );
  }
}
