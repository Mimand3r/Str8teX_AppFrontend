// ca-app-pub-2789163953938863/5181179843

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future showRewarded() async {
  late RewardedAd add;
  final addLoadedCompleter = Completer<void>();

  RewardedAd.load(
    adUnitId: 'ca-app-pub-2789163953938863/5181179843',
    request: AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (RewardedAd ad) {
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
    onAdShowedFullScreenContent: (RewardedAd ad) =>
        debugPrint('$ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (RewardedAd ad) {
      debugPrint('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
    },
    onAdImpression: (RewardedAd ad) => debugPrint('$ad impression occurred.'),
  );

  add.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
    debugPrint('Reward earned. ${rewardItem.amount}');
  });
}
