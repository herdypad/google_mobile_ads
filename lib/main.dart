import 'dart:io';

import 'package:abmob_resmi/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//======================= open ad
AppOpenAd? openAd;
Future<void> loadAd() async {
  await AppOpenAd.load(
    adUnitId: AdHelper.openAdUnit,
    request: AdRequest(),
    adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: ((ad) {
      openAd = ad;
      // openAd!.show();
    }), onAdFailedToLoad: ((error) {
      print("add benner Error ${error}");
    })),
    orientation: AppOpenAd.orientationPortrait,
  );
}

void showAd() {
  if (openAd == null) {
    print("trying to show before loading");
    loadAd();
    return;
  }

  openAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (ad) {
      print("ON show Ad Open");
    },
    onAdFailedToShowFullScreenContent: (ad, error) {
      print("ad Open Error ${error}");
    },
    onAdDismissedFullScreenContent: (ad) {
      print("close Ad Open");
      openAd = null;
      loadAd();
    },
  );

  openAd!.show();
}
// =====================================open ad

/*








*/

// tambahan async di main
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

// open ad
  await MobileAds.instance.initialize();
  await loadAd();
// open ad

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

///=====================================
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //============ benner dan int ada
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  //============ benner dan int ada

  void bannerAdInit() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdHelper.bannerAdUnit,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        }, onAdFailedToLoad: ((ad, error) {
          print("add benner Error ${error}");
          _isBannerAdReady = false;
          ad.dispose();
        })),
        request: AdRequest())
      ..load();

    InterstitialAd.load(
      adUnitId: AdHelper.intersialAdUnit,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: ((ad) {
          this._interstitialAd = ad;
          _isInterstitialAdReady = true;
        }),
        onAdFailedToLoad: ((error) {
          print("add benner Error ${error}");
          _isInterstitialAdReady = false;
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bannerAdInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd.dispose();
    _interstitialAd.dispose();
  }

  //============
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admob Tes 2"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Halloo ini benner saya"),
            if (_isBannerAdReady)
              Container(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            ElevatedButton(
                onPressed: () {
                  if (_isInterstitialAdReady) {
                    _interstitialAd.show();
                    print("Berhasil Load intersial");
                  }
                  print("Gagal Load intersial");
                  bannerAdInit();
                },
                child: Text("Intersial ad")),
            ElevatedButton(
                onPressed: () {
                  showAd();
                },
                child: Text("Open ad"))
          ],
        ),
      ),
    );
  }
}
