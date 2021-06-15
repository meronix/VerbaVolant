//
//  FirstViewController.m
//  Mastro Pietro
//
//  Created by meronix on 02/04/2020.
//  Copyright © 2020 meronix. All rights reserved.
//

#import "FirstViewController.h"

#import <Firebase/Firebase.h>

@interface FirstViewController ()

//@property (nonatomic, strong) NSString* kBannerAdUnitID;  //= "ca-app-pub-8846796167589629/2003230791"
//@IBOutlet weak var banner: GADBannerView!

@property (nonatomic, strong) IBOutlet GADBannerView * banner;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// self.kBannerAdUnitID = @"ca-app-pub-5952984043381908/6910357584";
    // Do any additional setup after loading the view.
    NSString* welcomeMessage = NSLocalizedString(@"welcomeMessage", nil);
    _welcomeMessage.text = welcomeMessage;
    [_startButton setTitle:NSLocalizedString(@"cominciaButton", nil) forState:UIControlStateNormal];
    [self loadADBanner:self.banner withADUnitID:kBannerAdUnitID];
}


/*
-(void)loadA {
    self.banner.adUnitID = kBannerAdUnitID;
    self.banner.rootViewController = self;
    [self.banner loadRequest:[GADRequest request]];
}
*/

@end
