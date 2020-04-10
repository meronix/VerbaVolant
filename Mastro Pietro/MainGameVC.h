//
//  SecondViewController.h
//  Mastro Pietro
//
//  Created by meronix on 02/04/2020.
//  Copyright © 2020 meronix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoviesAndWords_Main.h"

typedef enum : NSUInteger {
    MovieSourceType_embedded = 0,
    MovieSourceType_web = 1,
} MovieSourceType;



@interface MoviesAndWords_MovieObj (utilities)

-(MovieSourceType)getType;

@end



@interface MainGameVC : UIViewController <UINavigationControllerDelegate, DataLoaderProtocol>


@end

