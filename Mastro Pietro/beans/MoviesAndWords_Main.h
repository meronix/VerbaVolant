//
//  MoviesAndWords_Main.h
//
//  Created by gianluca.m.meroni@gmail.com  on 09/04/2020
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MoviesAndWords_ListaRisposteKO.h"
#import "MoviesAndWords_ListaRisposteOK.h"
#import "MoviesAndWords_MovieObj.h"
#import "MoviesAndWords_ListaMovie.h"

//@class MoviesAndWords_ListaRisposteKO, MoviesAndWords_ListaRisposteOK, MoviesAndWords_ListaMovie;

@interface MoviesAndWords_Main : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) MoviesAndWords_ListaRisposteKO *listaRisposteKO;
@property (nonatomic, strong) NSArray *wrongWords;
@property (nonatomic, strong) MoviesAndWords_ListaRisposteOK *listaRisposteOK;
@property (nonatomic, strong) MoviesAndWords_ListaMovie *listaMovie;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
