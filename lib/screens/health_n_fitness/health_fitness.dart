/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
 */

import 'package:flutter/material.dart';
import 'package:lakhimpur_kheri/features/taskPlanner/taskPlanner.dart';
import 'package:lakhimpur_kheri/screens/health_n_fitness/bmi_calculator/bmimain.dart';
import 'package:lakhimpur_kheri/screens/jobs/jobs.dart';
import 'package:lakhimpur_kheri/screens/quiz/quiz.dart';



class Gym extends StatefulWidget {

  Gym();

  @override
  State<StatefulWidget> createState() {
    return GymState();
  }
}
class GymState extends State<Gym> {

  GymState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 180.0,
            backgroundColor: Colors.cyan,
            floating: true,
            flexibleSpace: ListView(
              children: <Widget>[
                SizedBox(height: 70.0,),
                Text("Gym", textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                    )),
              ],
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.0,),),
          SliverToBoxAdapter(
            child: _buildCategoriesOtherPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesOtherPage() {
    return Container(
      height: 800,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: CategoryOtherPage(
                    backgroundColor: Colors.pink,
                    icon: Icons.menu,
                    title: "BMI Calculator",
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (_) => new BmiMyApp()));
                  }),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: CategoryOtherPage(
                    backgroundColor: Colors.blue,
                    title: "NavBars",
                    icon: Icons.account_circle,
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (_) => new Quiz()));
                  }),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: CategoryOtherPage(
                    icon: Icons.school,
                    backgroundColor: Colors.orange,
                    title: "Search",
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (_) => new Jobs()));
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: CategoryOtherPage(
                    backgroundColor: Colors.green,
                    icon: Icons.hotel,
                    title: "Music",
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                  }),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: CategoryOtherPage(
                    backgroundColor: Colors.lightBlueAccent,
                    title: "Gradient",
                    icon: Icons.restaurant,
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                  }),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: CategoryOtherPage(
                    icon: Icons.local_cafe,
                    backgroundColor: Colors.orange,
                    title: "Task planner",
                  ),
                  onDoubleTap: () {
                    // Update the state of the ap  .then((val)=>{_getRequests()})
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (_) => new TaskPlanner()));
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
class CategoryOtherPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;

  const CategoryOtherPage({
    Key key,
    @required this.icon,
    @required this.title,
    this.backgroundColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.all(10.0),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white,),
            SizedBox(height: 5.0,),
            Text(title, style: TextStyle(
                color: Colors.white
            ))
          ],
        ),
      ),
    );
  }
}