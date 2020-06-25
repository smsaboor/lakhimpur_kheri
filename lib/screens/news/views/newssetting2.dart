import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:lakhimpur_kheri/screens/news/views/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:lakhimpur_kheri/utils/zCountryPicker/country.dart';
import 'package:lakhimpur_kheri/utils/zCountryPicker/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:lakhimpur_kheri/utils/zLanguagePicker/languages.dart';
import 'package:lakhimpur_kheri/utils/zLanguagePicker/language_pickers.dart';
ScrollController scrollControllerSettings;

class SettingsScreen extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsScreen> {
  bool swBrowser = false;
  bool swTheme = false;
  String country = '';
  Color _local = Color(0x000);
  String _countryIsoCodeSP = 'in';
  String _languageIsoCodeSP = 'hi';
  bool initData;
  bool _notificationNews = true;
  bool _notificationOffers = true;
  @override
  void initState() {
    scrollControllerSettings = ScrollController(initialScrollOffset: 84);
    initStateCustome().then((_) {
      setState((){});
    });
    super.initState();
    restore();
  }
  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _countryIsoCodeSP = (sharedPrefs.getString('countryIsoCode') ?? 'IN');
      _languageIsoCodeSP = (sharedPrefs.getString('languageIsoCode') ?? 'hi');
      _notificationNews = (sharedPrefs.getBool('notNews') ?? false);
      _notificationOffers = (sharedPrefs.getBool('notOffers') ?? false);
     });
  }

  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }
  @override
  void dispose() {
    scrollControllerSettings.dispose();
    super.dispose();
  }

  // Init state logic
  Future initStateCustome() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    swBrowser = sharedPrefs.getBool('browser');
    _local = Color(sharedPrefs.getInt('color') ?? 0xFF26A69A);
    initData = true;
  }

  @override

  Widget build(BuildContext context) {
    if (initData == false || initData == null) {
      return LinearProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: title("News", "Setting"),
          ),),
      body:SafeArea(
      child: SingleChildScrollView(
        controller: scrollControllerSettings,
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () => changeTheme(!swTheme),
              title: Text('Dark theme'),
              subtitle: Text('Enable dark theme throughout the app'),
              trailing: Switch(
                activeColor: Theme.of(context).accentColor,
                onChanged: (bool value) => changeTheme(value),
                value: Theme.of(context).brightness == Brightness.dark
                    ? swTheme = true
                    : swTheme = false,
              ),
            ),
            Divider(), // Divider
            ListTile(
              title: Text('Select Country for News'),
              subtitle:  Text(CountryPickerUtils.getCountryByIsoCode(_countryIsoCodeSP).name),
              trailing: IconButton(
                icon: Image.asset(
                    CountryPickerUtils.getFlagImageAssetPath(_countryIsoCodeSP)),
                onPressed: () {
                  _openCountryPickerDialog();
                },
              ),
              onTap: () =>  _openCountryPickerDialog(),
            ),
            Divider(),
            ListTile(
              title: Text('Select Language for News'),
              subtitle: Text(LanguagePickerUtils.getLanguageByIsoCode(_languageIsoCodeSP).name),
              trailing: Icon(Icons.language),
              onTap: () {
                _openLanguagePickerDialog();
                //open change language
              },
            ),
            Divider(),// Divider
            ListTile(
              title: Text('Primary color'),
              trailing: Container(
                child: CircleColor(
                  color: _local,
                  circleSize: 50,
                ),
              ),
              onTap: () => changePrimaryColor(),
            ),
            Divider(), // Divider
            ListTile(
              onTap: () => changeBrowser(!swBrowser),
              title: Text('Open in browser'),
              subtitle: Text('To work more efficiently'),
              trailing: Switch(
                value: swBrowser,
                activeColor: Theme.of(context).accentColor,
                onChanged: (bool value) => changeBrowser(value),
              ),
            ),
            Divider(),
            new SwitchListTile(
              activeColor: Colors.redAccent,
              title: const Text('Notifications News'),
              value: _notificationNews,
              onChanged: (bool value) {
                setState(() {
                  _notificationNews = value;
                });
                save('notNews', value);
              },
              secondary: const Icon(
                Icons.notifications,
                color: Colors.redAccent,
              ),
            ),
            Divider(),
            new SwitchListTile(
              activeColor: Colors.redAccent,
              title: const Text('Notifications Offers'),
              value: _notificationOffers,
              onChanged: (bool value) {
                setState(() {
                  _notificationOffers = value;
                });
                save('notOffers', value);
              },
              secondary: const Icon(
                Icons.notifications,
                color: Colors.redAccent,
              ),
            ),// Divider
          ],
        ),
      ),),
    );
  }

  // Theme Logic
  changeTheme(value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    DynamicTheme.of(context).setThemeData(ThemeData(
        accentColor: Theme.of(context).accentColor,
        brightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark));
    setState(() {
      swTheme = value;
    });
    await sharedPrefs.setString('theme', swTheme ? 'dark' : 'light');
  }

  // Change Coloro L
  changePrimaryColor() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    Color local = Color(sharedPrefs.getInt('color') ?? 0xFF26A69A);
    showDialog(
        context: context,
        child: SimpleDialog(
          title: Text('Primary color', style: TextStyle(fontSize: 24)),
          children: <Widget>[
            MaterialColorPicker(
                selectedColor: local,
                onColorChange: (Color color) {
                  local = color;
                },
                colors: [
                  Colors.red,
                  Colors.pink,
                  Colors.purple,
                  Colors.deepPurple,
                  Colors.indigo,
                  Colors.blue,
                  Colors.lightBlue,
                  Colors.cyan,
                  Colors.teal,
                  Colors.green,
                  Colors.lightGreen,
                  Colors.lime,
                  Colors.yellow,
                  Colors.amber,
                  Colors.orange,
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("Cancel")),
                FlatButton(
                    onPressed: () async {
                      DynamicTheme.of(context).setThemeData(ThemeData(
                          accentColor: local,
                          brightness: Theme.of(context).brightness));
                      await sharedPrefs.setInt('color', local.value);
                      Navigator.pop(context, false);
                    },
                    child: Text("Confirm"))
              ],
            ),
          ],
        ));
  }

  changeBrowser(bool value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool('browser', value);
    setState(() {
      swBrowser = value;
    });
  }

  Widget _buildDialogItem(Country country) => Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      SizedBox(width: 12.0),
      Flexible(child: Text(country.name))
    ],
  );

  void _openCountryPickerDialog() => showDialog(
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

  void _openLanguagePickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: LanguagePickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your language'),
            onValuePicked: (Language language) {
              setState(() {
                _languageIsoCodeSP = language.isoCode;
              });
              save('languageIsoCode', language.isoCode);
            }
            )
    ),
  );
}

