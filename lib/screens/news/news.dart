import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lakhimpur_kheri/login/authentication_bloc/authentication_bloc.dart';
import 'package:lakhimpur_kheri/model/article.dart';
import 'package:lakhimpur_kheri/screens/news/bottom_menu_asGNews.dart';
import 'package:lakhimpur_kheri/screens/news/views/admin_news_save.dart';
import 'package:lakhimpur_kheri/screens/news/views/card_view.dart';
import 'package:lakhimpur_kheri/screens/news/views/widgets.dart';
import 'package:lakhimpur_kheri/screens/news/models/news_model.dart';
import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/top_ten_news/newsCard.dart';
import 'package:lakhimpur_kheri/screens/news/views/facebook_card_post.dart';
import 'package:lakhimpur_kheri/screens/news/views/gallery_images_display.dart';
import 'package:lakhimpur_kheri/screens/news/views/localDataView.dart';
import 'package:lakhimpur_kheri/utils/zStatePicker/indianStates.dart';
import 'package:lakhimpur_kheri/utils/zTehsilesPicker/Tehsiles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/news.dart';
import 'package:lakhimpur_kheri/screens/news/explore_news/homepage.dart';
import 'package:lakhimpur_kheri/model/model_localArticle.dart';
import 'package:flutter/cupertino.dart';
import 'package:lakhimpur_kheri/utils/zCountryPicker/country.dart';
import 'package:lakhimpur_kheri/utils/zCountryPicker/country_pickers.dart';
import 'package:lakhimpur_kheri/utils/zStatePicker/states.dart';
import 'package:lakhimpur_kheri/utils/zStatePicker/states_pickers.dart';
import 'package:lakhimpur_kheri/utils/zTehsilesPicker/Tehsil.dart';
import 'package:lakhimpur_kheri/utils/zTehsilesPicker/tehsil_pickers.dart';

import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/a_news_app/ui/screens/serch_screen.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:lakhimpur_kheri/helper/database_helper.dart';
import 'dart:io';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'package:lakhimpur_kheri/utils/fullScreenWrapper.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

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
  String _stateIsoCodeSP = 'S26';
  String _tehsilIsoCodeSP = 'T1';

  Brightness _brightness;
  int color;
  String theme;
  bool _dark;
  Color colorselected;
  bool _newsloading, _firebaseloading, _localloading;
  int _currentPage;
  int selectedIndex = 0;
  List<String> mystates = [];
  List<String> mytehsils = [];
  List<Articles> newsList = [];
  List<Articles> firestoreList = [];
  List<ModelArticle> localArticalList = [];
  List<Articles> localArticalMapList = [];

  List<Article> localArticalGoogleRSS = [];
  DataHelper databaseHelper = DataHelper();
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
  int newsListLength;
  int firestoreListLength;
  int loacalArticleLength = 0;
  String _uuid;
  String urlAll =
      "http://newsapi.org/v2/top-headlines?country=in&language=en&apiKey=ca8dea2ced7f40e6a26012eacad204ed";

//  String urlJob = "http://newsapi.org/v2/everything?q=jobs&apiKey=${apiKey}";
//  String urlEdu = "http://newsapi.org/v2/everything?q=education&apiKey=${apiKey}";
//  String urlBusiness = "http://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=${apiKey}";
//  String urlEntertainment = "http://newsapi.org/v2/top-headlines?country=in&category=entertainment&apiKey=${apiKey}";
//  String urlGeneral = "http://newsapi.org/v2/top-headlines?country=in&category=general&apiKey=${apiKey}";
//  String urlHealth = "http://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=${apiKey}";
//  String urlScience = "http://newsapi.org/v2/top-headlines?country=in&category=science&apiKey=${apiKey}";
//  String urlSports = "http://newsapi.org/v2/top-headlines?country=in&category=sports&apiKey=${apiKey}";
//  String urlTechnology = "http://newsapi.org/v2/top-headlines?country=in&category=technology&apiKey=${apiKey}";
  static Future<List<Article>> getArticleListFromNetwork(
      String country, String category) async {
    if (category != null && category == 'local') {
      return getLocalNewsFromNetwork();
    }
    return ApiService.getArticlesFromNetwork(country, category);
  }

  static Future<List<Article>> getLocalNewsFromNetwork() async {
    return ApiService.getLocalNewsFromNetwork();
  }

  bool _googleLoading;

  void getGoogleNews() async {
    localArticalGoogleRSS = await ApiService.getLocalNewsFromNetwork();
    setState(() {
      _googleLoading = false;
    });
  }

  void getNews() async {
    NewsApiProvider2 news = NewsApiProvider2();
    await news.getNews(urlAll);
    newsList = news.list;
    newsListLength = newsList.length;
    setState(() {
      _newsloading = false;
    });
  }

  void firestoreNews() async {
    debugPrint("firestore news is called...................$_uuid");
    NewsApiProvider2 news = NewsApiProvider2();
    await news.getFavoriteNews(_uuid);
    firestoreList = news.list2;
    debugPrint("firestoreList length...............${firestoreList.length}...");
    firestoreListLength = firestoreList.length;
    setState(() {
      _firebaseloading = false;
    });
  }

  void updateLoacalListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelArticle>> articleListFuture =
          databaseHelper.getAllBookmarkArticle();
      articleListFuture.then((articleList) {
        setState(() {
          this.localArticalList = articleList;
          this.loacalArticleLength = articleList.length;
          debugPrint("loacalArticleCount is : $loacalArticleLength");
          _localloading = false;
        });
      });
    });
  }

  Future<bool> checkForInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (e) {
      print(e);
      return false;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: Duration(seconds: 3));
    Scaffold.of(context).showSnackBar(snackBar);
  }
  bool checkForNet;
  checkforinternet() async {
    checkForNet = await checkForInternet();
    if (checkForNet != true) {
      _showSnackBar(context, 'No Internet Connection');
    } else {
      getNews();
      firestoreNews();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restore();
    restore2();
    firestoreNews();
    getGoogleNews();
    checkforinternet();
    updateLoacalListView();
    _googleLoading = true;
    _newsloading = true;
    _firebaseloading = true;
    _localloading = true;
    _dark = false;
    colorselected = Colors.pink;
    myScroll();
    _currentPage = 0;
    //    Timer(Duration(seconds: 30), (){
//      internetInfo=" sorry your net speed is very slow !";
//    });
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

  restore2() {
    mytehsils.add('assets/t00.jpg');
    for (int i = 0; i < tehsilList.length; i++) {
      debugPrint("tehsil-----------------------${tehsilList.length}");
      mytehsils
          .add(TehsilPickerUtils.getFlagImageAssetPath(tehsilList[i].isoCode));
      debugPrint("tehsil--$i is---------------------${mytehsils[i]}");
    }
  }

  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _uuid = (sharedPrefs.getString('uuId') ?? '');
    });
    mystates.add('assets/s0.jpg');
    for (int i = 0; i <= statesList.length; i++) {
      debugPrint("tehsil-----------------------${tehsilList.length}");
      mystates
          .add(StatePickerUtils.getFlagImageAssetPath(statesList[i].isoCode));
    }
    setState(() {
      _countryIsoCodeSP = (sharedPrefs.getString('countryIsoCode') ?? 'IN');
      _stateIsoCodeSP = (sharedPrefs.getString('stateIsoCode') ?? 'S26');
      _tehsilIsoCodeSP = (sharedPrefs.getString('tehsilIsoCode') ?? 'T1');
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
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Icon(Icons.local_library),
            ),
            title: Text(
              'For You',
              style: TextStyle(color: Colors.black),
            )),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Icon(Icons.language),
          ),
          title: Text(
            'World',
            style: TextStyle(color: Colors.black),
          ),
        ),
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Icon(Icons.flag),
            ),
            title: Text(
              'National',
              style: TextStyle(color: Colors.black),
            )),
//        BottomNavigationBarItem(
//          icon: Padding(
//            padding: EdgeInsets.only(bottom: 5),
//            child: Icon(Icons.location_city),
//          ),
//          title: Text(
//            'City',
//            style: TextStyle(color: Colors.black),
//          ),
//        ),

        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Icon(Icons.location_on),
          ),
          title: Text(
            'Local',
            style: TextStyle(color: Colors.black),
          ),
        ),
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Icon(Icons.explore),
            ),
            title: Text(
              'Explore',
              style: TextStyle(color: Colors.black),
            )),
      ],
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.amber,
      iconSize: 22,
      selectedFontSize: 13,
      unselectedFontSize: 12,
      unselectedItemColor: Colors.black54,
      showSelectedLabels: true,
      showUnselectedLabels: true,
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

  void _modalMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BottomSheetMenu();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getScaffold(_currentPage);
  }

  Widget _getScaffold(int page) {
    switch (page) {
      case 0:
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  Icons.language,
                  semanticLabel: 'search',
                  color: Colors.amber,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SearchScreen(title: "News")));
                },
              ),
              actions: <Widget>[
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications_active,
                      size: 24.0,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      _modalMenu();
                    },
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      size: 24.0,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      _modalMenu();
                    },
                  ),
                ),
              ],
              centerTitle: true,
              title: title("Myzen", "News"),
            ),
            bottomNavigationBar: bottomNavbar(),
            body: NewsCard());
      case 1:
        return DefaultTabController(
          length: 5,
          child: new Scaffold(
              backgroundColor: Colors.grey.shade100,
              body: new NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      new SliverAppBar(
                        title: GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.language,
                                    color: Colors.amber,
                                    size: 34,
                                  ),
                                ),
                                title(
                                    CountryPickerUtils.getCountryByIsoCode(
                                            _countryIsoCodeSP)
                                        .name,
                                    "News"),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 25,
                                  color: Colors.black,
                                )
                              ],
                            ),
                            onTap: () {
                              _openCountryPickerDialog()
                                  .then((val) => refereshNews());
                            }),
                        actions: <Widget>[
                          Container(
                            child: IconButton(
                              icon: Icon(
                                Icons.file_download,
                                size: 24.0,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      _getDownload(),
                                ));

                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 6.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.account_circle,
                                size: 24.0,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                _modalMenu();
                              },
                            ),
                          ),
                        ],
                        automaticallyImplyLeading: false,
                        elevation: 4.0,
                        backgroundColor: Colors.white,
                        floating: true,
                        pinned: true,
                        snap: true,
                        bottom: TabBarWorld(),
                      ),
                    ];
                  },
                  body: _tabBarViewWorld()),
              bottomNavigationBar: bottomNavbar()),
        );
      case 2:
        return DefaultTabController(
          length: 5,
          child: new Scaffold(
              backgroundColor: Colors.grey.shade100,
              body: new NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      new SliverAppBar(
                        title: GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.language,
                                    color: Colors.amber,
                                    size: 34,
                                  ),
                                ),
                                title(
                                    StatePickerUtils.getStateByIsoCode(
                                        _stateIsoCodeSP)
                                        .name,
                                    "News"),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 25,
                                  color: Colors.black,
                                )
                              ],
                            ),
                            onTap: () {
                              _openStatePickerDialog()
                                  .then((val) => refereshNews());
                            }),
                        actions: <Widget>[
                          Container(
                            child: IconButton(
                              icon: Icon(
                                Icons.file_download,
                                size: 24.0,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      _getDownload(),
                                ));

                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 6.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.account_circle,
                                size: 24.0,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                _modalMenu();
                              },
                            ),
                          ),
                        ],
                        automaticallyImplyLeading: false,
                        elevation: 4.0,
                        backgroundColor: Colors.white,
                        floating: true,
                        pinned: true,
                        snap: true,
                        bottom: TabBarNational(),
                      ),
                    ];
                  },
                  body: _tabBarViewNational()),
              bottomNavigationBar: bottomNavbar()),
        );
      case 3:
        return DefaultTabController(
          length: 8,
          child: new Scaffold(
              backgroundColor: Colors.white,
              body: new NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      new SliverAppBar(
                          title: GestureDetector(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Icon(
                                      Icons.language,
                                      color: Colors.amber,
                                      size: 34,
                                    ),
                                  ),
                                  title(
                                      TehsilPickerUtils.getTehsilByIsoCode(
                                              _tehsilIsoCodeSP)
                                          .name,
                                      "News"),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 25,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                              onTap: () {
                                _openTehsilPickerDialog()
                                    .then((val) => refereshNews());
                              }),
                          actions: <Widget>[
                            Container(
                              child:IconButton(
                                  icon: Icon(
                                    Icons.file_download,
                                    size: 24.0,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          _getDownload(),
                                    ));

                                  },
                                ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 6.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.account_circle,
                                  size: 24.0,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  _modalMenu();
                                },
                              ),
                            ),
                          ],
                          automaticallyImplyLeading: false,
                          elevation: 4.0,
                          backgroundColor: Colors.white,
                          floating: true,
                          pinned: true,
                          snap: true,
                          bottom: TabBarLocal())
                    ];
                  },
                  body: _tabBarViewLocal()),
              bottomNavigationBar: bottomNavbar()),
        );
      case 4:
        return Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: bottomNavbar(),
            body: AllHomePage());
    }
  }
_getDownload(){
  return DefaultTabController(
    length: 4,
    child: new Scaffold(
        backgroundColor: Colors.white,
        body: new NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  leading: GestureDetector(child: Icon(Icons.arrow_back,color: Colors.black,),
                  onTap: (){
                    Navigator.pop(context,true);
                  },),
                    title: Row(
                          children: <Widget>[
                            title(
                               "Downloads",
                                "News"),
                          ],
                    ),
                    elevation: 4.0,
                    backgroundColor: Colors.white,
                    floating: true,
                    pinned: true,
                    snap: true,
                    bottom: MyAppBarDownloads())
              ];
            },
            body: _tabBarViewsDownload()),
    ),
  );
}
  Widget TabBarWorld() {
    return TabBar(
      labelColor: Colors.black,
      labelStyle: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      unselectedLabelColor: Colors.black54,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 4,
      indicatorColor: Colors.amber,
//      indicator: BoxDecoration(
//          borderRadius: BorderRadius.only(
//              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//          color: Colors.white70),
      isScrollable: true,
      tabs: [
        Tabs("Hot News"),
        Tabs("Jobs"),
        Tabs("Business"),
        Tabs("Politics"),
        Tabs("Education"),
      ],
      controller: tabController,
    );
  }

  Widget _tabBarViewWorld() {
    debugPrint("in ........................_tabBarView");
    return TabBarView(controller: tabController, children: [
      _safeAreaForCategory(newsList, _newsloading, newsListLength),
      _safeAreaForCategory3(
          localArticalGoogleRSS, _googleLoading, localArticalGoogleRSS.length),
      Container(),
      Container(),
      Container(),
    ]);
  }
  Widget TabBarNational() {
    return TabBar(
      labelColor: Colors.black,
      labelStyle: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      unselectedLabelColor: Colors.black54,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 4,
      indicatorColor: Colors.amber,
//      indicator: BoxDecoration(
//          borderRadius: BorderRadius.only(
//              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//          color: Colors.white70),
      isScrollable: true,
      tabs: [
        Tabs("Hot News"),
        Tabs("Jobs"),
        Tabs("Business"),
        Tabs("Politics"),
        Tabs("Education"),
      ],
      controller: tabController,
    );
  }

  Widget _tabBarViewNational() {
    debugPrint("in ........................_tabBarView");
    return TabBarView(controller: tabController, children: [
      _safeAreaForCategory(newsList, _newsloading, newsListLength),
      _safeAreaForCategory3(
          localArticalGoogleRSS, _googleLoading, localArticalGoogleRSS.length),
      Container(),
      Container(),
      Container(),
    ]);
  }

  Widget TabBarLocal() {
    return TabBar(
      labelStyle: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      unselectedLabelColor: Colors.black54,
      labelColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 4,
      indicatorColor: Colors.amber,
//      indicator: BoxDecoration(
//          borderRadius: BorderRadius.only(
//              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//          color: Colors.white70),
      isScrollable: true,
      tabs: [
        Tabs("Hot News"),
        Tabs("Jobs"),
        Tabs("Education"),
        Tabs("Offers"),
        Tabs("Sports"),
        Tabs(" , ,. "),
        Tabs("Spo"),
        Tabs("Sales"),
      ],
      controller: tabControllerLocal,
    );
  }

  TabBarView _tabBarViewLocal() {
    debugPrint("in ........................_tabBarView");
    return TabBarView(controller: tabControllerLocal, children: [
      _getCardViewForAdmin(newsList, _newsloading, newsListLength),
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
    ]);
  }

  MyAppBarDownloads() {
    return TabBar(
      labelStyle: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      unselectedLabelColor: Colors.black54,
      labelColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 4,
      indicatorColor: Colors.amber,
      tabs: [
        Tabs("offline"),
        Tabs("Cloud"),
        Tabs("G-Drive"),
        Tabs("Gallery"),
      ],
      controller: tabControllerDownloads,
    );
  }

  TabBarView _tabBarViewsDownload() {
    return TabBarView(controller: tabControllerDownloads, children: [
      _safeAreaForCategory2(
          localArticalList, _localloading, loacalArticleLength),
      _safeAreaForCategory(
          firestoreList, _firebaseloading, firestoreListLength),
      Container(),
      Container(child: GalleryImagesDisplay()),
    ]);
  }


  Widget _buildCountryDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 12.0),
          Flexible(child: Text(country.name))
        ],
      );

  Widget _buildStateDialogItem(IndianStates state) => Row(
        children: <Widget>[
          StatePickerUtils.getDefaultFlagImage(state),
          SizedBox(width: 8.0),
          Flexible(
              child: Text(
            state.name,
            style: TextStyle(fontSize: 16),
          )),
          Text(
            " (${state.stateCapital})",
            style: TextStyle(fontSize: 10, color: Colors.green),
          ),
//      Text("'${state.foundedOn}'",style: TextStyle(fontSize: 6),)
        ],
      );

  Widget _buildTehsilDialogItem(Tehsil tehsil) => Row(
        children: <Widget>[
          TehsilPickerUtils.getTehsilDefaultFlagImage(tehsil),
          SizedBox(width: 12.0),
          Flexible(child: Text(tehsil.name)),
          Text(
            " (${tehsil.area})",
            style: TextStyle(fontSize: 10, color: Colors.green),
          ),
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
            title: Text('Select Your Country'),
            onValuePicked: (Country country) {
              setState(() {
                _countryIsoCodeSP = country.isoCode;
              });
              save('countryIsoCode', country.isoCode);
            },
            itemBuilder: _buildCountryDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('A0'),
              CountryPickerUtils.getCountryByIsoCode('IN'),
              CountryPickerUtils.getCountryByIsoCode('US'),
              CountryPickerUtils.getCountryByIsoCode('CN'),
            ],
          ),
        ),
      );

  Future<void> _openStatePickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: IndianStatePickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Row(
              children: <Widget>[
                Text('Select Your State'),
                Spacer(),
                InkWell(
                    onTap: () {
                      Navigator.pop(context, true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GalleryPhotoViewWrapper(
                            galleryItems: mystates,
                            initialIndex: 0,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          StatePickerUtils.getFlagImageAssetPath('s0'),
                          height: 50,
                          width: 40,
                        ),
                        Text(
                          "open Map",
                          style: TextStyle(fontSize: 9, color: Colors.red),
                        )
                      ],
                    ))
              ],
            ),
            onValuePicked: (IndianStates state) {
              setState(() {
                _stateIsoCodeSP = state.isoCode;
              });
              save('stateIsoCode', state.isoCode);
            },
            itemBuilder: _buildStateDialogItem,
            priorityList: [
              StatePickerUtils.getStateByIsoCode('S0'),
              StatePickerUtils.getStateByIsoCode('S26'),
            ],
          ),
        ),
      );

  Future<void> _openTehsilPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: TehsilesPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Column(
              children: <Widget>[
//                Text(
//                  'Lakhimpur-Kheri: 7680 km²',
//                  style: TextStyle(fontSize: 10, color: Colors.red),
//                ),
                Row(
                  children: <Widget>[
                    Text('Select Your Tehsil'),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context, true);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GalleryPhotoViewWrapper(
                                galleryItems: mytehsils,
                                initialIndex: 0,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              TehsilPickerUtils.getFlagImageAssetPath('t0'),
                              height: 50,
                              width: 60,
                            ),
                            Text(
                              "open Map",
                              style: TextStyle(fontSize: 9, color: Colors.red),
                            )
                          ],
                        ))
                  ],
                ),
//                RaisedButton(
//                  color: Colors.amber,
//                  child: Text("Cancel"),
//                onPressed: (){
//                  Navigator.pop(context, true);
//                },
//                ),
              ],
            ),
            onValuePicked: (Tehsil tehsil) {
              setState(() {
                _tehsilIsoCodeSP = tehsil.isoCode;
              });
              save('tehsilIsoCode', tehsil.isoCode);
            },
            itemBuilder: _buildTehsilDialogItem,
            priorityList: [
              TehsilPickerUtils.getTehsilByIsoCode('T0'),
            ],
          ),
        ),
      );

  Future refereshFirestore() async {
    debugPrint("referesh is called...............................");
    firestoreNews();
    _getScaffold(selectedIndex);
  }

  Future refereshNews() async {
    debugPrint("referesh is called...............................");
    getNews();
    _getScaffold(selectedIndex);
  }

  Future refereshLocal() async {
    debugPrint("referesh is called...............................");
    updateLoacalListView();
    _getScaffold(selectedIndex);
  }

  _safeAreaForCategory(List<Articles> newslistCategoryall, bool loading, int length) {
    return RefreshIndicator(
      backgroundColor: Colors.black,
      onRefresh: refereshNews,
      child: loading
          ? Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                  Text("Waiting for news to load..."),
                ]))
          : Container(
              child: ListView.builder(
                  itemCount: newslistCategoryall.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: CardView(
                          source: newslistCategoryall[index].source.name ??
                              'Sorry !',
                          title: newslistCategoryall[index].title ?? 'Sorry !',
                          url: newslistCategoryall[index].url ?? 'Sorry !',
                          urlToImage: newslistCategoryall[index].urlToImage ??
                              'Sorry !',
                          author: newslistCategoryall[index].author ??
                              'Author Unavailable',
                          publishedAt:
                              newslistCategoryall[index].publishedAt ?? 'Sorry',
                          content:
                              newslistCategoryall[index].content ?? 'Sorry',
                        ));
                  }),
            ),
    );
  }

  _getCardViewForAdmin(
      List<Articles> newslistCategoryall, bool loading, int length) {
    return RefreshIndicator(
      backgroundColor: Colors.black,
      onRefresh: refereshNews,
      child: loading
          ? Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                  Text("Waiting for news to load..."),
                ]))
          : Container(
              child: ListView.builder(
                  itemCount: newslistCategoryall.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: AdminNewsCard(
                          source: newslistCategoryall[index].source.name ??
                              'Sorry !',
                          title: newslistCategoryall[index].title ?? 'Sorry !',
                          url: newslistCategoryall[index].url ?? 'Sorry !',
                          urlToImage: newslistCategoryall[index].urlToImage ??
                              'Sorry !',
                          author: newslistCategoryall[index].author ??
                              'Author Unavailable',
                          publishedAt:
                              newslistCategoryall[index].publishedAt ?? 'Sorry',
                          content:
                              newslistCategoryall[index].content ?? 'Sorry',
                        ));
                  }),
            ),
    );
  }

  _safeAreaForCategory2(
      List<ModelArticle> newslistCategoryall, bool loading, int length) {
    return RefreshIndicator(
      backgroundColor: Colors.black,
      onRefresh: refereshLocal,
      child: loading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                  Text("Waiting for news to load..."),
                ])
          : Container(
              child: ListView.builder(
                  itemCount: newslistCategoryall.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return LocalDataView(
                      title: newslistCategoryall[index].title,
                      url: newslistCategoryall[index].url,
                      author: newslistCategoryall[index].author,
                      source: newslistCategoryall[index].source,
                      urlToImage: newslistCategoryall[index].imageToUrl,
                      publishedAt: newslistCategoryall[index].publishedAt,
                      content: newslistCategoryall[index].content,
                      category: 'all',
                    );
                  }),
            ),
    );
  }

  _safeAreaForCategory3(
      List<Article> newslistCategoryall, bool loading, int length) {
    debugPrint("@@@@@@@@@@@@@@@@@@@@@@@@@@@${newslistCategoryall[1].imageUrl}");
    return Container(
        child: RefreshIndicator(
            backgroundColor: Colors.black,
            onRefresh: refereshNews,
            child: Center(
                child: Container(
              child: loading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          CircularProgressIndicator(
                            backgroundColor: Colors.black,
                          ),
                          Text("Waiting for news to load..."),
                        ])
                  : SingleChildScrollView(
                      controller: _scrollBottomBarController,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text("Total Result=$length"),
                            Container(
                              child: ListView.builder(
                                  itemCount: newslistCategoryall.length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return FacebookCardPost(
                                      source:
                                          newslistCategoryall[index].source ??
                                              'Sorry !',
                                      title: newslistCategoryall[index].title ??
                                          'Sorry !',
                                      url: newslistCategoryall[index].url ??
                                          'Sorry !',
                                      urlToImage:
                                          newslistCategoryall[index].imageUrl ??
                                              'Sorry !',
                                      author:
                                          newslistCategoryall[index].author ??
                                              'Author Unavailable',
                                      publishedAt: newslistCategoryall[index]
                                              .publishedAt ??
                                          'Sorry',
                                      content:
                                          newslistCategoryall[index].content ??
                                              'Sorry',
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
            ))));
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.initialIndex,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);
  final LoadingBuilder loadingBuilder;

  final int initialIndex;
  final PageController pageController;
  final List<String> galleryItems;
  final Axis scrollDirection;

  Decoration backgroundDecoration = const BoxDecoration(
    color: Colors.black,
  );

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.galleryItems.length; i++)
      debugPrint("???????????????????????? ${widget.galleryItems[i]}");
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Positioned(
              left: 10,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Collection ${currentIndex + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    decoration: null,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "${widget.galleryItems[currentIndex].toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    decoration: null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: AssetImage(widget.galleryItems[index]),
      initialScale: PhotoViewComputedScale.covered * 0.4,
      minScale: PhotoViewComputedScale.contained * 0.4,
      maxScale: PhotoViewComputedScale.covered * 1.0,
    );
  }
}
