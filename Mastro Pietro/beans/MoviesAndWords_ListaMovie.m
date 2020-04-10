//
//  MoviesAndWords_ListaMovie.m
//
//  Created by gianluca.m.meroni@gmail.com  on 09/04/2020
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "MoviesAndWords_ListaMovie.h"
#import "MoviesAndWords_MovieObj.h"


NSString *const kMoviesAndWords_ListaMovieMovieObj = @"movie_obj";


@interface MoviesAndWords_ListaMovie ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MoviesAndWords_ListaMovie

@synthesize movieObj = _movieObj;


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
    NSObject *receivedMoviesAndWords_MovieObj = [dict objectForKey:kMoviesAndWords_ListaMovieMovieObj];
    NSMutableArray *parsedMoviesAndWords_MovieObj = [NSMutableArray array];
    if ([receivedMoviesAndWords_MovieObj isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedMoviesAndWords_MovieObj) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedMoviesAndWords_MovieObj addObject:[MoviesAndWords_MovieObj modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedMoviesAndWords_MovieObj isKindOfClass:[NSDictionary class]]) {
       [parsedMoviesAndWords_MovieObj addObject:[MoviesAndWords_MovieObj modelObjectWithDictionary:(NSDictionary *)receivedMoviesAndWords_MovieObj]];
    }

    self.movieObj = [NSArray arrayWithArray:parsedMoviesAndWords_MovieObj];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForMovieObj = [NSMutableArray array];
    for (NSObject *subArrayObject in self.movieObj) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMovieObj addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMovieObj addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMovieObj] forKey:kMoviesAndWords_ListaMovieMovieObj];

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

    self.movieObj = [aDecoder decodeObjectForKey:kMoviesAndWords_ListaMovieMovieObj];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_movieObj forKey:kMoviesAndWords_ListaMovieMovieObj];
}

- (id)copyWithZone:(NSZone *)zone
{
    MoviesAndWords_ListaMovie *copy = [[MoviesAndWords_ListaMovie alloc] init];
    
    if (copy) {

        copy.movieObj = [self.movieObj copyWithZone:zone];
    }
    
    return copy;
}


@end
