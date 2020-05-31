import 'package:lakhimpur_kheri/screens/news/fitness_app/ui_view/body_measurement.dart';
import 'package:lakhimpur_kheri/screens/news/fitness_app/ui_view/glass_view.dart';
import 'package:lakhimpur_kheri/screens/news/fitness_app/ui_view/mediterranesn_diet_view.dart';
import 'package:lakhimpur_kheri/screens/news/fitness_app/ui_view/title_view.dart';
import 'package:lakhimpur_kheri/screens/news/fitness_app/fintness_app_theme.dart';
import 'package:lakhimpur_kheri/screens/news/fitness_app/my_diary/meals_list_view.dart';
import 'package:lakhimpur_kheri/screens/news/fitness_app/my_diary/water_view.dart';
import 'package:flutter/material.dart';
import 'package:lakhimpur_kheri/screens/news/helper/widgets.dart';
import 'package:lakhimpur_kheri/zCountryPicker/utils/utils.dart';

class WorldNewsMyDiaryScreen extends StatefulWidget {
  const WorldNewsMyDiaryScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _WorldNewsMyDiaryScreenState createState() => _WorldNewsMyDiaryScreenState();
}

class _WorldNewsMyDiaryScreenState extends State<WorldNewsMyDiaryScreen>
    with TickerProviderStateMixin {
  TabController tabController;
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 9;

    listViews.add(
      TitleView(
        titleTxt: 'Mediterranean diet',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    listViews.add(
      MediterranesnDietView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'News Category',
        subTxt: 'Customize',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      MealsListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Body measurement',
        subTxt: 'Today',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      BodyMeasurementView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Water',
        subTxt: 'Aqua SmartBottle',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      WaterView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 7, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
    listViews.add(
      GlassView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController,
                  curve: Interval((1 / count) * 8, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }


  Widget _tabBarView() {
    debugPrint("in ........................_tabBarView");
    return TabBarView(controller: tabController, children: [
    Center(child:Text("Container 1")),
      Center(child:Text("Container 1")),
      Center(child:Text("Container 1")),
      Center(child:Text("Container 1")),
      Center(child:Text("Container 1")),
      Center(child:Text("Container 1")),
      Center(child:Text("Container 1")),
      Center(child:Text("Container 1")),
      Center(child:Text("Container 1")),
      Center(child:Text("Container 1")),
    ]);
  }
  MyAppBar() {
    return AppBar(
      leading: Icon(null),
      title:  title(
           "Country",
            "HeadLines"),
      elevation: 2,
      backgroundColor: Colors.orange,
      actions: <Widget>[
      ],
      bottom: TabBar(
        labelColor: Colors.orange,
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
            color: Colors.white),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: FintnessAppTheme.background,
        child: DefaultTabController(
      length: 10,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MyAppBar(),
          body: Stack(
            children: <Widget>[
              _tabBarView(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),),
    ));
  }
}

