//
//  MoviesAndWords.m
//
//  Created by gianluca.m.meroni@gmail.com  on 05/04/2020
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "MoviesAndWords.h"


NSString *const kMoviesAndWordsListaRisposteKO = @"listaRisposteKO";
NSString *const kMoviesAndWordsWrongWords = @"wrongWords";
NSString *const kMoviesAndWordsListaRisposteOK = @"listaRisposteOK";
NSString *const kMoviesAndWordsListaMovie = @"listaMovie";


@interface MoviesAndWords ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MoviesAndWords

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
            self.listaRisposteKO = [self objectOrNilForKey:kMoviesAndWordsListaRisposteKO fromDictionary:dict];
            self.wrongWords = [self objectOrNilForKey:kMoviesAndWordsWrongWords fromDictionary:dict];
            self.listaRisposteOK = [self objectOrNilForKey:kMoviesAndWordsListaRisposteOK fromDictionary:dict];
            self.listaMovie = [self objectOrNilForKey:kMoviesAndWordsListaMovie fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForListaRisposteKO = [NSMutableArray array];
    for (NSObject *subArrayObject in self.listaRisposteKO) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForListaRisposteKO addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForListaRisposteKO addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForListaRisposteKO] forKey:kMoviesAndWordsListaRisposteKO];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForWrongWords] forKey:kMoviesAndWordsWrongWords];
    NSMutableArray *tempArrayForListaRisposteOK = [NSMutableArray array];
    for (NSObject *subArrayObject in self.listaRisposteOK) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForListaRisposteOK addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForListaRisposteOK addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForListaRisposteOK] forKey:kMoviesAndWordsListaRisposteOK];
    NSMutableArray *tempArrayForListaMovie = [NSMutableArray array];
    for (NSObject *subArrayObject in self.listaMovie) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForListaMovie addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForListaMovie addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForListaMovie] forKey:kMoviesAndWordsListaMovie];

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

    self.listaRisposteKO = [aDecoder decodeObjectForKey:kMoviesAndWordsListaRisposteKO];
    self.wrongWords = [aDecoder decodeObjectForKey:kMoviesAndWordsWrongWords];
    self.listaRisposteOK = [aDecoder decodeObjectForKey:kMoviesAndWordsListaRisposteOK];
    self.listaMovie = [aDecoder decodeObjectForKey:kMoviesAndWordsListaMovie];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_listaRisposteKO forKey:kMoviesAndWordsListaRisposteKO];
    [aCoder encodeObject:_wrongWords forKey:kMoviesAndWordsWrongWords];
    [aCoder encodeObject:_listaRisposteOK forKey:kMoviesAndWordsListaRisposteOK];
    [aCoder encodeObject:_listaMovie forKey:kMoviesAndWordsListaMovie];
}

- (id)copyWithZone:(NSZone *)zone
{
    MoviesAndWords *copy = [[MoviesAndWords alloc] init];
    
    if (copy) {

        copy.listaRisposteKO = [self.listaRisposteKO copyWithZone:zone];
        copy.wrongWords = [self.wrongWords copyWithZone:zone];
        copy.listaRisposteOK = [self.listaRisposteOK copyWithZone:zone];
        copy.listaMovie = [self.listaMovie copyWithZone:zone];
    }
    
    return copy;
}


@end
