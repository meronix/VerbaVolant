//
//  MoviesAndWords_Main.m
//
//  Created by gianluca.m.meroni@gmail.com  on 09/04/2020
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "MoviesAndWords_Main.h"
#import "MoviesAndWords_ListaRisposteKO.h"
#import "MoviesAndWords_ListaRisposteOK.h"
#import "MoviesAndWords_ListaMovie.h"


NSString *const kMoviesAndWords_MainListaRisposteKO = @"listaRisposteKO";
NSString *const kMoviesAndWords_MainWrongWords = @"wrongWords";
NSString *const kMoviesAndWords_MainListaRisposteOK = @"listaRisposteOK";
NSString *const kMoviesAndWords_MainListaMovie = @"listaMovie";


@interface MoviesAndWords_Main ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MoviesAndWords_Main

@synthesize listaRisposteKO = _listaRisposteKO;
@synthesize wrongWords = _wrongWords;
@synthesize listaRisposteOK = _listaRisposteOK;
@synthesize listaMovie = _listaMovie;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.listaRisposteKO = [MoviesAndWords_ListaRisposteKO modelObjectWithDictionary:[dict objectForKey:kMoviesAndWords_MainListaRisposteKO]];
            self.wrongWords = [self objectOrNilForKey:kMoviesAndWords_MainWrongWords fromDictionary:dict];
            self.listaRisposteOK = [MoviesAndWords_ListaRisposteOK modelObjectWithDictionary:[dict objectForKey:kMoviesAndWords_MainListaRisposteOK]];
            self.listaMovie = [MoviesAndWords_ListaMovie modelObjectWithDictionary:[dict objectForKey:kMoviesAndWords_MainListaMovie]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.listaRisposteKO dictionaryRepresentation] forKey:kMoviesAndWords_MainListaRisposteKO];
    NSMutableArray *tempArrayForWrongWords = [NSMutableArray array];
    for (NSObject *subArrayObject in self.wrongWords) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForWrongWords addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForWrongWords addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForWrongWords] forKey:kMoviesAndWords_MainWrongWords];
    [mutableDict setValue:[self.listaRisposteOK dictionaryRepresentation] forKey:kMoviesAndWords_MainListaRisposteOK];
    [mutableDict setValue:[self.listaMovie dictionaryRepresentation] forKey:kMoviesAndWords_MainListaMovie];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.listaRisposteKO = [aDecoder decodeObjectForKey:kMoviesAndWords_MainListaRisposteKO];
    self.wrongWords = [aDecoder decodeObjectForKey:kMoviesAndWords_MainWrongWords];
    self.listaRisposteOK = [aDecoder decodeObjectForKey:kMoviesAndWords_MainListaRisposteOK];
    self.listaMovie = [aDecoder decodeObjectForKey:kMoviesAndWords_MainListaMovie];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_listaRisposteKO forKey:kMoviesAndWords_MainListaRisposteKO];
    [aCoder encodeObject:_wrongWords forKey:kMoviesAndWords_MainWrongWords];
    [aCoder encodeObject:_listaRisposteOK forKey:kMoviesAndWords_MainListaRisposteOK];
    [aCoder encodeObject:_listaMovie forKey:kMoviesAndWords_MainListaMovie];
}

- (id)copyWithZone:(NSZone *)zone
{
    MoviesAndWords_Main *copy = [[MoviesAndWords_Main alloc] init];
    
    if (copy) {

        copy.listaRisposteKO = [self.listaRisposteKO copyWithZone:zone];
        copy.wrongWords = [self.wrongWords copyWithZone:zone];
        copy.listaRisposteOK = [self.listaRisposteOK copyWithZone:zone];
        copy.listaMovie = [self.listaMovie copyWithZone:zone];
    }
    
    return copy;
}


@end
