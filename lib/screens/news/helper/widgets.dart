import 'package:flutter/material.dart';
import 'package:lakhimpur_kheri/screens/news/top_ten_news/newsCard.dart';
import 'package:lakhimpur_kheri/screens/news/views/article_view.dart';
import 'package:flutter/rendering.dart';
import 'package:lakhimpur_kheri/screens/news/views/cloud_downlods.dart';

//import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/cupertino.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:lakhimpur_kheri/screens/news/top_ten_news/loading.dart';
import 'package:intl/intl.dart';

class NewsTile extends StatelessWidget {
  final String source, imgUrl, title, desc, content, posturl, publishAt;

  NewsTile(
      {this.source,
      this.imgUrl,
      this.desc,
      this.title,
      this.content,
      @required this.posturl,
      this.publishAt});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(postUrl: posturl)));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 24),
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(6),
                      bottomLeft: Radius.circular(6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Stack(children: <Widget>[
                        Positioned.fill(
                            child: Align(
                          alignment: Alignment.center,
                          child: Loading(),
                        )),
                        Center(
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: imgUrl,
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                            left: 10.0,
                            right: 10.0,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  source,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.share,
                                          color: Colors.yellow,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.favorite,
                                            color: Colors.yellow,
                                          ),
                                          onPressed: () {}),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        Positioned(
                          top: 60.0,
                          left: 10.0,
                          right: 10.0,
                          child: _dateItemBuild(),
                        ),
                        Positioned(
                          top: 165.0,
                          left: 10.0,
                          right: 20.0,
                          child: Text(
                            title,
                            maxLines: 2,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),),
                        ),
                      ])),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    desc,
                    maxLines: 2,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  )
                ],
              ),
            ),
          )),
    );
  }

  _columnWithContent() {
    return Column(
      children: <Widget>[
        _headerItemBuild(),
        _textItemBuild(),
        _dateItemBuild(),
      ],
    );
  }

  _headerItemBuild() {
    return Row(
      children: <Widget>[
        Text(
          source,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Container(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.share,
                ),
                onPressed: () {},
              ),
              IconButton(
                  icon: Icon(
                    Icons.favorite,
                  ),
                  onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }

  _dateItemBuild() {
    // Parse date to normal format
    DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final unformedDate = format.parse(publishAt);
    Duration difference = unformedDate.difference(DateTime.now());

    return Container(
      padding: EdgeInsets.only(top: 12),
      child: Text(
        (int.tryParse(difference.inHours.abs().toString()) < 12)
            ? difference.inHours.abs().toString() + " hours ago"
            : difference.inDays.abs().toString() + " days ago",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      alignment: Alignment.centerLeft,
    );
  }

  _textItemBuild() {
    return Flexible(
      child: new Text(
        "helo hay this is for news to check it works.",
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: 8, color: Colors.white),
      ),
    );
  }
}

Widget Tabs(String tabn) {
  return Tab(
    child: Text(tabn,
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
  );
}

Widget title(String title1, String title2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        title1 + " ",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      Text(
        title2,
        style: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
      )
    ],
  );
}

final List colorList2 = [
  Colors.pink,
  Colors.pinkAccent,
  Colors.orange,
  Colors.green,
  Colors.redAccent
];

Widget TabBarWorld() {
  return TabBar(
    labelColor: Colors.black,
    labelStyle: TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    unselectedLabelColor: Colors.white,
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorWeight: 4,
    indicatorColor: Colors.blueGrey,
    indicator: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Colors.white70),
    isScrollable: true,
    tabs: [
      Tabs("Latest"),
      Tabs("Jobs"),
      Tabs("Education"),
      Tabs("Business"),
      Tabs("Entertainment"),
      Tabs("General"),
      Tabs("Health"),
      Tabs("Science"),
      Tabs("Sports"),
      Tabs("Technology"),
    ],
  );
}

Widget TabBarLocal() {
  return TabBar(
    labelStyle: TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    unselectedLabelColor: Colors.white,
    labelColor: Colors.black,
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorWeight: 4,
    indicatorColor: Colors.red,
    indicator: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Colors.white70),
    isScrollable: true,
    tabs: [
      Tabs("All"),
      Tabs("Offers"),
      Tabs("Jobs"),
      Tabs("Education"),
      Tabs("Anouncement"),
      Tabs("Sports"),
      Tabs("Important"),
      Tabs("Sales"),
    ],
  );
}

MyAppBarDownloads() {
  return AppBar(
    title: title("Downloaded", "News"),
    elevation: 4,
    backgroundColor: Colors.red,
    bottom: TabBar(
      labelColor: Colors.black,
      labelStyle: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      unselectedLabelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 2,
      indicatorColor: Colors.red,
      isScrollable: true,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white70),
      tabs: [
        Tabs("Local"),
        Tabs("Cloud"),
        Tabs("G-Drive"),
        Tabs("Gallery"),
      ],
    ),
  );
}

MyAppBarForYou() {
  return AppBar(
    backgroundColor: Colors.white,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(5.0),
      child: TabBar(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black54,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 4,
        indicatorColor: Colors.blue,
        isScrollable: true,
        tabs: [Tabs("Search"), Tabs("Categories")],
      ),
    ),
  );
}

Widget tabBarViewDownloads() {
  debugPrint("in ........................_tabBarView");
  return TabBarView(children: [
    new GestureDetector(
      onTap: () {
        // Change the color of the container beneath
      },
      child: Container(),
    ),
    new GestureDetector(
      onTap: () {
        // Change the color of the container beneath
      },
      child: CloudDownloads(),
    ),
    new GestureDetector(
      onTap: () {
        // Change the color of the container beneath
      },
      child: Container(),
    ),
    new GestureDetector(
      onTap: () {},
      child: Container(),
    ),
  ]);
}

Widget tabBarViewForYou() {
  debugPrint("in ........................_tabBarView");
  return TabBarView(children: [
    NewsCard(),
    CloudDownloads(),
  ]);
}
