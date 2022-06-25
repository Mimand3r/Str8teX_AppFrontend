import 'package:flutter/material.dart';
import 'package:str8tex_frontend/Advertisement/banner.dart';
import 'package:str8tex_frontend/Advertisement/interstertial.dart';
import 'package:str8tex_frontend/Advertisement/rewarded.dart';
import 'package:str8tex_frontend/Advertisement/rewarded_interstitial.dart';

class WerbeTestingPage extends StatefulWidget {
  const WerbeTestingPage({Key? key}) : super(key: key);

  @override
  State<WerbeTestingPage> createState() => _WerbeTestingPageState();
}

class _WerbeTestingPageState extends State<WerbeTestingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const SizedBox(height: 100),
        GestureDetector(
          onTap: () {
            showInterstitial();
          },
          child: const Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Interstitial Test"),
            ),
          ),
        ),
        const SizedBox(height: 100),
        GestureDetector(
          onTap: () {
            showRewarded();
          },
          child: const Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Rewarded Test"),
            ),
          ),
        ),
        const SizedBox(height: 100),
        GestureDetector(
          onTap: () {
            showRewardedInterstitial();
          },
          child: const Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Rewarded Interstitital Test"),
            ),
          ),
        ),
        const Spacer(),
        showBanner(),
      ],
    ));
  }
}
