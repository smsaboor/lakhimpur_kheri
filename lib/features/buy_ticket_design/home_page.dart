import 'package:lakhimpur_kheri/features/buy_ticket_design/exhibition_bottom_sheet.dart';
import 'package:lakhimpur_kheri/features/buy_ticket_design/sliding_cards.dart';
import 'package:lakhimpur_kheri/features/buy_ticket_design/tabs.dart';
import 'package:flutter/material.dart';

import 'exhibition_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Header(),
                SizedBox(height: 40),
                Tabs(),
                SizedBox(height: 8),
                SlidingCardsView(),
              ],
            ),
          ),
          ExhibitionBottomSheet(), //use this or ScrollableExhibitionSheet
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'My News',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
