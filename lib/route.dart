import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/mtmain.dart';
import 'package:lakhimpur_kheri/screens/homePage/HomePage2.dart';
import 'package:lakhimpur_kheri/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lakhimpur_kheri/localisation/localization_two/app_translations_delegate.dart';
import 'package:lakhimpur_kheri/localisation/localization_two/application.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/Model/theme_model.dart';
class RoutePage extends StatefulWidget {
  ThemeModel model;
  final  SharedPreferences prefs;
  RoutePage(this.model,{this.prefs});
  @override
  State<StatefulWidget> createState() {
    return  _RoutePageState(this.model,prefs:prefs);
  }
}
class _RoutePageState extends State<RoutePage> {
  ThemeModel model;
  SharedPreferences prefs;
  AppTranslationsDelegate _newLocaleDelegate;
  _RoutePageState(this.model,{this.prefs});

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }
  @override
  Widget build(BuildContext context) {
    if(prefs.getBool('islogin') != null){
              if(prefs.getBool('islogin') == true){
                prefs?.setBool("homeFirst", true);
                      return MaterialApp(
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
                        debugShowCheckedModeBanner: false,
                        localizationsDelegates: [
                          _newLocaleDelegate,
                          //provides localised strings
                          GlobalMaterialLocalizations.delegate,
                          //provides RTL support
                          GlobalWidgetsLocalizations.delegate,
                        ],
                        supportedLocales: [
                          const Locale("en", ""),
                          const Locale("es", ""),
                        ],
                        home: MainUI(this.model,prefs: prefs),
                      );
                    }
              else{
                prefs?.setBool("homeFirst", false);
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: [
                    _newLocaleDelegate,
                    //provides localised strings
                    GlobalMaterialLocalizations.delegate,
                    //provides RTL support
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: [
                    const Locale("en", ""),
                    const Locale("es", ""),
                  ],
                  home:LoginScr(model),
                );
              }
    }
    else{
      prefs?.setBool("homeFirst", false);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          _newLocaleDelegate,
          //provides localised strings
          GlobalMaterialLocalizations.delegate,
          //provides RTL support
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale("en", ""),
          const Locale("es", ""),
        ],
        home:LoginScr(model),
      );
    }
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}