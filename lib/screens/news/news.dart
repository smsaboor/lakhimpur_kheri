import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lakhimpur_kheri/screens/news/bottom_menu_asGNews.dart';
import 'package:lakhimpur_kheri/screens/news/helper/widgets.dart';
import 'package:lakhimpur_kheri/screens/news/models/news_model.dart';
import 'package:lakhimpur_kheri/screens/news/top_ten_news/newsCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper/news.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lakhimpur_kheri/screens/news/explore_news/homepage.dart';
import 'top_ten_news/newsList.dart';
//import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/cupertino.dart';
import 'package:lakhimpur_kheri/zCountryPicker/country.dart';
import 'package:lakhimpur_kheri/zCountryPicker/country_pickers.dart';
import 'package:lakhimpur_kheri/screens/news/a_news_app/ui/screens/serch_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lakhimpur_kheri/screens/news/secret.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' show Client;
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
class NewsHome extends StatefulWidget {
  final SharedPreferences prefs;

  NewsHome({this.prefs});

  @override
  _NewsHomeState createState() => _NewsHomeState(prefs: prefs);
}

class _NewsHomeState extends State<NewsHome> {
  final SharedPreferences prefs;
  _NewsHomeState({this.prefs});
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
  bool _loading;
  int _currentPage;
  int selectedIndex = 0;

  var newslistAll,
      newslistJob,
      newslistEdu;

  var newslistBusiness,
      newslistEntertainment,
      newslistGeneral,
      newslistHealth,
      newslistScience,
      newslistSports,
      newslistTechnology;
  List<Articles> newsCategoryAll  = [];
  TabController tabController;
  TabController tabControllerLocal;
  TabController tabControllerDownloads;
  TabController tabControllerForYou;

//Show hide Bottom and Appbar dependencies
  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController =
  new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 56; // set bottom bar height
  double _bottomBarOffset = 0;

  String urlAll = "http://newsapi.org/v2/top-headlines?country=in&language=en&apiKey=ca8dea2ced7f40e6a26012eacad204ed";
//  String urlJob = "http://newsapi.org/v2/everything?q=jobs&apiKey=${apiKey}";
//  String urlEdu = "http://newsapi.org/v2/everything?q=education&apiKey=${apiKey}";
//  String urlBusiness = "http://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=${apiKey}";
//  String urlEntertainment = "http://newsapi.org/v2/top-headlines?country=in&category=entertainment&apiKey=${apiKey}";
//  String urlGeneral = "http://newsapi.org/v2/top-headlines?country=in&category=general&apiKey=${apiKey}";
//  String urlHealth = "http://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=${apiKey}";
//  String urlScience = "http://newsapi.org/v2/top-headlines?country=in&category=science&apiKey=${apiKey}";
//  String urlSports = "http://newsapi.org/v2/top-headlines?country=in&category=sports&apiKey=${apiKey}";
//  String urlTechnology = "http://newsapi.org/v2/top-headlines?country=in&category=technology&apiKey=${apiKey}";

  void getNews() async {
    NewsApiProvider2 news = NewsApiProvider2();
    await news.getNews(urlAll);
    newslistAll = news.list;
    setState(() {
      _loading = false;
    });
  }

//   getNews2() async {
//     await getData();
//     newslistAll = newsCategoryAll;
//     setState(() {
//       _loading = false;
//     });
//  }
//  final String url =
//      "https://newsapi.org/v2/top-headlines?sources=google-news-in&apiKey=ca8dea2ced7f40e6a26012eacad204ed";
//  Future getData() async {
//    var responseAll = await http.get(url);
//    var jsonAll = jsonDecode(responseAll.body);
//    if (jsonAll['status'] == "ok") {
//      jsonAll["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategoryAll.add(article);
//        }
//      });
//    }
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    _dark = false;
    colorselected = Colors.pink;
    myScroll();
    _currentPage = 0;
    getNews();
//        getNews2();
//    getNews2();
    restore();
  }

  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          hideBottomBar();
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          showBottomBar();
        }
      }
    });
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
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  Widget bottomNavbar() {
    return FFNavigationBar(
      theme: FFNavigationBarTheme(
        barBackgroundColor: Colors.white,
        barHeight: 50,
        selectedItemBackgroundColor: colorselected,
        selectedItemIconColor: Colors.white,
        selectedItemLabelColor: Colors.black,
      ),
      selectedIndex: selectedIndex,
      onSelectTab: (index) {
        debugPrint("index===========$index");
        setState(() {
          colorselected = colorList2[index];
          selectedIndex = index;
          _currentPage = index;
        });
      },
      items: [
        FFNavigationBarItem(
          iconData: Icons.local_library,
          label: 'For You',
        ),
        FFNavigationBarItem(
          iconData: FontAwesomeIcons.globe,
          label: 'Country',
        ),
        FFNavigationBarItem(
          iconData: Icons.location_on,
          label: 'Local',
        ),
        FFNavigationBarItem(
          iconData: Icons.explore,
          label: 'Others',
        ),
        FFNavigationBarItem(
          iconData: Icons.bookmark,
          label: 'Saved',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getMaterialApp();
  }

  Widget _getMaterialApp() {
    debugPrint("in ........._getMaterialApp");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _getScaffold(_currentPage),
    );
  }

  Widget _getScaffold(int page) {
    debugPrint("in ........._getScaffold");
    void _modalMenu() {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return BottomSheetMenu();
        },
      );
    }

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
                                _openCountryPickerDialog()
                                    .then((val) => referesh());
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
            bottomNavigationBar: _show
                ? bottomNavbar()
                : Container(
              height: _bottomBarOffset,
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
            ),
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
                                _openCountryPickerDialog()
                                    .then((val) => referesh());
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
            bottomNavigationBar: _show
                ? bottomNavbar()
                : Container(
              height: _bottomBarOffset,
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        );
      case 3:
        return Scaffold(
            bottomNavigationBar: bottomNavbar(), body: AllHomePage());
      case 4:
        return DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: _showAppbar
                    ? MyAppBarDownloads()
                    : PreferredSize(
                  child: Container(),
                  preferredSize: Size(0.0, 0.0),
                ),
                bottomNavigationBar: _show
                    ? bottomNavbar()
                    : Container(
                  height: _bottomBarOffset,
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                ),
                body: tabBarViewDownloads()));
    }
  }

  TabBarView _tabBarViewWorld() {
    debugPrint("in ........................_tabBarView");
    return TabBarView(children: [
      _safeAreaForCategory(newslistAll),
//      _safeAreaForCategory(newslistJob),
//      _safeAreaForCategory(newslistEdu),
//      _safeAreaForCategory(newslistBusiness),
//      _safeAreaForCategory(newslistEntertainment),
//      _safeAreaForCategory(newslistGeneral),
//      _safeAreaForCategory(newslistHealth),
//      _safeAreaForCategory(newslistScience),
//      _safeAreaForCategory(newslistSports),
//      _safeAreaForCategory(newslistTechnology),
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


  _safeAreaForCategory(var newslistCategoryall) {
    debugPrint(":::::::::::::::::::::::::::::::::::${newslistCategoryall}");
    return SafeArea(child:RefreshIndicator(
        backgroundColor: Colors.black,
        onRefresh: referesh,
        child:Center(
            child: Container(
                child: _loading ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        backgroundColor: Colors.black,
                      ),
                      Text("Waiting for news to load..."),
                    ]
                ) :
                SingleChildScrollView(
                  controller: _scrollBottomBarController,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: ListView.builder(
                              itemCount: newslistCategoryall.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return NewsTile(
                                  source:newslistCategoryall[index].source.name ?? "",
                                  imgUrl:
                                  newslistCategoryall[index].urlToImage ?? "",
                                  title: newslistCategoryall[index].title ?? "",
                                  desc: newslistCategoryall[index].description ??
                                      "",
                                  content:
                                  newslistCategoryall[index].content ?? "",
                                  posturl:
                                  newslistCategoryall[index].url ?? "",
                                  publishAt:newslistCategoryall[index].publishedAt ?? "",
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ))))
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
  Future referesh() async{
    debugPrint("referesh is called...............................");
    getNews();
//    getNewsCategory();
    _getMaterialApp();
  }
}
