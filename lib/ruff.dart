//multiDexEnabled true
//org.gradle.jvmargs=-Xmx1536M
//
//android.useAndroidX=true
//android.enableJetifier=true
//android.enableR8=true

//subprojects {
//project.configurations.all {
//resolutionStrategy.eachDependency { details ->
//if (details.requested.group == 'com.android.support'
//&& !details.requested.name.contains('multidex') ) {
//details.useVersion "27.1.1"
//}
//if (details.requested.group == 'androidx.core'
//&& !details.requested.name.contains('androidx') ) {
//details.useVersion "1.0.1"
//}
//}
//}



//
//
//
//import 'package:http/http.dart' as http;
//import 'package:lakhimpur_kheri/screens/news/models/article.dart';
//import 'package:lakhimpur_kheri/screens/news/models/news_article.dart';
//import 'package:lakhimpur_kheri/screens/news/models/news_model.dart';
//import 'dart:convert';
//import 'package:lakhimpur_kheri/screens/news/secret.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' show Client;
//import 'dart:async';
//import '../models/news_model.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:uuid/uuid.dart';
//
//class NewsApiProvider2 {
//  Client client = Client();
//  final _prefs = SharedPreferences.getInstance();
//  String cntry = 'in';
//  String lang='en';
//  List<Article> newsCategoryAll  = [];
//  List<Article> newsCategoryJob  = [];
//  List<Article> newsCategoryEdu  = [];
//  List<Article> newsCategoryBus  = [];
//  List<Article> newsCategoryEnt  = [];
//  List<Article> newsCategoryGen  = [];
//  List<Article> newsCategoryHea  = [];
//  List<Article> newsCategorySci  = [];
//  List<Article> newsCategorySpo  = [];
//  List<Article> newsCategoryTec = [];
//  Future<void> getNews() async {
//    final SharedPreferences pref = await _prefs;
//    cntry = pref.getString('countryIsoCode');
//    lang = pref.getString('languageIsoCode');
////    http://newsapi.org/v2/everything?q=bitcoin&from=2020-04-30&sortBy=publishedAt&apiKey=429ac827df3e4e48a4bce86a0a4bf989
//    /*String url = "http://newsapi.org/v2/everything?q=$category&apiKey=${apiKey}";*/
//    String urlAll = "http://newsapi.org/v2/top-headlines?country=$cntry&language=$lang&apiKey=${apiKey}";
//    String urlJob = "http://newsapi.org/v2/everything?q=jobs&apiKey=${apiKey}";
//    String urlEdu = "http://newsapi.org/v2/everything?q=education&apiKey=${apiKey}";
//    String urlBusiness = "http://newsapi.org/v2/top-headlines?country=$cntry&category=business&apiKey=${apiKey}";
//    String urlEntertainment = "http://newsapi.org/v2/top-headlines?country=$cntry&category=entertainment&apiKey=${apiKey}";
//    String urlGeneral = "http://newsapi.org/v2/top-headlines?country=$cntry&category=general&apiKey=${apiKey}";
//    String urlHealth = "http://newsapi.org/v2/top-headlines?country=$cntry&category=health&apiKey=${apiKey}";
//    String urlScience = "http://newsapi.org/v2/top-headlines?country=$cntry&category=science&apiKey=${apiKey}";
//    String urlSports = "http://newsapi.org/v2/top-headlines?country=$cntry&category=sports&apiKey=${apiKey}";
//    String urlTechnology = "http://newsapi.org/v2/top-headlines?country=$cntry&category=technology&apiKey=${apiKey}";
//    var responseAll = await http.get(urlAll);
//    var responseJob = await http.get(urlJob);
//    var responseEdu = await http.get(urlEdu);
//    var responseBus = await http.get(urlBusiness);
//    var responseEnt = await http.get(urlEntertainment);
//    var responseGen = await http.get(urlGeneral);
//    var responseHea = await http.get(urlHealth);
//    var responseSci = await http.get(urlScience);
//    var responseSpo = await http.get(urlSports);
//    var responseTech = await http.get(urlTechnology);
//    var jsonAll = jsonDecode(responseAll.body);
//    var jsonJob = jsonDecode(responseJob.body);
//    var jsonEdu = jsonDecode(responseEdu.body);
//    var jsonBus = jsonDecode(responseBus.body);
//    var jsonEnt = jsonDecode(responseEnt.body);
//    var jsonGen = jsonDecode(responseGen.body);
//    var jsonHea = jsonDecode(responseHea.body);
//    var jsonSci = jsonDecode(responseSci.body);
//    var jsonSpo = jsonDecode(responseSpo.body);
//    var jsonTech = jsonDecode(responseTech.body);
//    if (jsonAll['status'] == "ok") {
//      jsonAll["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategoryAll.add(article);
//        }
//      });
//    }
//    if (jsonJob['status'] == "ok") {
//      jsonJob["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategoryJob.add(article);
//        }
//      });
//    }
//    if (jsonEdu['status'] == "ok") {
//      jsonEdu["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategoryEdu.add(article);
//        }
//      });
//    }
//    if (jsonBus['status'] == "ok") {
//      jsonBus["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategoryBus.add(article);
//        }
//      });
//    }
//    if (jsonEnt['status'] == "ok") {
//      jsonEnt["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategoryEnt.add(article);
//        }
//      });
//    }
//    if (jsonGen['status'] == "ok") {
//      jsonGen["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategoryGen.add(article);
//        }
//      });
//    }
//    if (jsonHea['status'] == "ok") {
//      jsonHea["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategoryHea.add(article);
//        }
//      });
//    }
//    if (jsonSci['status'] == "ok") {
//      jsonSci["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategorySci.add(article);
//        }
//      });
//    }
//    if (jsonSpo['status'] == "ok") {
//      jsonSpo["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategorySpo.add(article);
//        }
//      });
//    }
//    if (jsonTech['status'] == "ok") {
//      jsonTech["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategoryTec.add(article);
//        }
//      });
//    }
//  }
//  Future<void> getNews2() async {
//
//    String urlAll = "http://newsapi.org/v2/top-headlines?country=in&apiKey=${apiKey}";
//    var responseAll = await http.get(urlAll);
//    var jsonAll = jsonDecode(responseAll.body);
//    if (jsonAll['status'] == "ok") {
//      jsonAll["articles"].forEach((element) {
//        if (element['urlToImage'] != null &&
//            element['description'] != null) {
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          newsCategoryAll.add(article);
//        }
//      });
//    }}
//
//  Future<NewsModel> fetchNewsList() async {
//    String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=${apiKey}";
//    final response = await client.get(url);
//    if (response.statusCode == 200) {
//      return NewsModel.fromJson(json.decode(response.body));
//    } else {
//      throw Exception("Faild to post!");
//    }
//  }
//  Future<NewsModel> fetchSearchNews() async {
//    final SharedPreferences prefs = await _prefs;
//    String priorityTheme = prefs.getString("priorityTheme");
//    String url = "https://newsapi.org/v2/everything?q=$priorityTheme&apiKey=$apiKey";
//    final response = await client.get(url);
//    if (response.statusCode == 200) {
//      return NewsModel.fromJson(json.decode(response.body));
//    } else {
//      throw Exception("Faild to post!");
//    }
//  }
//
//  Future<NewsModel> getFavoriteNews() async {
//    final NewsModel nm = NewsModel();
//    List<Articles> list = List<Articles>();
//    var articles = await Firestore.instance
//        .collection("users")
//        .document(await getMyUID())
//        .get();
//    if (articles.data != null) {
//      for (int i = 0; i < articles.data.length; i++)
//        list.add(Articles.fromJson(articles.data.values.toList()[i]));
//    }
//    nm.articles = list;
//    return nm;
//  }
//
//  generateUID() async {
//    final myUID = Uuid().v4();
//    (await _prefs).setString('id', myUID);
//  }
//
//  getMyUID() async {
//    String uid = (await _prefs).getString('id');
//    return uid ?? generateUID();
//  }
//
//  addToFiresstore(val) async {
//    final String key =
//    val['url'].toString().replaceAll('/', '').replaceAll('.', '');
//    Firestore.instance
//        .collection('users')
//        .document(await getMyUID())
//        .setData({key: val}, merge: true);
//  }
//
//  deliteFromFirestore(val) async {
//    final String key =
//    val['url'].toString().replaceAll('/', '').replaceAll('.', '');
//    Firestore.instance
//        .collection('users')
//        .document(await getMyUID())
//        .updateData({key: FieldValue.delete()});
//  }
//}
//
//
//class NewsSearch {
//  List<Article> news  = [];
//  Future<void> getNews(String searchQuery) async{
//    String url = "https://newsapi.org/v2/everything?q=$searchQuery&sortBy=popularity'&apiKey=${apiKey}";
//    var response = await http.get(url);
//    var jsonData = jsonDecode(response.body);
//    if(jsonData['status'] == "ok"){
//      jsonData["articles"].forEach((element){
//        if(element['urlToImage'] != null && element['description'] != null){
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          news.add(article);
//        }
//      });
//    }
//  }
//}
//
//class NewsForKeyword {
//  List<Article> news  = [];
//  Future<void> getNewsForKeyword(String keyword) async{
//    String url = "https://newsapi.org/v2/everything?q=$keyword&apiKey=${apiKey}";
//    var response = await http.get(url);
//    var jsonData = jsonDecode(response.body);
//    if(jsonData['status'] == "ok"){
//      jsonData["articles"].forEach((element){
//        if(element['urlToImage'] != null && element['description'] != null){
//          Article article = Article(
//            title: element['title'],
//            author: element['author'],
//            description: element['description'],
//            urlToImage: element['urlToImage'],
//            publshedAt: DateTime.parse(element['publishedAt']),
//            content: element["content"],
//            articleUrl: element["url"],
//          );
//          news.add(article);
//        }
//
//      });
//    }
//
//
//  }
//
//
//}
//
//
//

//}