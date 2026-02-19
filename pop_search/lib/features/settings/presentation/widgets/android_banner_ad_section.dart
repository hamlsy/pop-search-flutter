import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AndroidBannerAdSection extends StatefulWidget {
  const AndroidBannerAdSection({super.key});

  @override
  State<AndroidBannerAdSection> createState() => _AndroidBannerAdSectionState();
}

class _AndroidBannerAdSectionState extends State<AndroidBannerAdSection> {
  static const _androidTestBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  BannerAd? _bannerAd;
  bool _isLoaded = false;

  bool get _isAndroidOnly {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  @override
  void initState() {
    super.initState();
    if (_isAndroidOnly) {
      MobileAds.instance.initialize();
      _loadBanner();
    }
  }

  void _loadBanner() {
    final ad = BannerAd(
      adUnitId: _androidTestBannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) {
            return;
          }
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (failedAd, _) {
          failedAd.dispose();
          if (!mounted) {
            return;
          }
          setState(() {
            _isLoaded = false;
          });
        },
      ),
    );

    _bannerAd = ad;
    ad.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAndroidOnly) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 74,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: _isLoaded && _bannerAd != null
          ? SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : Text(
              'Ad unavailable',
              style: Theme.of(context).textTheme.bodySmall,
            ),
    );
  }
}
