//import 'dart:convert';
//
//import 'package:flutter/widgets.dart';
//import 'package:lakhimpur_kheri/screens/news/database/dbhelper.dart';
//import 'package:lakhimpur_kheri/screens/news/models/news_article.dart';
//import 'package:http/http.dart' as http;
//import 'package:lakhimpur_kheri/screens/news/secret_key.dart';
//import 'package:lakhimpur_kheri/screens/news/services/internet-service.dart';
//import 'package:rxdart/subjects.dart';
//
//// Utility to track the progress of News Articles
//enum NewsLoadState { Loading, Loaded, Vacant }
//
///// `NewsService` will act as a utility class and perform all
///// operations related to the NewsArticles.
//class NewsService extends ChangeNotifier {
//  /// Stores the master list of `NewsArticle` instances
//  List<NewsArticle> _articlesList = [];
//
//  /// Getter for the news articles list
//  List<NewsArticle> get articles {
//    return _articlesList;
//  }
//
//  /// Stores the master list of `NewsArticle` instances which are bookmarked
//  List<NewsArticle> _bookmarkedArticlesList = [];
//
//  /// Getter for the news articles list
//  List<NewsArticle> get bookmarks {
//    return _bookmarkedArticlesList;
//  }
//
//  /// To enable listening to changes of `NewsLoadState`
//  PublishSubject<NewsLoadState> _newsLoadStateSubject = PublishSubject();
//
//  /// Getter for `NewsLoadState` PublishSubject
//  PublishSubject<NewsLoadState> get newsLoadState {
//    return _newsLoadStateSubject;
//  }
//
//  /// Instance of Database Helper class
//  var _dbhelper = DBHelper();
//
//  /// Fetch news articles from NewsApi.org, optionally accepts
//  /// the request query params.
//  Future getArticlesFromApi(
//      {String country = 'in', String query = '', String category = ''}) async {
//    String baseUrl = 'https://newsapi.org/v2/top-headlines';
//
//    String requestParams = '?apiKey=${SecretKey.apiKey}' +
//        '&country=$country' +
//        '&q=$query' +
//        '&category=$category';
//
//    // Update NewsLoadState to Loading
//    _newsLoadStateSubject.add(NewsLoadState.Loading);
//
//    try {
//      http.Response apiResponse = await http.get(baseUrl + requestParams);
//
//      if (apiResponse.statusCode != 200) {
//        updateNewsLoadState();
//      } else {
//        // Decode response body from json to map
//        var decodedJsonMap = json.decode(apiResponse.body);
//
//        // get the articles list
//        List decodedArticlesList = decodedJsonMap['articles'];
//
//        // if there is atleast one article, then add
//        // the list to db
//        if (decodedArticlesList.length > 0)
//          await addArticlesToDb(decodedArticlesList);
//        else {
//          updateNewsLoadState();
//        }
//      }
//    } catch (exception) {
//      print(exception);
//    }
//  }
//
//  /// Add articles to database
//  Future addArticlesToDb(List articles) async {
//    // Iterate through the list of articles and
//    // add each article to db.
//    articles.forEach((article) async {
//      // Check if the article already exists
//      bool isPresent = await _dbhelper.findMatchingArticle(article['url']);
//
//      if (!isPresent) {
//        Map<String, dynamic> articleToSave = Map.from(article);
//        articleToSave.remove('source');
//        articleToSave['sourceId'] = article['source']['id'] ?? '';
//        articleToSave['sourceName'] = article['source']['name'];
//        articleToSave['isBookmarked'] = false;
//
//        if (articleToSave['content'] != null ||
//            articleToSave['description'] != null)
//          // Add article to Database
//          await _dbhelper.saveArticle(articleToSave);
//      }
//    });
//  }
//
//  /// Fetch the cached articles from database
//  Future getArticlesFromDb({bool toRefresh = false, String countryCode}) async {
//    // Update NewsLoadState
//    _newsLoadStateSubject.add(NewsLoadState.Loading);
//
//    // Get articles from db
//    List<NewsArticle> cachedArticles = await _dbhelper.getArticles();
//
//    // If to refresh is selected then articles must be fetched again,
//    // after truncating the table.
//    if (toRefresh && countryCode != null) {
//      bool internetPresent = await checkForInternet();
//
//      if (internetPresent) {
//        await _dbhelper.truncateTable();
//        await getArticlesFromApi(country: countryCode);
//        await getArticlesFromDb(toRefresh: false);
//      } else {
//        // Store cached articles in master list if internet not present.
//        _articlesList = cachedArticles.reversed.toList();
//        updateNewsLoadState();
//      }
//    } else {
//      if (cachedArticles.length > 0) {
//        // Reversed to get the latest first
//        _articlesList = cachedArticles.reversed.toList();
//        updateNewsLoadState();
//      } else {
//        // Fetch articles if not present in database
//        await getArticlesFromApi(country: countryCode);
//        await getArticlesFromDb(toRefresh: false);
//      }
//    }
//  }
//
//  /// Update the bookmark status of a NewsArticle
//  Future updateArticleBookmark({}) async {
//    await _dbhelper.updateArticle(toBookmark: toBookmark, url: url);
//
//    NewsArticle newsArticle;
//
//    _articlesList.forEach((article) {
//      if (article.url == url) {
//        article.isBookmarked = toBookmark;
//        newsArticle = article;
//      }
//    });
//
//    if (toBookmark) {
//      _bookmarkedArticlesList.add(newsArticle);
//    } else {
//      _bookmarkedArticlesList.remove(newsArticle);
//    }
//
//    notifyListeners();
//  }
//
//  /// Fetch Bookmarked articles from DB
//  Future getBookmarkedArticles() async {
//    List<NewsArticle> bookmarkedArticles = [];
//
//    bookmarkedArticles = await _dbhelper.getBookmarkedArticles();
//
//    _bookmarkedArticlesList = bookmarkedArticles;
//    notifyListeners();
//  }
//
//  /// Get a specific NewsArticle, useful for the UI response
//  /// while updating the bookmark state of the article
//  Future<NewsArticle> getSingleArticle(String url) async {
//    NewsArticle newsArticle = await _dbhelper.getSingleArticle(url);
//    return newsArticle;
//  }
//
//  /// Update NewsLoadState as per the availability of articles
//  void updateNewsLoadState() {
//    if (_articlesList.length > 0) {
//      _newsLoadStateSubject.add(NewsLoadState.Loaded);
//    } else {
//      _newsLoadStateSubject.add(NewsLoadState.Vacant);
//    }
//  }
//}
