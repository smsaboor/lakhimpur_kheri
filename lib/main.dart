import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lakhimpur_kheri/login/authentication_bloc/authentication_bloc.dart';
import 'package:lakhimpur_kheri/login/user_repository.dart';
import 'package:lakhimpur_kheri/login/login/login.dart';
import 'package:lakhimpur_kheri/login/splash_screen.dart';
import 'package:lakhimpur_kheri/login/simple_bloc_delegate.dart';
import 'package:lakhimpur_kheri/route.dart';
import 'package:provider/provider.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/Model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:lakhimpur_kheri/splash.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AuthenticationStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return LoginScreen(userRepository: _userRepository);
          }
          if (state is AuthenticationSuccess) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<ThemeModel>(
                  create: (_) => ThemeModel(),
                ),
              ],
              child: MtMyApp(state.displayName),
            );
          }
          return SplashScreen();
        },
      ),
    );
  }
}
//HomeScreen(name: state.displayName);

class MtMyApp extends StatefulWidget {
  final uuid;
  MtMyApp(this.uuid);
  @override
  _MtMyAppState createState() => _MtMyAppState(uuid);
}
class _MtMyAppState extends State<MtMyApp> {
  SharedPreferences prefs;
  final uuid;
  _MtMyAppState(this.uuid);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restore();
    restore2();
  }
  restore2() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String uuuuid= await sharedPrefs.getString('uuId') ?? 'null';
    debugPrint("uuuuid is:$uuuuid");
  }

  restore()async{
     final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      debugPrint("uuId is:$uuid");
      await sharedPrefs?.setString("uuId", uuid);
  }
  @override
  Widget build(BuildContext context) {
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