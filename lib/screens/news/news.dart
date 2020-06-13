import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lakhimpur_kheri/screens/news/views/card_view.dart';
import 'package:lakhimpur_kheri/screens/news/bottom_menu_asGNews.dart';
import 'package:lakhimpur_kheri/screens/news/helper/widgets.dart';
import 'package:lakhimpur_kheri/screens/news/models/news_model.dart';
import 'package:lakhimpur_kheri/screens/news/top_ten_news/newsCard.dart';
import 'package:lakhimpur_kheri/screens/news/views/gallery_images_display.dart';
import 'package:lakhimpur_kheri/screens/news/views/localDataView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper/news.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lakhimpur_kheri/screens/news/explore_news/homepage.dart';
import 'top_ten_news/newsList.dart';
import 'package:lakhimpur_kheri/model/model_localArticle.dart';

//import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/cupertino.dart';
import 'package:lakhimpur_kheri/zCountryPicker/country.dart';
import 'package:lakhimpur_kheri/zCountryPicker/country_pickers.dart';
import 'package:lakhimpur_kheri/screens/news/a_news_app/ui/screens/serch_screen.dart';
import 'package:http/http.dart' show Client;
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:lakhimpur_kheri/helper/database_helper.dart';

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
  bool _newsloading, _firebaseloading, _localloading;
  int _currentPage;
  int selectedIndex = 0;

  List<Articles> newsList = [];
  List<Articles> firestoreList = [];
  List<ModelArticle> localArticalList = [];
  List<Articles> localArticalMapList = [];
  DataHelper databaseHelper = DataHelper();
  TabController tabController;
  TabController tabControllerLocal;
  TabController tabControllerDownloads;
  TabController tabControllerForYou;

//Show hide Bottom and Appbar dependencies
  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController = new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 56; // set bottom bar height
  double _bottomBarOffset = 0;
  int newsListLength;
  int firestoreListLength;
  int loacalArticleLength = 0;
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
    NewsApiProvider2 news = NewsApiProvider2();
    await news.getFavoriteNews();
    firestoreList = news.list2;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restore();
    updateLoacalListView();
    _newsloading = true;
    _firebaseloading = true;
    _localloading = true;
    _dark = false;
    colorselected = Colors.pink;
    myScroll();
    _currentPage = 0;
    getNews();
    firestoreNews();

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
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.local_library), title: Text('For You')),
        BottomNavigationBarItem(
          icon: Icon(Icons.language),
          title: Text('World'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.location_on), title: Text('Local')),
        BottomNavigationBarItem(
            icon: Icon(Icons.explore), title: Text('Explore')),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          title: Text('Saved'),
        )
      ],
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.black54,
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
                  Icons.search,
                  semanticLabel: 'search',
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SearchScreen(title: "News")));
                },
              ),
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 6.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      size: 32.0,
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
          length: 10,
          child: new Scaffold(
            body: new NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  new SliverAppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0.0,
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
                                    .then((val) => refereshNews());
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
              body: _tabBarViewWorld(),
            ),
            bottomNavigationBar:bottomNavbar()
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
                    automaticallyImplyLeading: false,
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
                                    .then((val) => refereshNews());
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
              body: _tabBarViewLocal(),
            ),
            bottomNavigationBar:  bottomNavbar()
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
                bottomNavigationBar: bottomNavbar(),
                body: _tabBarViewsDownload()));
    }
  }

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
      controller: tabController,
    );
  }

  TabBarView _tabBarViewWorld() {
    debugPrint("in ........................_tabBarView");
    return TabBarView(controller: tabController, children: [
      _safeAreaForCategory(newsList, _newsloading, newsListLength),
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
      controller: tabControllerLocal,
    );
  }

  TabBarView _tabBarViewLocal() {
    debugPrint("in ........................_tabBarView");
    return TabBarView(controller: tabControllerLocal, children: [
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
          Tabs("Local"),
          Tabs("Cloud"),
          Tabs("G-Drive"),
          Tabs("Gallery"),
        ],
        controller: tabControllerDownloads,
      ),
    );
  }

  TabBarView _tabBarViewsDownload() {
    return TabBarView(controller: tabControllerDownloads, children: [
      _safeAreaForCategory2(
          localArticalList, _localloading, loacalArticleLength),
      _safeAreaForCategory(
          firestoreList, _firebaseloading, firestoreListLength),
      Container(),
      Container(child:GalleryImagesDisplay()),
    ]);
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



  _safeAreaForCategory(
      List<Articles> newslistCategoryall, bool loading, int length) {
//    print(newslistCategoryall[0].source.name.runtimeType);
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, right: 12),
                              child: Container(
                                child: ListView.builder(
                                    itemCount: newslistCategoryall.length,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return CardView(
                                        title: newslistCategoryall[index].title,
                                        url: newslistCategoryall[index].url,
                                        author:
                                            newslistCategoryall[index].author,
                                        source: newslistCategoryall[index]
                                            .source
                                            .name,
                                        urlToImage: newslistCategoryall[index]
                                            .urlToImage,
                                        publishedAt: newslistCategoryall[index]
                                            .publishedAt,
                                        content:
                                            newslistCategoryall[index].content,
                                        category: 'all',
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ))));
  }

  _safeAreaForCategory2(
      List<ModelArticle> newslistCategoryall, bool loading, int length) {
//    print(newslistCategoryall[0].source.name.runtimeType);
    return Container(
        child: RefreshIndicator(
            backgroundColor: Colors.black,
            onRefresh: refereshLocal,
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
                            Text("Total Downloads=$length"),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, right: 12),
                              child: Container(
                                child: ListView.builder(
                                    itemCount: newslistCategoryall.length,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return LocalDataView(
                                        title: newslistCategoryall[index].title,
                                        url: newslistCategoryall[index].url,
                                        author:
                                            newslistCategoryall[index].author,
                                        source:
                                            newslistCategoryall[index].source,
                                        urlToImage: newslistCategoryall[index]
                                            .imageToUrl,
                                        publishedAt: newslistCategoryall[index]
                                            .publishedAt,
                                        content:
                                            newslistCategoryall[index].content,
                                        category: 'all',
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ))));
  }
}
