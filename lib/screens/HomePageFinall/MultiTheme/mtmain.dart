import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lakhimpur_kheri/model/model_localArticle.dart';
import 'package:lakhimpur_kheri/model/model_localArticle.dart';
import 'package:lakhimpur_kheri/model/model_note.dart';
import 'package:lakhimpur_kheri/ruf2.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/Model/categoryModel.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/Model/productModel.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/Model/theme_model.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/UI/Widgets/custom_shape.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/UI/Widgets/mainui_customcard.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/UI/settings.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/UI/settings.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/drawer/settings/profile_page.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/drawer/settings/settings_page.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/homePage/HomePage2.dart';
import 'package:lakhimpur_kheri/helper/database_helper.dart';
import 'package:lakhimpur_kheri/screens/health_n_fitness/fitness_app/fitness_app_home_screen.dart';
import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/goals/app.dart';
import 'package:lakhimpur_kheri/screens/news/news.dart';
import 'package:lakhimpur_kheri/screens/shops/project1/userScreens/myHomePage.dart';
import 'package:lakhimpur_kheri/utils/ml_kit/text_recognition.dart';
import 'package:lakhimpur_kheri/utils/rss_feeds_nasa.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/homePage/dependency.dart';
import 'package:lakhimpur_kheri/utils/slide_list_view.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/homePage/menu.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lakhimpur_kheri/login/authentication_bloc/authentication_bloc.dart';
class MainUI extends StatefulWidget {
  final SharedPreferences prefs;
  ThemeModel model;
  MainUI(this.model,{this.prefs});
  @override
  _MainUIState createState() => _MainUIState(this.model,prefs: prefs);
}

class _MainUIState extends State<MainUI> {
  DataHelper databaseHelper = DataHelper();
  List<ModelNote> cashList = List<ModelNote>();
  List<ModelArticle> articleList;
  int count = 0;
  final SharedPreferences prefs;
  ThemeModel model;
  _MainUIState(this.model,{this.prefs});
  final GoogleSignIn _gSignIn = GoogleSignIn();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final Color active = Colors.grey.shade800;
  bool isExpanded = false;
  List<CategoryMT> categoryItems;
  List<Product> trendingListItems;
  List<Product> recommendListItems;
  List<Product> dealsListItems;
  double _height;
  double _width;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // model = ThemeModel();
    trendingListItems = [
      Product(
          123,
          "02 Apr 2019",
          "Lenovo T450",
          "Discover the Lenovo ThinkPad T450, a 14-inch thin and light business Ultrabook with the newest Intel Core i processor, backlit keyboard and up to 17 hours battery backup.",
          40000,
          "5 months",
          "Electronics",
          8377028021,
          "assets/images/lenovot450.jpg",
          true),
      Product(
          124,
          "05 Apr 2019",
          "Samsung S9+",
          "Discover Galaxy S9 and S9+ and the revolutionary camera that adapts like the human eye.",
          60000,
          "5 months",
          "Mobiles",
          8377028021,
          "assets/images/samsuns9+.jpg",
          true),
      Product(
          125,
          "23 Mar 2019",
          "Himalayan",
          "The Himalayan is an ‘all-rounder’ motorcycle built on an all new platform from Royal Enfield. It is a 411cc adventure motorcycle which was partly developed in the United Kingdom. The motorcycle brings a series of firsts for the brand.",
          100000,
          "5 months",
          "Bike",
          8377028021,
          "assets/images/bike.jpg",
          true),
      Product(
          126,
          "10 Feb 2019",
          "Canon 200D",
          "Canon EOS 200D 24.2MP Digital SLR Camera + EF-S 18-55 mm f4 is STM Lens, Free Camera Case and 16GB Card Inside",
          35000,
          "5 months",
          "Electronics",
          8377028021,
          "assets/images/canon.jpg",
          true),
      Product(
          127,
          "1 Jan 2019",
          "Sofa",
          "Bharat Lifestyle Nano Fabric 6 Seater Sofa",
          4000,
          "5 months",
          "Furniture",
          8377028021,
          "assets/images/sofa.jpg",
          true),
    ];
    recommendListItems = [
      Product(
          124,
          "05 Apr 2019",
          "Samsung S9+",
          "Discover Galaxy S9 and S9+ and the revolutionary camera that adapts like the human eye.",
          60000,
          "5 months",
          "Mobiles",
          8377028021,
          "assets/images/samsuns9+.jpg",
          true),
      Product(
          123,
          "02 Apr 2019",
          "Lenovo T450",
          "Discover the Lenovo ThinkPad T450, a 14-inch thin and light business Ultrabook with the newest Intel Core i processor, backlit keyboard and up to 17 hours battery backup.",
          40000,
          "5 months",
          "Electronics",
          8377028021,
          "assets/images/lenovot450.jpg",
          true),
      Product(
          125,
          "03 Dec 2018",
          "Himalayan",
          "The Himalayan is an ‘all-rounder’ motorcycle built on an all new platform from Royal Enfield. It is a 411cc adventure motorcycle which was partly developed in the United Kingdom. The motorcycle brings a series of firsts for the brand.",
          100000,
          "5 months",
          "Bike",
          8377028021,
          "assets/images/bike.jpg",
          true),
      Product(
          126,
          "15 Mar 2019",
          "Canon 200D",
          "Canon EOS 200D 24.2MP Digital SLR Camera + EF-S 18-55 mm f4 is STM Lens, Free Camera Case and 16GB Card Inside",
          35000,
          "5 months",
          "Electronics",
          8377028021,
          "assets/images/canon.jpg",
          true),
      Product(
          127,
          "09 Apr 2019",
          "Sofa",
          "Bharat Lifestyle Nano Fabric 6 Seater Sofa",
          4000,
          "5 months",
          "Furniture",
          8377028021,
          "assets/images/sofa.jpg",
          true),
    ];
    dealsListItems = [
      Product(
          125,
          "02 Jan 2019",
          "Himalayan",
          "The Himalayan is an ‘all-rounder’ motorcycle built on an all new platform from Royal Enfield. It is a 411cc adventure motorcycle which was partly developed in the United Kingdom. The motorcycle brings a series of firsts for the brand.",
          100000,
          "5 months",
          "Bike",
          8377028021,
          "assets/images/bike.jpg",
          true),
      Product(
          126,
          "10 Apr 2019",
          "Canon 200D",
          "Canon EOS 200D 24.2MP Digital SLR Camera + EF-S 18-55 mm f4 is STM Lens, Free Camera Case and 16GB Card Inside",
          35000,
          "5 months",
          "Electronics",
          8377028021,
          "assets/images/canon.jpg",
          true),
      Product(
          124,
          "05 Mar 2019",
          "Samsung S9+",
          "Discover Galaxy S9 and S9+ and the revolutionary camera that adapts like the human eye.",
          60000,
          "5 months",
          "Mobiles",
          8377028021,
          "assets/images/samsuns9+.jpg",
          true),
      Product(
          123,
          "02 Feb 2019",
          "Lenovo T450",
          "Discover the Lenovo ThinkPad T450, a 14-inch thin and light business Ultrabook with the newest Intel Core i processor, backlit keyboard and up to 17 hours battery backup.",
          40000,
          "5 months",
          "Electronics",
          8377028021,
          "assets/images/lenovot450.jpg",
          true),
      Product(
          127,
          "02 Dec 2012",
          "Sofa",
          "Bharat Lifestyle Nano Fabric 6 Seater Sofa",
          4000,
          "5 months",
          "Furniture",
          8377028021,
          "assets/images/sofa.jpg",
          true),
    ];
  }

  void _expand() {
    setState(() {
      isExpanded ? isExpanded = false : isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider.value(
        value: widget.model,
        child: Consumer<ThemeModel>(builder: (context, model, __) {
          print("Value of primary main color is: ${model.primaryMainColor}");
          return Scaffold(
              key: scaffoldKey,
              drawer: _drawer(model),
              appBar: AppBar(
                backgroundColor: model.appbarShadeColor,
                centerTitle: true,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Opacity(
                      opacity: 1.0,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingNew(model: model,)),
                            );
                          },
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: _height / 30,
                          )),
                    ),
                  ),
                ],
                leading: Opacity(
                  opacity: 1.0,
                  child: GestureDetector(
                      onTap: () {
                        scaffoldKey.currentState.openDrawer();
                      },
                      child: Image.asset(
                        'assets/images/menubutton.png',
                        color: Colors.white,
                        scale: 25,
                      )),
                ),
                title: Text(
                  'Multi Theme',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'GilroySemiBold'),
                ),
              ),
              backgroundColor: Colors.amber[200],
              body: Container(child:
              SlideListView(
                view1: _body(context),
                view2: GridMenu(),
                floatingActionButtonColor: model.primaryMainColor,
                floatingActionButtonIcon: AnimatedIcons.menu_home,
                showFloatingActionButton: true,
                defaultView: "slides",
                duration: Duration(
                  milliseconds: 800,
                ),
              ))
          );
        }));
  }

  Widget _body(BuildContext context,){
    return Container(
      color: Colors.white,
      height: _height,
      width: _width,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            clipShape(model),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Shop for', style: TextStyle(fontSize: 16,fontFamily: 'GilroyBold')),
                  GestureDetector(
                      onTap: _expand,
                      child: Text(
                        isExpanded ? "Show less" : "Show all",
                        style: TextStyle(color: model.textColor,fontFamily: 'GilroyBold'),
                      )),
                  //IconButton(icon: isExpanded? Icon(Icons.arrow_drop_up, color: Colors.orange[200],) : Icon(Icons.arrow_drop_down, color: Colors.orange[200],), onPressed: _expand)
                ],
              ),
            ),
            expandList(),
            Divider(color: model.dividerColor,),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Trending",style: TextStyle(fontSize: 16,fontFamily: 'GilroyBold')),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TextRecognition()),
                        );
                        print('Showing all');
                      },
                      child: Text(
                          'Show all',
                          style: TextStyle(fontSize: 16,fontFamily: 'GilroyBold')
                      ))
                ],
              ),
            ),
            trendingProducts(),
            Divider(),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Recommendations",
                      style: TextStyle(fontSize: 16)),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TextRecognition()),
                        );
                      },
                      child: Text(
                        'Show all',
                        style: TextStyle(color: model.textColor),
                      ))
                ],
              ),
            ),
            recommendations(),
            Divider(),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Today's Deals",
                      style: TextStyle(
                          color: model.textColor, fontSize: 16)),
                  GestureDetector(
                      onTap: () {
                        //Navigator.of(context).pushNamed(DEALS_UI);
                        print('Showing all');
                      },
                      child: Text(
                        'Show all',
                        style: TextStyle(
                          color: Colors.orange[300],
                        ),
                      ))
                ],
              ),
            ),
            todaysDeals(),
          ],
        ),
      ),
    );
  }
  Widget _drawer(ThemeModel model) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: 0.75,
            child: Container(
              height: _height / 6,
              padding: EdgeInsets.only(top: _height / 20),
              color: model.appbarShadeColor,
//              decoration: BoxDecoration(
//                gradient: LinearGradient(
//                  colors: [Colors.orange[200], Colors.pinkAccent],
//                ),
//              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color:model.accentShadeColor ,
                  ),
                  radius: 30,
                  backgroundColor: Colors.white,
                ),
                title: Text("FlutterDevs"),
                subtitle: Text(
                  "flutterDevs@aeologic.com",
                  style: TextStyle(fontSize: 13),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          GestureDetector(
            child: Text("hello"),
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (_) => new NewsHome()),
              );
            },
          ),
          SizedBox(height: 30.0),
          GestureDetector(
            child: _buildRow(Icons.location_city,
                AppTranslations.of(context).text("key_lmp"), 1),
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (_) => new FitnessAppHomeScreen()),
              );
            },
          ),
          _buildDivider(),
          GestureDetector(
            child: _buildRow(FontAwesomeIcons.user, "My Profile", 5),
            onTap: () {
              Navigator.pop(context, true);
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (_) => new ProfilePage(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildRow(Icons.notifications, "Notifications", 4,
              showBadge: true),
          _buildDivider(),
          GestureDetector(
            child: _buildRow(Icons.settings, "Settings", 5),
            onTap: () {
              Navigator.pop(context, true);
              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (_) => new Setting(prefs: prefs)),
              );
            },
          ),
          _buildDivider(),
          GestureDetector(
            child: _buildRow(Icons.dashboard, "Dashboard", 5),
            onTap: () {
              Navigator.pop(context, true);
              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (_) => new DashBoard()),
              );
            },
          ),
          _buildDivider(),
          _buildRow(Icons.email, "Contact us", 6),
          _buildDivider(),
          GestureDetector(
            child: _buildRow(Icons.share, "Share", 5),
            onTap: () {
              Share.share(
                  'Install and Manage Your Zakat https://play.google.com/store/apps/details?id=com.quranreading.zakatcalculator&hl=en_IN ',
                  subject: 'Manage your zakat!');
            },
          ),
          _buildDivider(),
          _buildRow(Icons.info_outline, "Help", 7),
          _buildDivider(),
          GestureDetector(
            child: _buildRow(Icons.power_settings_new, "Logout", 7),
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationLoggedOut(),
              );
            },
          ),
          _buildDivider(),
        ],
      ),
    );
  }
  Divider _buildDivider() {
    return Divider(
      color: Colors.grey.shade600,
    );
  }
  Widget _buildRow(IconData icon, String title, int navigation, {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: [
        Icon(
          icon,
          color: active,
        ),
        SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
        Spacer(),
        if (showBadge)
          Material(
            color: Colors.deepOrange,
            elevation: 5.0,
            shadowColor: Colors.red,
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                "10+",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
      ]),
    );
  }
  Widget clipShape(ThemeModel model) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _height / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [model.primaryMainColor,Colors.white38]
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _height / 3.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [model.primaryMainColor,Colors.white70]
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.25,
          child: ClipPath(
            clipper: CustomShapeClipper3(),
            child: Container(
              height: _height / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [model.primaryMainColor,Colors.white],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: _height / 3.75),
          child: Material(
            borderRadius: BorderRadius.circular(40.0),
            elevation: 8,
            child: Container(
              child: TextFormField(
                cursorColor: Colors.orange[200],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(fillColor: Colors.yellow,
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: Icon(Icons.search,
                      color: Colors.black, size: 30),
                  hintText: "What're you looking for?",
                  hintStyle:
                  TextStyle(color: Colors.black, fontFamily: 'GilroySemiBold'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }

  Widget expandList() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: AnimatedCrossFade(
        firstChild: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          children: <Widget>[
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (_) => new NewsHome()));
                  },
                  child: Image.asset(
                    'assets/images/gadget.png',
                    height: _height / 12,
                    width: _width / 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Electronics",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (_) => new SignInOne()));
                    },
                    child: Image.asset(
                      'assets/images/house.png',
                      height: _height / 12,
                      width: _width / 12,
                    )),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Properties",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext ctx) => GoalsHome()));
                    },
                    child: Image.asset(
                      'assets/images/job.png',
                      height: _height / 12,
                      width: _width / 12,
                    )),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Jobs",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () async{
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext ctx) => RSSDemo()));
                      //Navigator.of(context).pushNamed(FURNITURE_ITEM_LIST);
                      print('Routing to Furniture item list');
                      debugPrint("'Routing to Furniture item list :::$cashList");
                    },
                    child: Image.asset(
                      'assets/images/sofa.png',
                      height: _height / 12,
                      width: _width / 12,
                    )),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Furniture",    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext ctx) => Project1HomePage()));
                    //Navigator.of(context).pushNamed(CARS_ITEM_LIST);
                    print('Routing to Cars item list');
                  },
                  child: Image.asset(
                    'assets/images/car.png',
                    height: _height / 12,
                    width: _width / 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Cars",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pushNamed(BIKES_ITEM_LIST);
                    print('Routing to Bikes item list');
                  },
                  child: Image.asset(
                    'assets/images/bike.png',
                    height: _height / 12,
                    width: _width / 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Bikes",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      //Navigator.of(context).pushNamed(MOBILES_ITEM_LIST);
                      print('Routing to Mobiles item list');
                    },
                    child: Image.asset(
                      'assets/images/smartphone.png',
                      height: _height / 12,
                      width: _width / 12,
                    )),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Mobiles",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pushNamed(PETS_ITEM_LIST);
                    print('Routing to Pets item list');
                  },
                  child: Image.asset(
                    'assets/images/pet.png',
                    height: _height / 12,
                    width: _width / 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Pets",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
          ],
        ),
        secondChild: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          children: <Widget>[
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pushNamed(ELECTRONICS_ITEM_LIST);
                    print('Routing to Electronics item list');
                  },
                  child: Image.asset(
                    'assets/images/gadget.png',
                    height: _height / 12,
                    width: _width / 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Electronics",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      //Navigator.of(context).pushNamed(PROPERTIES_ITEM_LIST);
                      print('Routing to Properties item list');
                    },
                    child: Image.asset(
                      'assets/images/house.png',
                      height: _height / 12,
                      width: _width / 12,
                    )),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Properties",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      //Navigator.of(context).pushNamed(JOBS_ITEM_LIST);
                      print('Routing to Jobs item list');
                    },
                    child: Image.asset(
                      'assets/images/job.png',
                      height: _height / 12,
                      width: _width / 12,
                    )),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Jobs",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      //Navigator.of(context).pushNamed(FURNITURE_ITEM_LIST);
                      print('Routing to Furniture item list');
                    },
                    child: Image.asset(
                      'assets/images/sofa.png',
                      height: _height / 12,
                      width: _width / 12,
                    )),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Furniture",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pushNamed(CARS_ITEM_LIST);
                    print('Routing to Cars item list');
                  },
                  child: Image.asset(
                    'assets/images/car.png',
                    height: _height / 12,
                    width: _width / 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Cars",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pushNamed(BIKES_ITEM_LIST);
                    print('Routing to Bikes item list');
                  },
                  child: Image.asset(
                    'assets/images/bike.png',
                    height: _height / 12,
                    width: _width / 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Bikes",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      //Navigator.of(context).pushNamed(MOBILES_ITEM_LIST);
                      print('Routing to Mobiles item list');
                    },
                    child: Image.asset(
                      'assets/images/smartphone.png',
                      height: _height / 12,
                      width: _width / 12,
                    )),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Mobiles",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pushNamed(PETS_ITEM_LIST);
                    print('Routing to Pets item list');
                  },
                  child: Image.asset(
                    'assets/images/pet.png',
                    height: _height / 12,
                    width: _width / 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Pets",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pushNamed(FASHION_ITEM_LIST);
                    print('Routing to Fashion item list');
                  },
                  child: Image.asset(
                    'assets/images/dress.png',
                    height: _height / 12,
                    width: _width / 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    "Fashion",
                    style: TextStyle(fontSize: 13,fontFamily: 'GilroyMedium'),
                  ),
                ),
              ],
            ),
          ],
        ),
        crossFadeState:
        isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      ),
    );
  }

  Widget trendingProducts() {
    return Container(
      height: _height / 4.25,
      //width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        itemCount: trendingListItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) {
          return _buildTrendingEntries(context, index, trendingListItems);
        },
      ),
    );
  }

  Widget _buildTrendingEntries(BuildContext context, int index, List<Product> listItem) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed(DETAIL_UI);
        print("Routing to trending list page");
      },
      child: CustomCard(
        title: '${listItem[index].title}',
        category: '${listItem[index].category}',
        price: "₹${listItem[index].price}",
        dateAdded: "${listItem[index].dateAdded}",
        description: "${listItem[index].desc}",
        image: "${listItem[index].image}",
        location: "Sector 62, Noida",
      ),
    );
  }


  void updateListViewCIB() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelNote>> cashListFuture = databaseHelper.getNotes();
      cashListFuture.then((cashList) {
        setState(() {
          this.cashList = cashList;
          this.count = cashList.length;
          debugPrint("'Routing to count is: $count");
          debugPrint("'cash list is: $cashList");
        });
      });
    });
  }
  void _showSnackBar(BuildContext context, String message) {
    final snackBar =
    SnackBar(content: Text(message), duration: Duration(seconds: 5));
    Scaffold.of(context).showSnackBar(snackBar);
  }
  Widget recommendations() {
    return Container(
      height: _height / 4.25,
      //width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        itemCount: recommendListItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) {
          return _buildRecommendationsEntries(
              context, index, recommendListItems);
        },
      ),
    );
  }

  Widget _buildRecommendationsEntries(BuildContext context, int index, List<Product> listItem) {
    return GestureDetector(
      onTap: () {
        //Navigator.of(context).pushNamed(DETAIL_UI);
        print("Routing to detail page");
      },
      child: CustomCard(
        title: '${listItem[index].title}',
        category: '${listItem[index].category}',
        price: "₹${listItem[index].price}",
        dateAdded: "${listItem[index].dateAdded}",
        description: "${listItem[index].desc}",
        image: "${listItem[index].image}",
        location: "Sector 62, Noida",
      ),
    );
  }

  Widget todaysDeals() {
    return Container(
      height: _height / 4.25,
      //width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        itemCount: dealsListItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) {
          return _buildDealsEntries(context, index, dealsListItems);
        },
      ),
    );
  }

  Widget _buildDealsEntries(BuildContext context, int index, List<Product> listItem) {
    return GestureDetector(
      onTap: () {
        //Navigator.of(context).pushNamed(DETAIL_UI);
        print("Routing to detail page");
      },
      child: CustomCard(
        title: '${listItem[index].title}',
        category: '${listItem[index].category}',
        price: "₹${listItem[index].price}",
        dateAdded: "${listItem[index].dateAdded}",
        description: "${listItem[index].desc}",
        image: "${listItem[index].image}",
        location: "Sector 62, Noida",
      ),
    );
  }
}
