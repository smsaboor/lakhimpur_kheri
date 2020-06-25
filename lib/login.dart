import 'package:flutter/material.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/mtmain.dart';
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
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    String authid=googleAuth.idToken;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser userDetails =
        (await _firebaseAuth.signInWithCredential(credential)).user;
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
    debugPrint("User Login credential ........... ${userDetails.providerId}");
    debugPrint("User Login credential ........... ${userDetails.displayName}");
    debugPrint("User Login credential ........... ${userDetails.photoUrl}");
    debugPrint("User Login credential ........... ${userDetails.email}");
    debugPrint("User Login credential ........... $authid");
    prefs?.setBool("islogin", true);
    prefs?.setString("email", details.userEmail);
    prefs?.setString("name", details.userName);
    prefs?.setString("url", details.photoUrl);
    prefs?.setString("uid", details.providerDetails);

    detailsUserSave = details;
    getCurrentUser();
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new MainUI(this.model, prefs: prefs),
//        builder: (context) => new ProfileScreen(detailsUser: details),
      ),
    );
    return userDetails;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  getCurrentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    // Similarly we can get email as well
    //final uemail = user.email;
    print(uid);
    //print(uemail);
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

  Widget _body() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/image1.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter)),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 270),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(23),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Container(
                    color: Color(0xfff5f5f5),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person_outline),
                          labelStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        labelStyle: TextStyle(fontSize: 15)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () {
                      prefs?.setBool("islogin", true);
                      prefs?.setString("email", 'ASIS');
                      prefs?.setString("name", 'ASIS');
                      prefs?.setString("url", 'ASIS');
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) =>
                              new MainUI(this.model, prefs: prefs),
                        ),
                      );
                    },
                    //since this is only a UI app
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Color(0xffff2d55),
                    elevation: 0,
                    minWidth: 400,
                    height: 50,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: MaterialButton(
                        onPressed: () {},
                        //since this is only a UI app
                        child: Text(
                          'Facebook Login',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Colors.blue,
                        elevation: 0,
                        minWidth: 180,
                        height: 50,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: MaterialButton(
                        onPressed: () async {
                          _signIn().then((FirebaseUser user) {
                            print(user);
                          }).catchError((e) => print('saboor: $e'));
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.google),
                            Text(
                              ' SignIn',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        color: Colors.amber,
                        elevation: 0,
                        minWidth: 180,
                        height: 50,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Forgot your password?',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: GestureDetector(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Don't have an account?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                          TextSpan(
                              text: "sign up",
                              style: TextStyle(
                                color: Color(0xffff2d55),
                                fontSize: 15,
                              ))
                        ]),
                      ),
                      onTap: () {
                        navigateToRegistration();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
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

  UserDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);

  final String providerDetails;
}
