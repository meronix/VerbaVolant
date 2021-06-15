//
//  Extensions_Utils.m
//  Mastro Pietro
//
//  Created by meronix on 13/06/21.
//  Copyright © 2021 meronix. All rights reserved.
//

#import "Extensions_Utils.h"

@implementation Extensions_Utils

@end


@implementation UIViewController(extension)


-(void)loadADBanner:(GADBannerView*)banner withADUnitID:(NSString*)adUnitID {
    banner.adUnitID = adUnitID;
    banner.rootViewController = self;
    banner.adSize = [self getBannerAdaptiveSize ];
    banner.backgroundColor = [UIColor colorWithRed:.3 green:.3 blue:.4 alpha:.5];
    [banner loadRequest:[GADRequest request]];
}

-(GADAdSize) getBannerAdaptiveSize {
    // Step 1 - Determine the view width to use for the ad width.
    //in this codelab we use the full safe area width
    CGRect frame;
    // Here safe area is taken into account, hence the view frame is used
    // after the view has been laid out.
    
    if (@available(iOS 11, *)) {
        //        if @available(iOS 11.0, *) {
        frame = UIEdgeInsetsInsetRect(self.view.frame, self.view.safeAreaInsets) ;    //.inset(by: view.safeAreaInsets)
    } else {
        frame = self.view.frame;
    }
    CGFloat viewWidth = frame.size.width;
    
    // Step 2 - Get Adaptive GADAdSize and set the ad view.
    GADAdSize adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth);
    return adSize;
}

@end
