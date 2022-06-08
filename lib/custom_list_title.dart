import 'package:flutter/material.dart';
import 'package:my_mp3/helper/hexColor.dart';

Widget customListTile(
    {required String title,
    required String singer,
    required String cover,
    onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      color: HexColor("#0E0E10"),
      padding: EdgeInsets.all(8),
      child: Row(children: [
        Container(
          width: 55.0,
          height: 55.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              image: DecorationImage(image: NetworkImage(cover))),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                singer,
                style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        )
      ]),
    ),
  );
}
