//
//  MoviesAndWords.h
//
//  Created by gianluca.m.meroni@gmail.com  on 05/04/2020
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MoviesAndWords : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *listaMovie;
@property (nonatomic, strong) NSArray *wrongWords;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
