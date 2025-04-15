//
//  RewardedViewModel.swift
//  My CowsREAL
//
//  Created by Bridger Hall on 11/12/24.
//

import GoogleMobileAds

class RewardedViewModel: NSObject, ObservableObject, GADFullScreenContentDelegate {
    @Published var coins = 0
    private var rewardedAd: GADRewardedAd?

    func loadAd() async {
        do {
            rewardedAd = try await GADRewardedAd.load(
                withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: GADRequest())
            rewardedAd?.fullScreenContentDelegate = self
        } catch {
            print("Failed to load rewarded ad with error: \(error.localizedDescription)")
        }
    }
}
