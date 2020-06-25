import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/homePage/dependency.dart';

/// Example 1 folding cell inside [Container]
class FoldingCellSimpleDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Color(0xffdfd4f4),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                    child: SimpleFoldingCell(
                  frontWidget: FrontWidget(),
                  innerTopWidget: InnerTopWidget(),
                  innerBottomWidget: InnerBottomWidget(),
                  cellSize: Size(MediaQuery.of(context).size.width, 175),
                  padding: EdgeInsets.all(10.0),
                ))
              ],
            )));
  }

  Container FrontWidget() {
    return Container(
        color: Color(0xFFdfd4f4),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFF6a53a4),
                  ),
                  child: Container(
                      child: Row(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Today',
                                style: TextStyle(
                                    color: Color(0xffe8b3a4), fontSize: 20.0),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '09:00 AM',
                                style: TextStyle(
                                    color: Color(0xffe8b3a4), fontSize: 20.0),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ))),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
              ),
            )
          ],
        ));
  }

  Container InnerTopWidget() {
    return Container(
        color: Color(0xFFff9234),
        alignment: Alignment.center,
        child: Text("TITLE",
            style: TextStyle(
                color: Color(0xFF2e282a),
                fontFamily: 'OpenSans',
                fontSize: 20.0,
                fontWeight: FontWeight.w800)));
  }

  Container InnerBottomWidget() {
    return Container(
      color: Color(0xFFecf2f9),
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: FlatButton(
          child: Text(
            "Close",
          ),
          textColor: Colors.white,
          color: Colors.indigoAccent,
          splashColor: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}
