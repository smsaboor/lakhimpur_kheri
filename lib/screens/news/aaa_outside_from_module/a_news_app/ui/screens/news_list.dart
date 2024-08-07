import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/a_news_app/blocs/news_bloc.dart';
import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/a_news_app/ui/views/search_bar.dart';
import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/a_news_app/ui/views/stream_builder.dart';
import 'package:flutter/material.dart';



class NewsList extends StatefulWidget {

  @override
  createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  ScrollController scrollControllerNewsList;
  @override
  void initState() {
    setState(() {});
    scrollControllerNewsList = ScrollController(initialScrollOffset: 84);
    super.initState();
  }

  @override
  void dispose() {
    scrollControllerNewsList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllNews();
    setState(() {});
    return SafeArea(
      child: CustomScrollView(
        controller: scrollControllerNewsList,
        slivers: <Widget>[
//          buildSearchBar(context), // Serach
          streamBuilder(bloc.allNews),
        ],
      ),
    );
  }
}