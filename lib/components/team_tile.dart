  
import "dart:math" show pi; 
import 'package:flutter/material.dart';
import 'package:mobilki/components/circle_avatar.dart';
import 'package:mobilki/constants.dart';
  
class TeamTile extends StatelessWidget {
  final String  teamName;
  final List<Avatar> avatars;
  const TeamTile(  {Key? key, required this.teamName, required this.avatars})
      : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Spacer(),
          Expanded(
              flex:5,
              child: Text(teamName,
                  style: const TextStyle(color: darkOrange, fontSize: 24))),
          Expanded(flex:5,
            child:ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse:true,
          itemCount: avatars.length,
          itemBuilder: (context, index) {
            return Align(
              widthFactor: 0.8,
              child: CircleAvatar(
                radius:22,
                backgroundColor: Colors.grey[100],
                child: avatars[index]
              ),
            );
          })),
          const Spacer()
        ]),
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[700]!,
                  offset: Offset.fromDirection(pi / 2, 2),
                  blurRadius: 3.0)
            ],
            color: Colors.grey[100]));
  }
}

  
