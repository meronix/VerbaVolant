//
//  MoviesAndWords.m
//
//  Created by gianluca.m.meroni@gmail.com  on 05/04/2020
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "MoviesAndWords.h"


NSString *const kMoviesAndWordsListaMovie = @"listaMovie";
NSString *const kMoviesAndWordsWrongWords = @"wrongWords";


@interface MoviesAndWords ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MoviesAndWords

@synthesize listaMovie = _listaMovie;
@synthesize wrongWords = _wrongWords;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.listaMovie = [self objectOrNilForKey:kMoviesAndWordsListaMovie fromDictionary:dict];
            self.wrongWords = [self objectOrNilForKey:kMoviesAndWordsWrongWords fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
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

    self.listaMovie = [aDecoder decodeObjectForKey:kMoviesAndWordsListaMovie];
    self.wrongWords = [aDecoder decodeObjectForKey:kMoviesAndWordsWrongWords];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_listaMovie forKey:kMoviesAndWordsListaMovie];
    [aCoder encodeObject:_wrongWords forKey:kMoviesAndWordsWrongWords];
}

- (id)copyWithZone:(NSZone *)zone
{
    MoviesAndWords *copy = [[MoviesAndWords alloc] init];
    
    if (copy) {

        copy.listaMovie = [self.listaMovie copyWithZone:zone];
        copy.wrongWords = [self.wrongWords copyWithZone:zone];
    }
    
    return copy;
}


@end
