import 'package:flutter/material.dart';

Widget customListTile(
    {required String title,
    required String singer,
    required String cover,
    onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8),
      child: Row(children: [
        Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: DecorationImage(image: NetworkImage(cover))),
        ),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                singer,
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
              )
            ],
          ),
        )
      ]),
    ),
  );
}
