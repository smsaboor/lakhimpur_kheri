import 'dart:async';
import 'package:lakhimpur_kheri/screens/news/helper/news.dart';
import '../models/news_model.dart';

class Repository {
  final newsApiProvider = NewsApiProvider2();
  // Get news from server
  Future<NewsModel> fetchAllNews() => newsApiProvider.fetchNewsList();
  // Get news from server
  Future<NewsModel> fetchSearchNews() => newsApiProvider.fetchSearchNews();
  // Get favorite news from firebase
  Future<NewsModel> fetchLikedNews() => newsApiProvider.getFavoriteNews();
  addFavorit(val) => newsApiProvider.addToFiresstore(val);
  deliteFavorit(val) => newsApiProvider.deliteFromFirestore(val);
}
