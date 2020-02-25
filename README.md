# 听诗吧APP
## 简介
**听诗吧** 是一个集 诗词/诗人推荐、搜索、简介、赏析、朗读（下个版本） 于一体的诗词兴趣 APP。涵盖了从古代到近代的 20,000 位诗人的 500,000 首诗词作品，叙事诗、抒情诗、送别诗、边塞诗、山水田园诗、怀古诗、悼亡诗，咏物诗 应有尽有😁。  
- APP 端基于 Google 最新研发的 Flutter UI 框架，一套代码库高效构建多平台精美应用（移动、Web、桌面和嵌入式平台）😊，配合 MaterialDesign 的设计风格 和 卡片式布局 让你眼前一亮。更有微信分享功能，好东西当然要分享👍~
  
项目地址: https://github.com/mmtou/listen_poetry_app  
下载体验: 
![](https://user-gold-cdn.xitu.io/2020/2/25/1707b7cfa41b1c75?w=260&h=260&f=png&s=6603)  
https://github.com/mmtou/listen_poetry_app/raw/master/demo/app-release.apk

- API 端基于 SpringBoot 微服务架构 和 轻量级的 MySQL 数据库，给你带来高效、稳定的服务体验。更集成了百度的语音合成技术，让你畅快的享受诗词带来的乐趣😍。


## 先睹为快
![](https://user-gold-cdn.xitu.io/2020/2/25/1707b40f3cdd72bd?w=704&h=1396&f=png&s=232993)
![](https://user-gold-cdn.xitu.io/2020/2/25/1707b4171590400f?w=704&h=1396&f=png&s=243585)
![](https://user-gold-cdn.xitu.io/2020/2/25/1707b424418e5fc7?w=704&h=1396&f=png&s=134135)
![](https://user-gold-cdn.xitu.io/2020/2/25/1707b42901e75d58?w=704&h=1396&f=png&s=188326)
![](https://user-gold-cdn.xitu.io/2020/2/25/1707b42c69876c2c?w=704&h=1396&f=png&s=238927)
![](https://user-gold-cdn.xitu.io/2020/2/25/1707b42f0e908902?w=704&h=1396&f=png&s=163511)
![](https://user-gold-cdn.xitu.io/2020/2/25/1707b43211864e9e?w=704&h=1396&f=png&s=275281)
![](https://user-gold-cdn.xitu.io/2020/2/25/1707b4345ca158ed?w=704&h=1396&f=png&s=81032)
![](https://user-gold-cdn.xitu.io/2020/2/25/1707b43860baa88e?w=704&h=1396&f=png&s=272184)
![](https://user-gold-cdn.xitu.io/2020/2/25/1707b43a4713819d?w=704&h=1396&f=png&s=80509)

## app端项目结构
```
├── components // 组件
│   ├── avatar.dart // 头像组件，前期根据名称生成对应颜色的头像
│   ├── empty.dart // 置空组件
│   ├── poet.dart // 诗人列表
│   ├── poet_item.dart // 单个诗人
│   ├── poetry.dart // 诗词列表
│   ├── poetry_item.dart // 单个诗词
│   └── recommend.dart // 推荐页组件
├── main.dart
├── utils // 工具类
│   ├── common.dart // 通用工具
│   ├── constant.dart // 常量
│   ├── favorite.dart // 点爱心的管理
│   ├── http.dart // 网络请求
└── views // 页面
    ├── feedback.dart // 反馈
    ├── index.dart // 首页
    ├── poet_detail.dart // 诗人
    ├── poetry_detail.dart // 诗词
    └── search.dart // 搜索
```

## 核心代码
1. APP 启动时从本地读取点赞列表
```dart
void main() {
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  WidgetsFlutterBinding.ensureInitialized();
  run();
}

void run() async {
  await Favorite.getInstance();
  runApp(MyApp());
}
...

class Favorite {
  ...

  static Future<bool> getInstance() async {
    prefs = await SharedPreferences.getInstance();
    favorites = prefs.getStringList('favorites') ?? [];
    return true;
  }
  
  ...
}
```

2. 头像组件，根据诗人名称，计算16位UTF-16代码单元，然后根据规定的颜色数组长度取余，得到index，从颜色数组的中得到某个色值，即为头像的背景色。
```dart
Widget build(BuildContext context) {
    String name = Common.getShortName(authorName);
    int index = name.codeUnitAt(0) % Constant.avatarColors.length;
    Color color = Constant.avatarColors[index];

    return InkWell(
      onTap: () {
        if (authorId != null) {
          Common.toPoetDetail(context, authorId);
        }
      },
      child: CircleAvatar(
        backgroundColor: color,
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
```

3. 微信分享，集成 [fluwx](https://github.com/OpenFlutter/fluwx) 第三方插件，快速实现微信分享、登录、支付等功能。  
    1. 创建 keystore，修改相应配置
    2. 查看签名，执行`keytool -list -v -keystore key.keystore`命令后的MD5去掉:转为小写即为微信开放平台的签名。
    3. 登录微信开放平台创建应用，填写包名、签名等信息
    4. 
    ```dart
    fluwx.registerWxApi(
        appId: "xxxx",
        universalLink: "xxxx");
    fluwx.shareToWeChat(WeChatShareTextModel(
        text: content,
        transaction: "transaction}",
        scene: WeChatScene.SESSION));
    ```
> 请移步 https://flutterchina.club/android-release/#app签名 查看签名配置 

4. `http.dart`单例模式，减少资源浪费
```dart
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

import './constant.dart';

class Http {
  Dio _dio;

  // 工厂模式
  factory Http() => _getInstance();

  static Http get instance => _getInstance();
  static Http _instance;

  Http._internal() {
    // 初始化

    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
            baseUrl: Constant.host,
            connectTimeout: 10000,
            receiveTimeout: 6000,
            headers: {'Content-Type': 'application/json'}),
      );

      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        BotToast.showLoading();
        return options; //continue
      }, onResponse: (Response response) async {
        BotToast.closeAllLoading();
        var data = response.data;
        if (!data['success']) {
          BotToast.showText(text: data['message']);
          throw (data['message']);
        }
        return response.data['result']; // continue
      }, onError: (DioError e) async {
        BotToast.closeAllLoading();
        if ('DioErrorType.DEFAULT' == e.type.toString()) {
          BotToast.showText(text: e.error);
        } else {
          BotToast.showText(text: '服务器异常');
        }
        // Do something with response error
        return e; //continue
      }));
    }
  }

  static Http _getInstance() {
    if (_instance == null) {
      _instance = Http._internal();
    }
    return _instance;
  }

  Future get(uri, {queryParameters}) async {
    try {
      Response response = await _dio.get(uri, queryParameters: queryParameters);
      print(response);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future post(uri, {json}) async {
    try {
      Response response = await _dio.post(uri, data: json);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
```

5. 使用`TabView`时，避免页面重绘，造成资源浪费和体验下降;子组件集成`AutomaticKeepAliveClientMixin`实现缓存策略，且在`build`中加入`super.build(context);`
```
class Poetry extends StatefulWidget {
  @override
  _PoetryState createState() => _PoetryState();
}

class _PoetryState extends State<Poetry> with AutomaticKeepAliveClientMixin {
  List list;
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
              itemCount: this.list.length,
              separatorBuilder: (BuildContext context, int index) => Container(
                    height: 12,
                  ),
              itemBuilder: (BuildContext context, int index) {
                var item = this.list[index];
                return PoetryItem(item);
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

  // 诗词列表
  getList() async {
    var data = await Http().get('/poetry/list?pageNum=$pageNum');
    if (data != null) {
      List list = data['list'];
      this.list = this.list ?? [];
      setState(() {
        this.list.addAll(list);
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
```

5. `InkWell`组件可以实现点击后的波纹反馈效果，但是`InkWell`的child不能设置背景色，不然会覆盖掉波纹的效果。需要你又需要背景色怎么办呢？可以在`InkWell`上包一层`Ink`。
```dart
Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => Common.toPoetryDetail(context, widget.poetry),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      )
    );
```

## 功能
- [x] 推荐
- [x] 广场
- [x] 诗人
- [x] 诗词详情
- [x] 诗人详情
- [x] 微信分享
- [x] 搜索
- [ ] 诗词朗读
- [ ] 登录

## 最后
未完待续~


![](https://user-gold-cdn.xitu.io/2020/2/25/1707b88edce6c412?w=258&h=314&f=png&s=39606)

**愿你走出半生，归来仍是少年。**
