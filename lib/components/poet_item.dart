import 'package:flutter/material.dart';
import 'avatar.dart';
import '../utils/favorite.dart';
import '../utils/common.dart';
import '../utils/http.dart';

class PoetItem extends StatefulWidget {
  final poet;

  PoetItem(this.poet);

  @override
  _PoetItemState createState() => _PoetItemState();
}

class _PoetItemState extends State<PoetItem> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => Common.toPoetDetail(context, widget.poet['id']),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 头像
              Container(
                padding: EdgeInsets.only(right: 16),
                child: Avatar(widget.poet['name']),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.poet['name'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () => favorite(widget.poet['id']),
                      // 点赞数量
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              '${widget.poet['likeCount'] == 0 ? '' : widget.poet['likeCount']}'),
                          (widget.poet['isLiked'] ?? false)
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
        ),
      ),
    );
  }

  // 喜欢
  favorite(id) async {
    if (!(widget.poet['isLiked'] ?? false)) {
      var data = await Http().get('/favorite/2/$id');
      if (data != null) {
        Favorite.favorite(2, id);
        setState(() {
          widget.poet['isLiked'] = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.poet['isLiked'] = Favorite.isFavorite(2, widget.poet['id']);
  }
}
