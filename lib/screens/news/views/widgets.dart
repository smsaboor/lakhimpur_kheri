import 'package:flutter/material.dart';

import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/top_ten_news/newsCard.dart';

Widget Tabs(String tabn) {
  return Tab(
    child: Text(tabn,
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
  );
}

Widget title(String title1, String title2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(title1 + " ",
        style: TextStyle(
            color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w700),
      )
    ],
  );
}

final List colorList2 = [
  Colors.pink,
  Colors.pinkAccent,
  Colors.orange,
  Colors.green,
  Colors.redAccent
];

Widget TabBarWorld() {
  return TabBar(
    labelColor: Colors.black,
    labelStyle: TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    unselectedLabelColor: Colors.white,
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorWeight: 4,
    indicatorColor: Colors.blueGrey,
    indicator: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Colors.white70),
    isScrollable: true,
    tabs: [
      Tabs("Latest"),
      Tabs("Jobs"),
      Tabs("Education"),
      Tabs("Business"),
      Tabs("Entertainment"),
      Tabs("General"),
      Tabs("Health"),
      Tabs("Science"),
      Tabs("Sports"),
      Tabs("Technology"),
    ],
  );
}

Widget TabBarLocal() {
  return TabBar(
    labelStyle: TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    unselectedLabelColor: Colors.white,
    labelColor: Colors.black,
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorWeight: 4,
    indicatorColor: Colors.red,
    indicator: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Colors.white70),
    isScrollable: true,
    tabs: [
      Tabs("All"),
      Tabs("Offers"),
      Tabs("Jobs"),
      Tabs("Education"),
      Tabs("Anouncement"),
      Tabs("Sports"),
      Tabs("Important"),
      Tabs("Sales"),
    ],
  );
}

MyAppBarDownloads() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: title("Downloaded", "News"),
    elevation: 4,
    backgroundColor: Colors.red,
    bottom: TabBar(
      labelColor: Colors.black,
      labelStyle: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      unselectedLabelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 2,
      indicatorColor: Colors.red,
      isScrollable: true,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white70),
      tabs: [
        Tabs("Loca"),
        Tabs("Cloud"),
        Tabs("G-Drive"),
        Tabs("Gallery"),
      ],
    ),
  );
}

MyAppBarForYou() {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(5.0),
      child: TabBar(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black54,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 4,
        indicatorColor: Colors.blue,
        isScrollable: true,
        tabs: [Tabs("Search"), Tabs("Categories")],
      ),
    ),
  );
}
