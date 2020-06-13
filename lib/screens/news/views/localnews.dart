import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lakhimpur_kheri/screens/news/views/bottom_nav_bar.dart';
import 'package:lakhimpur_kheri/screens/news/views/card_view.dart';
import 'package:lakhimpur_kheri/screens/news/bottom_menu_asGNews.dart';
import 'package:lakhimpur_kheri/screens/news/helper/widgets.dart';
import 'package:lakhimpur_kheri/screens/news/models/news_model.dart';
import 'package:lakhimpur_kheri/screens/news/top_ten_news/newsCard.dart';
import 'package:lakhimpur_kheri/screens/news/views/localDataView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lakhimpur_kheri/screens/news/explore_news/homepage.dart';

//import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/cupertino.dart';
import 'package:lakhimpur_kheri/zCountryPicker/country.dart';
import 'package:lakhimpur_kheri/zCountryPicker/country_pickers.dart';
import 'package:lakhimpur_kheri/screens/news/a_news_app/ui/screens/serch_screen.dart';
import 'package:http/http.dart' show Client;
import 'dart:async';

class LocalNews extends StatefulWidget {
  final SharedPreferences prefs;
  LocalNews({this.prefs});
  @override
  _LocalNewsState createState() => _LocalNewsState(prefs: prefs);
}

class _LocalNewsState extends State<LocalNews> {
  final SharedPreferences prefs;
  _LocalNewsState({this.prefs});
  int color;
  String theme;
  int selectedIndex = 0;

  TabController tabControllerLocal;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                automaticallyImplyLeading: false,
                title:title("Local", "News"),
                floating: true,
                pinned: true,
                snap: true,
                expandedHeight: 90,
                bottom: TabBarLocal(),
              ),
            ];
          },
          body: _tabBarViewLocal(),
        ),
        bottomNavigationBar:BottomNavBar(),
      ),
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
TabBarView _tabBarViewLocal() {
    debugPrint("in ........................_tabBarView");
    return TabBarView(children: [
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
    ]);
  }

}
