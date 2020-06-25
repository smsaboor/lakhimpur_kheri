import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/a_news_app/blocs/news_bloc.dart';
import 'package:lakhimpur_kheri/screens/news/aaa_outside_from_module/a_news_app/ui/views/stream_builder.dart';
import 'package:flutter/material.dart';



class LikedList extends StatefulWidget {
  @override
  createState() => LikedListState();
}

class LikedListState extends State<LikedList> {
  ScrollController scrollControllerLikedList;
  @override
  void initState() {
    scrollControllerLikedList = ScrollController(initialScrollOffset: 84);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchLikedNews();
    return SafeArea(
      child: CustomScrollView(
        controller: scrollControllerLikedList,
        slivers: <Widget>[
          streamBuilder(bloc.likeNews),
        ],
      ),
    );
  }
}