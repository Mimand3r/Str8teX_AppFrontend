import 'package:flutter/material.dart';
import 'package:str8tex_frontend/Advertisement/banner.dart';
import 'package:str8tex_frontend/Advertisement/interstertial.dart';

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
        const SizedBox(height: 200),
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
        const Spacer(),
        showBanner(),
      ],
    ));
  }
}
