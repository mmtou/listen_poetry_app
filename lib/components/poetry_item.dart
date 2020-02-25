import 'package:flutter/material.dart';
import 'avatar.dart';
import '../utils/favorite.dart';
import '../utils/common.dart';
import '../utils/http.dart';

class PoetryItem extends StatefulWidget {
  final poetry;

  PoetryItem(this.poetry);

  @override
  _PoetryItemState createState() => _PoetryItemState();
}

class _PoetryItemState extends State<PoetryItem> {
  @override
  Widget build(BuildContext context) {
    return Ink(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 头像
                  Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Avatar(
                      widget.poetry['authorName'],
                      authorId: widget.poetry['authorId'],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // 标题
                        Text(
                          '${widget.poetry['title']}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        // 年代&作者
                        Text(
                          '[${widget.poetry['dynasty']}]  ${widget.poetry['authorName']}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => favorite(widget.poetry['id']),
                    // 点赞数量
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            '${widget.poetry['likeCount'] == 0 ? '' : widget.poetry['likeCount']}'),
                        (widget.poetry['isLiked'] ?? false)
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
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 56),
                // 内容
                child: Text(
                  '${widget.poetry['content']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 6,
                  style: TextStyle(
                      fontSize: 16, height: 1.5, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 喜欢
  favorite(id) async {
    if (!(widget.poetry['isLiked'] ?? false)) {
      var data = await Http().get('/favorite/1/$id');
      if (data != null) {
        Favorite.favorite(1, id);
        setState(() {
          widget.poetry['isLiked'] = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.poetry['isLiked'] = Favorite.isFavorite(1, widget.poetry['id']);
  }
}
