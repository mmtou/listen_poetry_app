import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import '../utils/http.dart';

class FeedbackPage extends StatefulWidget {
  final subjectId;
  final subjectType;

  FeedbackPage({this.subjectId, this.subjectType});

  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackPage> {
  List levels;
  final TextEditingController textController = new TextEditingController();
  int star;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('反馈'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: levels
                  .map((item) => IconButton(
                        iconSize: 60,
                        color: item['color'],
                        onPressed: () => handleLevel(item['index']),
                        icon: Icon(item['icon']),
                      ))
                  .toList(),
            ),
            Offstage(
              offstage: star == null,
              child: Container(
                padding: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.03)),
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入···',
                    contentPadding: EdgeInsets.all(16),
                  ),
                  textInputAction: TextInputAction.done,
                  maxLines: 12,
                ),
              ),
            ),
            Offstage(
              offstage: star == null,
              child: Container(
                margin: EdgeInsets.only(top: 32),
                width: double.infinity,
                height: 48,
                child: RaisedButton(
                  onPressed: submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    '提交',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  handleLevel(index) {
    this.initLevel();
    setState(() {
      this.star = index + 1;
      this.levels[index]['color'] = Theme.of(context).primaryColor;
    });
  }

  submit() async {
    var data = await Http().post('feedback', json: {
      'subjectType': widget.subjectType,
      'subjectId': widget.subjectId,
      'star': this.star,
      'content': textController.text
    });
    if (data != null) {
      BotToast.showText(text: '感谢您的反馈~');
      Navigator.of(context).pop();
    }
  }

  initLevel() {
    this.levels = [
      {
        'index': 0,
        'icon': Icons.sentiment_very_dissatisfied,
        'color': Colors.black38,
      },
      {
        'index': 1,
        'icon': Icons.sentiment_dissatisfied,
        'color': Colors.black38,
      },
      {
        'index': 2,
        'icon': Icons.sentiment_neutral,
        'color': Colors.black38,
      },
      {
        'index': 3,
        'icon': Icons.sentiment_satisfied,
        'color': Colors.black38,
      },
      {
        'index': 4,
        'icon': Icons.sentiment_very_satisfied,
        'color': Colors.black38,
      }
    ];
  }

  @override
  void initState() {
    super.initState();
    this.initLevel();
  }
}
