import 'package:flutter/material.dart';
import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/a_news_app/ui/screens/liked_list.dart';
import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/a_news_app/ui/screens/news_list.dart';
import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/a_news_app/ui/screens/settings_screen.dart';
import 'package:lakhimpur_kheri/screens/news/bottom_menu_asGNews.dart';
import 'package:flutter/rendering.dart';
import 'package:lakhimpur_kheri/screens/news/views/widgets.dart';
import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/top_ten_news/newsCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lakhimpur_kheri/screens/news/explore_news/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lakhimpur_kheri/utils/zCountryPicker/country.dart';
import 'package:lakhimpur_kheri/utils/zCountryPicker/country_pickers.dart';
import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/a_news_app/ui/screens/serch_screen.dart';
import 'dart:async';
class BottomNavBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BottomNavBarState();
  }
}

class BottomNavBarState extends State<BottomNavBar> {
  final List colorList2 = [
    Colors.pink,
    Colors.pinkAccent,
    Colors.orange,
    Colors.green,
    Colors.redAccent
  ];
  String _countryIsoCodeSP = 'IN';
  Brightness _brightness;
  int color;
  String theme;
  bool _dark;
  Color colorselected;
  bool _newsloading,_firebaseloading;
  int _currentPage;
  int selectedIndex = 0;
  num _currentItem = 0;
  final _listWidgets = [
    NewsList(),
    LikedList(),
    SettingsScreen(),
  ];
  void _modalMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BottomSheetMenu();
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restore();
    _newsloading = true;
    _firebaseloading=true;
    _dark = false;
    colorselected = Colors.pink;
    _currentPage = 0;
  }
  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _countryIsoCodeSP = (sharedPrefs.getString('countryIsoCode') ?? 'IN');
    });
  }

  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is String) {
      sharedPrefs.setString(key, value);
    }
  }
  @override
  Widget build(BuildContext context) {
    return _getScaffold(_currentPage);
  }

  Widget _getScaffold(int page) {
    switch (page) {
      case 0:
        return  Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.search,
                  semanticLabel: 'search',
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SearchScreen(title: "News")));
                },
              ),
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 6.0),
                  child: IconButton(
                    icon: Icon(Icons.account_circle, size: 32.0),
                    onPressed: () {
                      _modalMenu();
                    },
                  ),
                ),
              ],
              backgroundColor: colorselected,
              centerTitle: true,
              title: title("Myzen", "News"),
            ),
            bottomNavigationBar: bottomNavbar(),
            body: NewsCard());
      case 1:
        return DefaultTabController(
          length: 10,
          child: new Scaffold(
            body: new NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  new SliverAppBar(
                    backgroundColor: colorselected,
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          title(
                              CountryPickerUtils.getCountryByIsoCode(
                                  _countryIsoCodeSP)
                                  .name,
                              "News               "),
                          GestureDetector(
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                      CountryPickerUtils.getFlagImageAssetPath(
                                          _countryIsoCodeSP),
                                      height: 20,
                                      width: 35),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 25,
                                  )
                                ],
                              ),
                              onTap: () {
                                _openCountryPickerDialog();
                              })
                        ]),
                    floating: true,
                    pinned: true,
                    snap: true,
                    expandedHeight: 150,
                    flexibleSpace: FlexibleSpaceBar(
                      background:
                      Image.asset('assets/images/b5.jpg', fit: BoxFit.fill),
                    ),
                    bottom: TabBarWorld(),
                  ),
                ];
              },
              body:_tabBarViewWorld(),
            ),
            bottomNavigationBar:  bottomNavbar(),
          ),
        );
      case 2:
        return DefaultTabController(
          length: 8,
          child: new Scaffold(
            body: new NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  new SliverAppBar(
                    backgroundColor: colorselected,
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          title("Local", "News               "),
                          GestureDetector(
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                      CountryPickerUtils.getFlagImageAssetPath(
                                          _countryIsoCodeSP),
                                      height: 20,
                                      width: 35),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 25,
                                  )
                                ],
                              ),
                              onTap: () {
                                _openCountryPickerDialog();
                              })
                        ]),
                    floating: true,
                    pinned: true,
                    snap: true,
                    expandedHeight: 90,
                    bottom: TabBarLocal(),
                  ),
                ];
              },
              body:  _tabBarViewLocal(),
            ),
            bottomNavigationBar: bottomNavbar(),
          ),
        );
      case 3:
        return Scaffold(
            bottomNavigationBar: bottomNavbar(), body: AllHomePage());
      case 4:
        return DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: MyAppBarDownloads(),
                bottomNavigationBar: bottomNavbar(),
                body: _tabBarViewsDownload()));
    }
  }
  TabBarView _tabBarViewWorld() {
    debugPrint("in ........................_tabBarView");
    return TabBarView(children: [
      NewsList(),
      Container(),
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
  TabBarView _tabBarViewsDownload() {
    return TabBarView(children: [
      Container(),
      LikedList(),
      Container(),
      Container(),
    ]);
  }

  Widget bottomNavbar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.local_library), title: Text('For You')),
        BottomNavigationBarItem(
            icon: Icon(Icons.language),
            title: Text('World'),),
        BottomNavigationBarItem(
            icon: Icon(Icons.location_on), title: Text('Local')),
        BottomNavigationBarItem(
            icon: Icon(Icons.explore), title: Text('Explore')),
        BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border), title: Text('Saved'),
            activeIcon: Icon(Icons.bookmark))
      ],
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.black38,
      showUnselectedLabels: true,
      selectedItemColor: Colors.red,
      onTap: (index) {
        debugPrint("index===========$index");
        setState(() {
          colorselected = colorList2[index];
          selectedIndex = index;
          _currentPage = index;
        });
      },
    );
  }

  Widget _buildDialogItem(Country country) => Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      SizedBox(width: 12.0),
      Flexible(child: Text(country.name))
    ],
  );

  Future<void> _openCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.pink),
      child: CountryPickerDialog(
        titlePadding: EdgeInsets.all(8.0),
        searchCursorColor: Colors.pinkAccent,
        searchInputDecoration: InputDecoration(hintText: 'Search...'),
        isSearchable: true,
        title: Text('Select your phone code'),
        onValuePicked: (Country country) {
          setState(() {
            _countryIsoCodeSP = country.isoCode;
          });
          save('countryIsoCode', country.isoCode);
        },
        itemBuilder: _buildDialogItem,
        priorityList: [
          CountryPickerUtils.getCountryByIsoCode('IN'),
          CountryPickerUtils.getCountryByIsoCode('US'),
        ],
      ),
    ),
  );


}
