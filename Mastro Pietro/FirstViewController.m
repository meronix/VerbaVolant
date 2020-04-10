//
//  FirstViewController.m
//  Mastro Pietro
//
//  Created by meronix on 02/04/2020.
//  Copyright © 2020 meronix. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString* welcomeMessage = NSLocalizedString(@"welcomeMessage", nil);
    _welcomeMessage.text = welcomeMessage;
    [_startButton setTitle:NSLocalizedString(@"cominciaButton", nil) forState:UIControlStateNormal];
}


@end
