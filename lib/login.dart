import 'package:flutter/material.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/mtmain.dart';
import 'package:lakhimpur_kheri/screens/homePage/HomePage2.dart';
import 'package:lakhimpur_kheri/user_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/Model/theme_model.dart';


class LoginScr extends StatefulWidget {
  ThemeModel model;
  LoginScr(this.model);
//  LoginScreen(this.logoutStatus);
  @override
  State<StatefulWidget> createState() {
    return _LoginScrState(this.model);
  }
}
class _LoginScrState extends State<LoginScr> {
  ThemeModel model;
  _LoginScrState(this.model);
  SharedPreferences prefs;
  bool checkValue = false;
  UserDetails detailsUserSave;

//Firebase Implementation----------------------------------------------------------------
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser userDetails = await _firebaseAuth.signInWithCredential(credential);
    ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);
    List<ProviderDetails> providerData = new List<ProviderDetails>();
    providerData.add(providerInfo);
    UserDetails details = new UserDetails(
      userDetails.providerId,
      userDetails.displayName,
      userDetails.photoUrl,
      userDetails.email,
      providerData,
    );
      prefs?.setBool("islogin", true);
      prefs?.setString("email", details.userEmail);
      prefs?.setString("name", details.userName);
      prefs?.setString("url", details.photoUrl);

    detailsUserSave=details;
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new MainUI(this.model,prefs: prefs),
//        builder: (context) => new ProfileScreen(detailsUser: details),
      ),
    );
    return userDetails;
  }


  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();





  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body(){
    return new ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            ClipPath(
              child: Container(
                child: Column(),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0x22ff3a5a), Color(0x22fe494d)])),
              ),
            ),
            ClipPath(
              child: Container(
                child: Column(),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
              ),
            ),
            ClipPath(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Lakhimpur Kheri",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 30),
                    ),
                  ],
                ),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xffff3a5a), Color(0xfffe494d)])),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Material(
            elevation: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: TextField(
              controller: _controller1,
              onChanged: (String value) {},
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Material(
                    elevation: 0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Material(
            elevation: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: TextField(
              controller: _controller2,
              obscureText: true,
              onChanged: (String value) {},
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Material(
                    elevation: 0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Icon(
                      Icons.lock,
                      color: Colors.blue,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color(0xffff3a5a)),
              child: FlatButton(
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
                onPressed: () {
                  prefs?.setBool("islogin", true);
                  prefs?.setString("email", 'ASIS');
                  prefs?.setString("name", 'ASIS');
                  prefs?.setString("url", 'ASIS');
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new MainUI(this.model,prefs: prefs),
//        builder: (context) => new ProfileScreen(detailsUser: details),
                    ),
                  );
                },
              ),
            )),
        SizedBox(height: 5,),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color(0xffff5d5f)),
              child: FlatButton.icon(
                  icon: Icon(FontAwesomeIcons.google, color: Colors.white,),
                  label: Text("Sign In", style: TextStyle(color: Colors.white),),
                  onPressed: () async{
                    _signIn()
                        .then((FirebaseUser user) {
                      print(user);
                    })
                        .catchError((e) => print('saboor: $e'));

                  }
              ),
            )),
        SizedBox(height: 10,),
        Center(
          child: Text("FORGOT PASSWORD ?", style: TextStyle(
              color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w700),),
        ),
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Don't have an Account ? ", style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.normal),),
            GestureDetector(
              onTap: () {
                navigateToRegistration();
              },
              child: Text("Sign Up ", style: TextStyle(color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  decoration: TextDecoration.underline)),
            )
          ],
        )
      ],
    );
  }



  void navigateToRegistration() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UserRegistration();
    }));
  }

}

class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails,this.userName, this.photoUrl,this.userEmail, this.providerData);
}


class ProviderDetails {
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}