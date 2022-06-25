import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Container showBanner() {
  // TestBanner1: ca-app-pub-2789163953938863/8139311835
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-2789163953938863/8139311835',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => debugPrint('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        debugPrint('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
    ),
  );

  myBanner.load();

  return Container(
    alignment: Alignment.center,
    width: myBanner.size.width.toDouble(),
    height: myBanner.size.height.toDouble(),
    child: AdWidget(ad: myBanner),
  );
}
