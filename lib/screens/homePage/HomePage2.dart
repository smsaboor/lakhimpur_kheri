
import 'package:lakhimpur_kheri/screens/health_n_fitness/health_fitness.dart';
import 'package:lakhimpur_kheri/screens/homePage/menu.dart';
import 'package:lakhimpur_kheri/screens/news/a_news_app/news_app_main.dart';
import 'package:lakhimpur_kheri/screens/news/newsFitnessCopy.dart';
import 'package:lakhimpur_kheri/screens/news/news_web/src/ui/home_page.dart';
import 'package:lakhimpur_kheri/screens/news/ui/screens/onboarding_screen.dart';
import 'package:lakhimpur_kheri/screens/news2/a_news_app/news_app_main.dart';
import 'package:lakhimpur_kheri/screens/schools/schools.dart';
import 'package:lakhimpur_kheri/screens/schools/schools.dart';
import 'package:lakhimpur_kheri/screens/homePage/circular_menu.dart';
import 'package:lakhimpur_kheri/screens/homePage/circular_menu_item.dart';
import 'dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lakhimpur_kheri/screens/homePage/slide_list_view.dart';
import 'package:lakhimpur_kheri/features/buy_ticket_design/btd_main.dart';

final List rooms = [
  {"image": "assets/hotel/room1.jpg", "title": "Awesome room near Bouddha"},
  {"image": "assets/hotel/room2.jpg", "title": "Peaceful Room"}
];

class HomePage2 extends StatefulWidget {
  HomePage2();

  @override
  State<StatefulWidget> createState() {
    return _HomePage2State();
  }
}

class _HomePage2State extends State<HomePage2> {
  _HomePage2State();
  SharedPreferences prefs;
  String _colorName = 'No';
  Color _color = Colors.black;
    String  _email;
  String _url;
  String _name;
  DashboardOnePage dop = new DashboardOnePage();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;
  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };
  int lang = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;
  var appLanguage;
  final GoogleSignIn _gSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    restore();
  }
   restore() async {
     prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = (prefs.getString('email') ?? 'ASIS');
      _url = (prefs.getString('url') ?? 'ASIS');
      _name= (prefs.getString('name') ?? 'ASIS');
    });
     }
  @override
  void dispose() {
    super.dispose();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      //setState(() {
      _currentPosition = position;
      //});
      _getAddressFromLatLng();
      debugPrint(
          "Geo location is ...........................$_currentPosition");
    }).catchError((e) {
      print(e);
      final snackBar = SnackBar(
        content: Text('Unable to fetch location.'),
        duration: Duration(seconds: 5),
      );

      scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        String _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        debugPrint('User Location: $_currentAddress');
        debugPrint(
            "Geo Address is ...........................$_currentAddress");
      });
    } catch (e) {
      print(e);
      final snackBar = SnackBar(
        content: Text('Unable to get geo-location.'),
        duration: Duration(seconds: 5),
      );

      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to Exit ?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.pop(context, true);
                      Navigator.pop(context, true);
                    }),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            key: _key,
            drawer: _buildDrawer(),
            body: Container(child:
              SlideListView(
                view1: _buildHomePage(),
                view2: Menu(),
                floatingActionButtonColor: Colors.yellow[800],
                floatingActionButtonIcon: AnimatedIcons.view_list,
                showFloatingActionButton: true,
                defaultView: "slides",
                duration: Duration(
                  milliseconds: 800,
                ),
    )));
  }

  Widget _buildRooms(BuildContext context, int index) {
    var room = rooms[index % rooms.length];
    return Container(
      margin: EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.asset(room['image']),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Icon(
                        Icons.star,
                        color: Colors.grey.shade800,
                        size: 20.0,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Icon(
                        Icons.star_border,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    Positioned(
                      bottom: 20.0,
                      right: 10.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        color: Colors.white,
                        child: Text("\$40"),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        room['title'],
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text("Bouddha, Kathmandu"),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "(220 reviews)",
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 150.0,
          backgroundColor: Colors.cyan,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              _key.currentState.openDrawer();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.language,
                color: Colors.white,
              ),
              onPressed: () {
                if (lang == 1) {
                  setState(() {
                    lang = 0;
                  });
                  application
                      .onLocaleChanged(Locale(languagesMap[languagesList[1]]));
                } else {
                  setState(() {
                    lang = 1;
                  });
                  application
                      .onLocaleChanged(Locale(languagesMap[languagesList[0]]));
                }
              },
            ),
          ],
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              child: SizedBox(
                  child: Image.asset('assets/smwallet/d28.gif'),
                  height: 100,
                  width: 100),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 10.0,
          ),
        ),
        SliverToBoxAdapter(
          child: _buildCategories(),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return _buildRooms(context, index);
          }, childCount: 10),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 400,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: Category(
                    backgroundColor: Colors.pink,
                    icon: Icons.chrome_reader_mode,
                    title: AppTranslations.of(context).text("key_news"),
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (_) => new NewsHome()));
                  }),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: Category(
                    backgroundColor: Colors.blue,
                    title: AppTranslations.of(context).text("key_jobs"),
                    icon: Icons.account_circle,
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (_) => new NewsApp()));
                  }),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: Category(
                    icon: Icons.school,
                    backgroundColor: Colors.yellow[600],
                    title: AppTranslations.of(context).text("key_schools"),
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (_) => BuyTicketDesign()));
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: Category(
                    backgroundColor: Colors.green,
                    icon: Icons.hotel,
                    title: AppTranslations.of(context).text("key_hotels"),
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (_) => new NewsFitnessAppHomeScreen()));
                  }),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: Category(
                    backgroundColor: Colors.lightBlueAccent,
                    title: AppTranslations.of(context).text("key_restorent"),
                    icon: Icons.restaurant,
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (_) => new NewsApp2()));
                  }),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: Category(
                    icon: Icons.local_cafe,
                    backgroundColor: Colors.orange,
                    title: AppTranslations.of(context).text("key_tuition"),
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (_) => new NewsWebHomePage()));
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 15.0,
              ),
              Category(
                backgroundColor: Colors.teal,
                icon: Icons.departure_board,
                title: AppTranslations.of(context).text("key_travels"),
              ),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: Category(
                    icon: Icons.shopping_cart,
                    backgroundColor: Colors.redAccent,
                    title: AppTranslations.of(context).text("key_shopping"),
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (_) => new HomePage()));
                  }),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: Category(
                    icon: Icons.offline_bolt,
                    backgroundColor: Colors.orange,
                    title: AppTranslations.of(context).text("key_offers"),
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (_) => new Offers(prefs: prefs)));
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 15.0,
              ),
              Category(
                backgroundColor: Colors.teal,
                icon: Icons.local_hospital,
                title: AppTranslations.of(context).text("key_hospitals"),
              ),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: Category(
                    icon: Icons.accessibility_new,
                    backgroundColor: Colors.redAccent,
                    title: AppTranslations.of(context).text("key_gym"),
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (_) => Gym()));
                    _getCurrentLocation();
                  }),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: Category(
                    icon: Icons.menu,
                    backgroundColor: Colors.lightGreen,
                    title: AppTranslations.of(context).text("key_others"),
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
//                    Navigator.of(context)
//                        .push(new MaterialPageRoute(builder: (_) => Others()));
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Container(
        width: 250,
        child: Drawer(
          child: Container(
            padding: const EdgeInsets.only(left: 20.0, right: 10),
            decoration: BoxDecoration(
                color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.power_settings_new,
                          color: active,
                        ),
                        onPressed: () async {
                          prefs?.setBool("islogin", false);
                          prefs?.setString("email", "logout");
                          prefs?.setString("name", "logout");
                          prefs?.setString("url", "logout");
                          _gSignIn.signOut();
                          if (prefs.getBool('homeFirst') == true) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext ctx) => LoginScr(null)));
                          } else {
                            Navigator.pop(context, true);
                            Navigator.pop(context, true);
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [Colors.orange, Colors.deepOrange])),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/travel%2Fkathmandu2.jpg?alt=media'),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                     _name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                    _email,
                      style: TextStyle(color: active, fontSize: 16.0),
                    ),
                    SizedBox(height: 30.0),
                    GestureDetector(
                      child: _buildRow(Icons.location_city,
                          AppTranslations.of(context).text("key_lmp"), 1),
                      onTap: () {
                        Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder: (_) => new AboutPage()),
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
                            builder: (_) => new UserProfile(prefs: prefs),
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
                      onTap: () async {
                        _gSignIn.signOut();
                        prefs?.setBool("islogin", false);
                        prefs?.setString("email", "logout");
                        prefs?.setString("name", "logout");
                        prefs?.setString("url", "logout");
                        _gSignIn.signOut();
                        if (prefs.getBool('homeFirst') == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext ctx) => LoginScr(null)));
                        } else {
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                    _buildDivider(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _circularMenu() {
    return CircularMenu(
      alignment: Alignment.bottomRight,
      toggleButtonColor: Colors.pink,
      items: [
        CircularMenuItem(
            icon: Icons.home,
            color: Colors.green,
            onTap: () {
              setState(() {
                _color = Colors.green;
                _colorName = 'Green';
              });
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (_) => new Menu()));
            }),
        CircularMenuItem(
            icon: Icons.settings,
            color: Colors.orange,
            onTap: () {
              setState(() {
                _color = Colors.orange;
                _colorName = 'Orange';
              });
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (_) => new Setting(prefs: prefs)));
            }),
        CircularMenuItem(
            icon: Icons.notifications,
            color: Colors.brown,
            onTap: () {
              setState(() {
                _color = Colors.brown;
                _colorName = 'Brown';
              });
            })
      ],
    );
  }

  Widget _buildRow(IconData icon, String title, int navigation,
      {bool showBadge = false}) {
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
}

class Category extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;

  const Category(
      {Key key,
      @required this.icon,
      @required this.title,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.all(10.0),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(title, style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
