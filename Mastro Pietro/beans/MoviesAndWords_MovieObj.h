//
//  MoviesAndWords_MovieObj.h
//
//  Created by gianluca.m.meroni@gmail.com  on 17/04/2020
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MoviesAndWords_MovieObj : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *sourceUrl;
@property (nonatomic, strong) NSArray *targetedWords;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
