import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_admob_yt/controller/admob_controller.dart';
import 'package:flutter_riverpod_admob_yt/views/another_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    ref.read(admobProvider.notifier).loadBannerAd();
    ref.read(admobProvider.notifier).loadInterstitialAd();
    ref.read(admobProvider.notifier).loadRewardedAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admob Tutorial'),
      ),
      body: Column(
        children: [
          // ---------
          ref.watch(admobProvider).bannerAd == null
              ? const SizedBox()
              : SizedBox(
                  height:
                      ref.watch(admobProvider).bannerAd!.size.height.toDouble(),
                  width:
                      ref.watch(admobProvider).bannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: ref.watch(admobProvider).bannerAd!),
                ),
          // ---------
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(admobProvider).interstitialAd!.show();
                    },
                    child: const Text('Interstitial Ad'),
                  ),
                  // ---------
                  ElevatedButton(
                    onPressed: ref.watch(admobProvider).rewardedAd == null
                        ? () {}
                        : () {
                            ref
                                .read(admobProvider)
                                .rewardedAd!
                                .show(
                                  onUserEarnedReward: (ad, reward) {},
                                )
                                .whenComplete(() async {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AnotherView(),
                              ));
                            });
                          },
                    child: const Text('Rewarded Ad'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
