import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lakhimpur_kheri/screens/news/a_news_app/ui/screens/settings_screen.dart';
import 'package:lakhimpur_kheri/screens/news2/a_news_app/bottom_nav_bar.dart';
import 'package:lakhimpur_kheri/screens/news/bottom_menu_asGNews.dart';
import 'package:lakhimpur_kheri/screens/news/helper/widgets.dart';
import 'package:lakhimpur_kheri/screens/news/views/localnews.dart';
import 'package:lakhimpur_kheri/screens/news/a_news_app/ui/screens/news_list.dart';
import 'package:lakhimpur_kheri/screens/news/a_news_app/ui/screens/serch_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:lakhimpur_kheri/screens/news2/a_news_app/ui/views/search_bar.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lakhimpur_kheri/screens/news/a_news_app/blocs/news_bloc.dart';
import 'package:lakhimpur_kheri/screens/news2/a_news_app/ui/views/search_bar.dart';
import 'package:lakhimpur_kheri/screens/news/a_news_app/ui/views/stream_builder.dart';
//import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/cupertino.dart';
ScrollController scrollControllerNewsList;
class NewsHome2 extends StatefulWidget {
  final SharedPreferences prefs;

  NewsHome2({this.prefs});

  @override
  _NewsHome2State createState() => _NewsHome2State(prefs: prefs);
}

class _NewsHome2State extends State<NewsHome2> {
  final SharedPreferences prefs;

  _NewsHome2State({this.prefs});

  Brightness _brightness;
  final List colorList2 = [
    Colors.pink,
    Colors.pinkAccent,
    Colors.orange,
    Colors.green,
    Colors.redAccent
  ];
  bool _dark;
  Color colorselected;
  int selectedIndex = 0;
  bool _loading;

  TabController tabController;
  TabController tabControllerLocal;

  int _currentPage;

//Show hide Bottom and Appbar dependencies
  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController =
  new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 56; // set bottom bar height
  double _bottomBarOffset = 0;

  String _countryNameSP = '';
  String _countryCodeSP = '';
  String _imageURL = '';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initApp();
    _loading = true;
    _dark = false;
    colorselected = Colors.pink;
    myScroll();
    _currentPage = 0;
    restore();
    scrollControllerNewsList = ScrollController(initialScrollOffset: 84);
    bloc.fetchAllNews();
  }

  int color;
  String theme;

  initApp() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    List<String> _list = [];
    if (prefs.getBool('firtStart') == null) {
      setState(() {
        sharedPrefs.setStringList('liked', _list);
        sharedPrefs.setString('country', 'US');
        sharedPrefs.setBool('firtStart', false);
        sharedPrefs.setInt('color', 0xFF26A69A);
        sharedPrefs.setString('theme', 'light');
        sharedPrefs.setBool('browser', true);
      });
    } else if (
    sharedPrefs.getBool('firtStart') == false) {
      color = sharedPrefs.getInt('color');
      theme = sharedPrefs.getString('theme');
    }
  }

  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _countryNameSP = (sharedPrefs.getString('countryName') ?? '');
      _countryCodeSP = (sharedPrefs.getString('countryCode') ?? '91');
      _imageURL = (sharedPrefs.getString('imageUrl') ?? '');
      //TODO: More restoring of settings would go here...
    });
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
        selectedItemBorderColor: colorselected,
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
          label: 'Headlines',
        ),
        FFNavigationBarItem(
          iconData: Icons.location_on,
          label: 'Local',
        ),
        FFNavigationBarItem(
          iconData: Icons.bookmark_border,
          label: 'Bookmarks',
        ),
        FFNavigationBarItem(
          iconData: Icons.settings,
          label: 'Settings',
        ),
      ],
    );
  }

  MyAppBar() {
    return AppBar(
      elevation: 4,
      backgroundColor: colorselected,
      title: title("News", "HeadLines"),
      leading: Image.asset(_imageURL),
      bottom: TabBar(
        labelColor: colorselected,
        labelStyle: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 2,
        indicatorColor: Colors.red,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.white),
        isScrollable: true,
        tabs: [
          Tabs("Latest"),
          Tabs("India"),
          Tabs("World"),
          Tabs("Business"),
          Tabs("Entertainment"),
          Tabs("General"),
          Tabs("Health"),
          Tabs("Science"),
          Tabs("Sports"),
          Tabs("Technology"),
        ],
        controller: tabController,
      ),
    );
  }

  MyAppBarLocal() {
    return AppBar(
      elevation: 4,
      backgroundColor: colorselected,
      title: title("Local", "HeadLines"),
      bottom: TabBar(
        labelColor: colorselected,
        labelStyle: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 2,
        indicatorColor: Colors.red,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.white),
        isScrollable: true,
        tabs: [
          Tabs("Lakhimpur"),
          Tabs("Gola"),
          Tabs("Mohammadi"),
          Tabs("Nighasan"),
          Tabs("Paliya"),
          Tabs("Dhorarah"),
          Tabs("Mitoli"),
          Tabs("Science"),
          Tabs("Sports"),
          Tabs("Technology"),
        ],
        controller: tabControllerLocal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    restore();
    return getPage(_currentPage);
  }

  getPage(int page) {
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
        return Scaffold(
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
            body: Container());
      case 1:
        return DefaultTabController(
          length: 10,
          child: Scaffold(
              appBar: _showAppbar
                  ? MyAppBar()
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
              body: NewsList()),
        );
      case 2:
        return DefaultTabController(
            length: 10,
            child: Scaffold(
                appBar: _showAppbar
                    ? MyAppBarLocal()
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
                body: _tabBarViewLocal()));
      case 3:
        return Scaffold(
            appBar: AppBar(
              backgroundColor: colorselected,
              title: title("Saved", "Articles"),
            ),
            bottomNavigationBar: bottomNavbar(),
            body: Container());
      case 4:
        return Scaffold(
            appBar: AppBar(
              backgroundColor: colorselected,
              title: title("News", "Setting"),
            ),
            bottomNavigationBar: bottomNavbar(),
            body: SettingsScreen());
    }
  }

  Widget _tabBarView() {
    return TabBarView(controller: tabController, children: [
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: NewsList(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: _safeAreaForCategory(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: _safeAreaForCategory(),
      ),
      new GestureDetector(
        onTap: () {},
        child: _safeAreaForCategory(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: _safeAreaForCategory(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: _safeAreaForCategory(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: _safeAreaForCategory(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: _safeAreaForCategory(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: _safeAreaForCategory(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: _safeAreaForCategory(),
      ),
    ]);
  }

  Widget _tabBarViewLocal() {
    return TabBarView(controller: tabControllerLocal, children: [
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: Container(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: Container(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: Container(),
      ),
      new GestureDetector(
        onTap: () {},
        child: Container(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: Container(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: Container(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: Container(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: Container(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: Container(),
      ),
      new GestureDetector(
        onTap: () {
          // Change the color of the container beneath
        },
        child: Container(),
      ),
    ]);
  }

  _safeAreaForCategory() {
    bloc.fetchAllNews();
    return SafeArea(
      child: CustomScrollView(
        controller: scrollControllerNewsList,
        slivers: <Widget>[
          streamBuilder(bloc.allNews),
        ],
      ),
    );
  }
}
