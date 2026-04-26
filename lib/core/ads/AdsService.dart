import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  static const int maxFailedLoadAttempts = 3;

  final AdRequest request = const AdRequest();

  bool isTest = true;



  // ================= IDs =================

  String get bannerId => isTest
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-4775377672441609/7685591547';

  String get interstitialId => isTest
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-4775377672441609/2712031698';

  String get rewardedId => isTest
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-4775377672441609/7142231294';

  String get rewardedInterstitialId => isTest
      ? 'ca-app-pub-3940256099942544/5354046379'
      : 'ca-app-pub-4775377672441609/1298148724';

  String get appOpenId => isTest
      ? 'ca-app-pub-3940256099942544/3419835294'
      : 'ca-app-pub-4775377672441609/1326068888';

  // ================= Interstitial =================

  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;

  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          _interstitialLoadAttempts++;
          _interstitialAd = null;
          if (_interstitialLoadAttempts < maxFailedLoadAttempts) {
            loadInterstitial();
          }
        },
      ),
    );
  }

  void showInterstitial() {
    if (_interstitialAd == null) return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadInterstitial();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // ================= Rewarded =================

  RewardedAd? _rewardedAd;
  int _rewardedLoadAttempts = 0;

  void loadRewarded() {
    RewardedAd.load(
      adUnitId: rewardedId,
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          _rewardedLoadAttempts++;
          _rewardedAd = null;
          if (_rewardedLoadAttempts < maxFailedLoadAttempts) {
            loadRewarded();
          }
        },
      ),
    );
  }

  void showRewarded(Function onReward) {
    if (_rewardedAd == null) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadRewarded();
      },
    );

    _rewardedAd!.setImmersiveMode(true);

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onReward();
      },
    );

    _rewardedAd = null;
  }

  // ================= Rewarded Interstitial =================

  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _rewardedInterstitialLoadAttempts = 0;

  void loadRewardedInterstitial() {
    RewardedInterstitialAd.load(
      adUnitId: rewardedInterstitialId,
      request: request,
      rewardedInterstitialAdLoadCallback:
      RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd = ad;
          _rewardedInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          _rewardedInterstitialLoadAttempts++;
          _rewardedInterstitialAd = null;
          if (_rewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
            loadRewardedInterstitial();
          }
        },
      ),
    );
  }

  void showRewardedInterstitial(Function onReward) {
    if (_rewardedInterstitialAd == null) return;

    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            loadRewardedInterstitial();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            loadRewardedInterstitial();
          },
        );

    _rewardedInterstitialAd!.setImmersiveMode(true);

    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (ad, reward) {
        onReward();
      },
    );

    _rewardedInterstitialAd = null;
  }

  // ================= App Open =================

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  void loadAppOpen() {
    AppOpenAd.load(
      adUnitId: appOpenId,
      request: request,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
        },
      ),
    );
  }

  void showAppOpen() {
    if (_appOpenAd == null || _isShowingAd) return;

    _isShowingAd = true;

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        loadAppOpen();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        loadAppOpen();
      },
    );

    _appOpenAd!.show();
    _appOpenAd = null;
  }

  // ================= Init =================

  void init() {
    MobileAds.instance.initialize();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
    _appOpenAd?.dispose();
  }
}