import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rifino/shared/ads/rifino_ad_ids.dart';

class RifinoAdBanner extends StatefulWidget {
  const RifinoAdBanner({super.key});

  @override
  State<RifinoAdBanner> createState() => _RifinoAdBannerState();
}

class _RifinoAdBannerState extends State<RifinoAdBanner> {
  BannerAd? _ad;
  bool _loaded = false;

  bool get _canShowAds {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  @override
  void initState() {
    super.initState();
    if (!_canShowAds) return;

    _ad = BannerAd(
      adUnitId: RifinoAdIds.banner,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _ad = null;
            _loaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_canShowAds || !_loaded || ad == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }
}
