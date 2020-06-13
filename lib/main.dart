//taskkill /F /IM dart.exe
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lakhimpur_kheri/screens/homePage/HomePage2.dart';
//import 'package:lakhimpur_kheri/login.dart';
//import 'package:lakhimpur_kheri/splash.dart';
import 'package:lakhimpur_kheri/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lakhimpur_kheri/localisation/localization_two/app_translations_delegate.dart';
import 'package:lakhimpur_kheri/localisation/localization_two/application.dart';
//"taskkill /F /IM dart.exe"    //on terminal paste and enter
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/Constants/constants.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/Model/theme_model.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/UI/Widgets/splash_screen.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/mtmain.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/UI/settings.dart';
import 'package:provider/provider.dart';


//save all 5/3/2020


//
//void main() {
//  WidgetsFlutterBinding.ensureInitialized();
//  BlocSupervisor.delegate = SimpleBlocDelegate();
//  final UserRepository userRepository = UserRepository();
//  runApp(
//    BlocProvider(
//      create: (context) => AuthenticationBloc(
//        userRepository: userRepository,
//      )..add(AppStarted()),
//      child: MyApp(userRepository: userRepository),
//    ),
//  );
//}
//
//class MyApp extends StatelessWidget {
//  final UserRepository _userRepository;
//
//  MyApp({Key key, @required UserRepository userRepository})
//      : assert(userRepository != null),
//        _userRepository = userRepository,
//        super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//        builder: (context, state) {
//          if (state is Unauthenticated) {
//            return LoginScreen(userRepository: _userRepository);
//          }
//          if (state is Authenticated) {
//            return HomeScreen(name: state.displayName);
//          }
//          return SplashScreen();
//        },
//      ),
//    );
//  }
//}

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      color: Colors.green,
      child: Text(
        details.toString(),
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
        ),
      ),
    );
  };
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
        MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeModel>(
                create: (_) => ThemeModel(),
              ),
            ],
            child: MtMyApp(),
        ));
}

class MtMyApp extends StatelessWidget {
  MtMyApp();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider<ThemeModel>(
        create: (BuildContext context) => ThemeModel(),
        child: Consumer<ThemeModel>(builder: (context, model, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(),
            theme: ThemeData(
              dividerColor: model.dividerColor,
              textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: model.textColor,
                  displayColor: model.textColor),
              appBarTheme: AppBarTheme(color: model.appbarcolor),
              primaryColor: model.primaryMainColor,
              accentColor: model.accentColor,
            ),
            title: 'Flutter Multi Theme',
            home: SplashScr(model),
          );
        }));
  }
}

//class MyApp extends StatelessWidget {
//  ThemeModel model;
//  final SharedPreferences prefs;
//  MyApp(this.model,{this.prefs});
//  @override
//  Widget build(BuildContext context) {
//    debugPrint("My App Widget build(BuildContext context)"
//               "name:${prefs.getString('name')}\n  "
//               "email:${prefs.getString('email')}\n"
//                "islogin:${prefs.getBool('islogin')}\n"
//                "homeFirst:${prefs.getBool('homeFirst')}\n"
//                 "url:${prefs.getString('url')}");
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: "Lakhimpur-Kheri",
//      theme: ThemeData(
//        primarySwatch: Colors.indigo,
//      ),
//      home: SplashScr(prefs:prefs),
//    );
//  }
//}
