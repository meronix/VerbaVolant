//
//  Extensions_Utils.h
//  Mastro Pietro
//
//  Created by meronix on 13/06/21.
//  Copyright © 2021 meronix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>


NS_ASSUME_NONNULL_BEGIN

@interface Extensions_Utils : NSObject


@end

@interface UIViewController(extension)

-(void)loadADBanner:(GADBannerView*)banner withADUnitID:(NSString*)adUnitID;
-(GADAdSize) getBannerAdaptiveSize;

@end


NS_ASSUME_NONNULL_END
