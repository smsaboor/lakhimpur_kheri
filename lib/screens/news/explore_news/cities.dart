import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CityNews extends StatefulWidget {
  int colorVal;
  CityNews(this.colorVal);
  _CityNewsState createState() => _CityNewsState();
}

class _CityNewsState extends State<CityNews> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
     void initState() {
       super.initState();
      _tabController = new TabController(vsync: this, length: 7);
      _tabController.addListener(_handleTabSelection);
     }
     void _handleTabSelection() {
        setState(() {
          widget.colorVal=0xff990099;
         });
     }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
    child: TabBar(
            isScrollable: true,
            indicatorWeight: 4.0,
            indicatorColor:Color(0xff990099),
            unselectedLabelColor: Colors.grey,
             controller: _tabController,
            tabs: <Widget>[
              Tab(
                child:Text('Lucknow',style: TextStyle( color: _tabController.index == 0
                          ?  Color( widget.colorVal)
                          : Colors.grey)),
              ),
              Tab(
                child: Text('Delhi',style: TextStyle( color: _tabController.index == 1
                          ?  Color( widget.colorVal)
                          : Colors.grey)),
              ),
              Tab(
                child: Text('Mumbai',style: TextStyle( color: _tabController.index == 2
                          ?  Color( widget.colorVal)
                          : Colors.grey)),
              ),
               Tab(
                child: Text('Banglore',style: TextStyle( color: _tabController.index == 3
                          ?  Color( widget.colorVal)
                          : Colors.grey)),
              ),
              Tab(
                child: Text('Bhopal',style: TextStyle( color: _tabController.index == 4
                          ?  Color( widget.colorVal)
                          : Colors.grey)),
              ),
              Tab(
                child: Text('Ahmadabad',style: TextStyle( color: _tabController.index == 5
                          ?  Color( widget.colorVal)
                          : Colors.grey)),
              ),
              Tab(
//                icon: Icon(FontAwesomeIcons.chartBar, color: _tabController.index == 6
//                          ? Color( widget.colorVal)
//                          : Colors.grey),
                child: Text('Patna',style: TextStyle( color: _tabController.index == 6
                          ?  Color( widget.colorVal)
                          : Colors.grey)),
              ),
            
            ],
          )),
        ),
      ),
    );
  }
}
