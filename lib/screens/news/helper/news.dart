import 'package:http/http.dart' as http;
import 'package:lakhimpur_kheri/screens/news/models/article.dart';
import 'package:lakhimpur_kheri/screens/news/models/news_model.dart';
import 'dart:convert';
import 'package:lakhimpur_kheri/screens/news/secret.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' show Client;
import 'dart:async';
import '../models/news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NewsApiProvider2 {
  Client client = Client();
  final _prefs = SharedPreferences.getInstance();
  String cntry = 'in';
  String lang='en';
  List<Articles> list;
 var newsAllCategory;
  Future<void> getNews(String url) async {
    final SharedPreferences pref = await _prefs;
    cntry = pref.getString('countryIsoCode');
    lang = pref.getString('languageIsoCode');
//    http://newsapi.org/v2/everything?q=bitcoin&from=2020-04-30&sortBy=publishedAt&apiKey=429ac827df3e4e48a4bce86a0a4bf989
    /*String url = "http://newsapi.org/v2/everything?q=$category&apiKey=${apiKey}";*/
    var response = await http.get(Uri.encodeFull(url),headers: {"Accept": "application/json"});
    print(response.body);
    if (response.statusCode == 200) {
      var data=json.decode(response.body);
      var rest=data["articles"] as List;
      print(rest);
      list = rest.map<Articles>((json) => Articles.fromJson(json)).toList();
    } else {
      throw Exception("Faild to post!");
    }
    return list;
  }
  Future<void> getNews2() async {
    String url = "http://newsapi.org/v2/top-headlines?country=in&apiKey=${apiKey}";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data=json.decode(response.body);
      var rest=data["articles"] as List;
      print(rest);
      list = rest.map<Articles>((json) => Articles.fromJson(json)).toList();
    } else {
      throw Exception("Faild to post!");
    }
    return list;
    }

  Future<NewsModel> fetchNewsList() async {
    String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=${apiKey}";
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Faild to post!");
    }
  }
  Future<NewsModel> fetchSearchNews() async {
    final SharedPreferences prefs = await _prefs;
    String priorityTheme = prefs.getString("priorityTheme");
    String url = "https://newsapi.org/v2/everything?q=$priorityTheme&apiKey=$apiKey";
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Faild to post!");
    }
  }

  Future<NewsModel> getFavoriteNews() async {
    final NewsModel nm = NewsModel();
    List<NewsModel> list = List<NewsModel>();
    var articles = await Firestore.instance
        .collection("users")
        .document(await getMyUID())
        .get();
    if (articles.data != null) {
      for (int i = 0; i < articles.data.length; i++)
        list.add(NewsModel.fromJson(articles.data.values.toList()[i]));
    }
//    nm.articles = list;
    return nm;
  }

  generateUID() async {
    final myUID = Uuid().v4();
    (await _prefs).setString('id', myUID);
  }

  getMyUID() async {
    String uid = (await _prefs).getString('id');
    return uid ?? generateUID();
  }

  addToFiresstore(val) async {
    final String key =
    val['url'].toString().replaceAll('/', '').replaceAll('.', '');
    Firestore.instance
        .collection('users')
        .document(await getMyUID())
        .setData({key: val}, merge: true);
  }

  deliteFromFirestore(val) async {
    final String key =
    val['url'].toString().replaceAll('/', '').replaceAll('.', '');
    Firestore.instance
        .collection('users')
        .document(await getMyUID())
        .updateData({key: FieldValue.delete()});
  }
}


class NewsSearch {
  List<NewsModel> news  = [];
  Future<void> getNews(String searchQuery) async{
    String url = "https://newsapi.org/v2/everything?q=$searchQuery&sortBy=popularity'&apiKey=${apiKey}";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      news.add(NewsModel.fromJson(json.decode(response.body)));
    } else {
      throw Exception("Faild to post!");
    }
    return news;
  }
}

class NewsForKeyword {
  List<NewsModel> news  = [];
  Future<void> getNewsForKeyword(String keyword) async{
    String url = "https://newsapi.org/v2/everything?q=$keyword&apiKey=${apiKey}";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      news.add(NewsModel.fromJson(json.decode(response.body)));
    } else {
      throw Exception("Faild to post!");
    }
    return news;
  }


}


