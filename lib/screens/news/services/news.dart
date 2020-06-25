import 'package:http/http.dart' as http;
import 'package:lakhimpur_kheri/login/authentication_bloc/authentication_bloc.dart';
import 'package:lakhimpur_kheri/login/user_repository.dart';
import 'package:lakhimpur_kheri/screens/news/models/news_model.dart';
import 'dart:convert';
import 'package:lakhimpur_kheri/screens/news/secret.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' show Client;
import 'dart:async';
import '../models/news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';
import 'package:lakhimpur_kheri/model/article.dart';

const base_url = 'https://newsapi.org/v2';
const api_key = '11cd66d3a6994c108e7fb7d92cee5e12';
const local_news_url = 'https://news.google.com/rss';

String getUrl(String country, String category) {
  var url = '$base_url/top-headlines?page=1';
  if (country != null && country.isNotEmpty) {
    url += '&country=$country';
  }
  if (category != null && category.isNotEmpty) {
    url += '&category=$category';
  }
  return url += '&apiKey=$api_key';
}

// Class from briefing to get google rss

class ApiService {

  static Future<List<Article>> getArticlesFromNetwork(country, category) async {
    var articles = [];
    try {
      final response = await http.get(getUrl(country, category));
      if (response.statusCode == 200) {
        articles = await compute(parseArticles, response.body);
      }
    } catch (e) {
      print('=== API::getArticlesFromNetwork Error ${e.toString()}');
    }
    return articles;
  }

  static Future<List<Article>> getLocalNewsFromNetwork() async {
    var articles = [];
    try {
      final response = await http.get(local_news_url);
      if (response.statusCode == 200) {
        articles = await compute(parseArticlesXml, response.body);
      }
    } catch (error) {
      print('=== API::LocalNewsFromNetwork::Error ${error.toString()}');
    }
    return articles;
  }
}

List<Article> parseArticles(String responseBody) {
  var articles = [];
  final parsed = json.decode(responseBody);
  if (parsed['totalResults'] > 0) {
    articles = List<Article>.from(parsed['articles']
        .map((article) => Article.fromMap(article, network: true)));
  }
  return articles;
}

List<Article> parseArticlesXml(String responseBody) {
  var document = xml.parse(responseBody);
  var channelElement = document.findAllElements("channel")?.first;
  var source = findElementOrNull(channelElement, 'title')?.text;
  return channelElement.findAllElements('item').map((element) {
    var title = findElementOrNull(element, 'title')?.text;
    var description = findElementOrNull(element, "description")?.text;
    var source2 = element.findElements("source").first.getAttribute('url');
    var link = findElementOrNull(element, "link")?.text;
//    var category =
//        element.findElements("category").first.getAttribute('domain');
    var pubDate = findElementOrNull(element, "pubDate")?.text;
    var author = findElementOrNull(element, "author")?.text;
    var image = findElementOrNull(element, "enclosure")?.getAttribute("url") ?? null;

    return Article(
        title: title,
        category: 'local',
        author: author,
        content: description,
        imageUrl: image,
        publishedAt: pubDate,
        url: link,
        source: source2?.replaceAll('https://www.', '') ?? '',
        description: description);
  }).toList();
}

XmlElement findElementOrNull(XmlElement element, String name) {
  try {
    return element.findAllElements(name).first;
  } on StateError {
    return null;
  }
}




class NewsApiProvider2 {
  UserRepository _userRepo;
  AuthenticationBloc _bloc;
  Client client = Client();
  final _prefs = SharedPreferences.getInstance();
  String cntry = 'in';
  String lang='en';
  List<Articles> list;
  List<Articles> list2;
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
  Future<NewsModel> getFavoriteNews(String uuid) async {
    final NewsModel nm = NewsModel();
    List<Articles> list = List<Articles>();
    var articles;
    String uuuid='KkgFUOIHYFfwd2PXWPL1ZRCLpwx2';
    try {
      articles = await Firestore.instance.collection('news')
          .document(uuuid)
          .get();
    }
    catch(e){
      debugPrint("exception is $uuid: $e");
    }
    if (articles.data != null) {
      for (int i = 0; i < articles.data.length; i++)
        list.add(Articles.fromJson(articles.data.values.toList()[i]));
      print(articles.data.length.runtimeType);
      debugPrint("::::::::::::::::::::::::::::::${articles.data.length}");
    }
    nm.articles = list;
    list2=list;
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

  addToFiresstore(val,{String uuid}) async {
    final String key = val['url'].toString().replaceAll('/', '').replaceAll('.', '');
    try {
      debugPrint("addToFiresstore try block uuid is $uuid");
      // mca.saboor uuid is: KkgFUOIHYFfwd2PXWPL1ZRCLpwx2
      Firestore.instance
          .collection('news')
          .document(uuid)
          .setData({key: val}, merge: true);
    }
    catch(e){
      debugPrint("exception addToFiresstore is: $e");
    }
    debugPrint("value is :  $val");
  }
  deliteFromFirestore(val) async {
    final String key =
    val['url'].toString().replaceAll('/', '').replaceAll('.', '');
    Firestore.instance
        .collection('news')
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


