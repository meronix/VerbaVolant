//
//  MoviesAndWords_MovieObj.m
//
//  Created by gianluca.m.meroni@gmail.com  on 09/04/2020
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "MoviesAndWords_MovieObj.h"


NSString *const kMoviesAndWords_MovieObjName = @"name";
NSString *const kMoviesAndWords_MovieObjType = @"type";


@interface MoviesAndWords_MovieObj ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MoviesAndWords_MovieObj

@synthesize name = _name;
@synthesize type = _type;


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
            self.name = [self objectOrNilForKey:kMoviesAndWords_MovieObjName fromDictionary:dict];
            self.type = [self objectOrNilForKey:kMoviesAndWords_MovieObjType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kMoviesAndWords_MovieObjName];
    [mutableDict setValue:self.type forKey:kMoviesAndWords_MovieObjType];

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

    self.name = [aDecoder decodeObjectForKey:kMoviesAndWords_MovieObjName];
    self.type = [aDecoder decodeObjectForKey:kMoviesAndWords_MovieObjType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kMoviesAndWords_MovieObjName];
    [aCoder encodeObject:_type forKey:kMoviesAndWords_MovieObjType];
}

- (id)copyWithZone:(NSZone *)zone
{
    MoviesAndWords_MovieObj *copy = [[MoviesAndWords_MovieObj alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
    }
    
    return copy;
}


@end
