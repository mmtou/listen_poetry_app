import 'package:flutter/material.dart';
import '../utils/common.dart';
import '../utils/constant.dart';

class Avatar extends StatelessWidget {
  final authorId;
  final authorName;

  Avatar(this.authorName, {this.authorId});

  @override
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
}
