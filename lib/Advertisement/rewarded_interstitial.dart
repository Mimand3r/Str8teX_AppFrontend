// ca-app-pub-2789163953938863/8193537751

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future showRewardedInterstitial() async {
  late RewardedInterstitialAd add;
  final addLoadedCompleter = Completer<void>();

  RewardedInterstitialAd.load(
    adUnitId: 'ca-app-pub-2789163953938863/8193537751',
    request: AdRequest(),
    rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
      onAdLoaded: (RewardedInterstitialAd ad) {
        debugPrint('$ad loaded.');
        // Keep a reference to the ad so you can show it later.
        add = ad;
        addLoadedCompleter.complete();
      },
      onAdFailedToLoad: (LoadAdError error) {
        debugPrint('RewardedAd failed to load: $error');
        addLoadedCompleter.completeError(error);
      },
    ),
  );

  await addLoadedCompleter.future;

  add.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
        debugPrint('$ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
      debugPrint('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent:
        (RewardedInterstitialAd ad, AdError error) {
      debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
    },
    onAdImpression: (RewardedInterstitialAd ad) =>
        debugPrint('$ad impression occurred.'),
  );

  add.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
    debugPrint('Reward earned. ${rewardItem.amount}');
  });
}
