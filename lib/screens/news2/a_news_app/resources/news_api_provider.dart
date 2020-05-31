import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NewsApiProvider {
  Client client = Client();
  final _prefs = SharedPreferences.getInstance();
  String cntry = 'in';
  final _apiKey = '429ac827df3e4e48a4bce86a0a4bf989';
  // Chech shared preference, push requset to newsapi.org server and parse to model
  Future<NewsModel> fetchNewsList() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String country = (sharedPrefs.getString('countryIsoCode') ?? 'in');
    String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=$_apiKey";
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Faild to post!");
    }
  }
  Future<NewsModel> fetchNewsBussiness() async {
    String url = "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=$_apiKey";
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Faild to post!");
    }
  }
  Future<NewsModel> fetchNewsSports() async {
    String url = "https://newsapi.org/v2/top-headlines?country=in&category=sports&apiKey=$_apiKey";
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
    String url = "https://newsapi.org/v2/everything?q=$priorityTheme&apiKey=$_apiKey";
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Faild to post!");
    }
  }

  Future<NewsModel> getFavoriteNews() async {
    final NewsModel nm = NewsModel();
    List<Articles> list = List<Articles>();
    var articles = await Firestore.instance
        .collection("users")
        .document(await getMyUID())
        .get();
    if (articles.data != null) {
      for (int i = 0; i < articles.data.length; i++)
        list.add(Articles.fromJson(articles.data.values.toList()[i]));
    }
    nm.articles = list;
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

  deleteFromFirestore(val) async {
    final String key =
        val['url'].toString().replaceAll('/', '').replaceAll('.', '');
    Firestore.instance
        .collection('users')
        .document(await getMyUID())
        .updateData({key: FieldValue.delete()});
  }
}
