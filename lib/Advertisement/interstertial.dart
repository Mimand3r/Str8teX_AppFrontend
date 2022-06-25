// ca-app-pub-2789163953938863/7232342707

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future showInterstitial() async {
  late InterstitialAd interstitialAd;

  var adLoadedCopleter = Completer<void>();
  await InterstitialAd.load(
      adUnitId: 'ca-app-pub-2789163953938863/7232342707',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          debugPrint('Add Loaded');
          interstitialAd = ad;
          adLoadedCopleter.complete();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          adLoadedCopleter.completeError(error);
        },
      ));

  await adLoadedCopleter.future;

  interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) =>
        debugPrint('%ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      debugPrint('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
    },
    onAdImpression: (InterstitialAd ad) =>
        debugPrint('$ad impression occurred.'),
  );

  interstitialAd.show();
}
