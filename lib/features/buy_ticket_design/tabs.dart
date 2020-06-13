import 'package:flutter/material.dart';
import 'package:lakhimpur_kheri/features/buy_ticket_design/cards_example.dart';
import 'package:lakhimpur_kheri/features/buy_ticket_design/lakes_example.dart';
import 'package:lakhimpur_kheri/features/flodingCell/fcmain.dart';

class Tabs extends StatelessWidget {
  bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(width: 24),
        GestureDetector(
            child: MyTab(text: 'Card', isSelected: false),
            onDoubleTap: () {
              // Update the state of the ap  .then((val)=>{_getRequests()})
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (_) => new CardsExample()));
            }),
        MyTab(text: 'Recent', isSelected: true),
        GestureDetector(
            child:  MyTab(text: 'Notice', isSelected: false),
            onDoubleTap: () {
              // Update the state of the ap  .then((val)=>{_getRequests()})
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (_) => new LakesExample()));
            }),
        GestureDetector(
            child:  MyTab(text: 'FoldingCell', isSelected: false),
            onDoubleTap: () {
              // Update the state of the ap  .then((val)=>{_getRequests()})
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (_) => new FoldingCellSimpleDemo()));
            }),

      ],
    );
  }
}

class MyTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const MyTab({Key key, @required this.isSelected, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: isSelected ? 16 : 14,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          Container(
            height: 6,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isSelected ? Color(0xFFFF5A1D) : Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
