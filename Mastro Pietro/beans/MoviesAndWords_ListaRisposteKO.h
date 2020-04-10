//
//  MoviesAndWords_ListaRisposteKO.h
//
//  Created by gianluca.m.meroni@gmail.com  on 09/04/2020
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MoviesAndWords_ListaRisposteKO : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *movieObj;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
