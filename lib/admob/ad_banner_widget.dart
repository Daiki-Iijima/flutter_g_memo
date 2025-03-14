import 'package:flutter/cupertino.dart';
import 'package:g_memo/admob/admob_utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: getAdBannerUnitId(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print("広告読み込み失敗:$error");
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );

    _bannerAd.load();
  }

  @override
  void initState() {
    super.initState();

    _loadBannerAd();
  }

  @override
  void dispose() {
    //  バナーの開放
    _bannerAd.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  広告が読み込まれていない場合は何もしない
    if (!_isBannerAdLoaded) {
      return const SizedBox.shrink();
    }

    //  広告を表示
    return Container(
      alignment: Alignment.center,
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd),
    );
  }
}
