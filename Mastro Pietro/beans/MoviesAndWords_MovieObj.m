//
//  MoviesAndWords_MovieObj.m
//
//  Created by gianluca.m.meroni@gmail.com  on 17/04/2020
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "MoviesAndWords_MovieObj.h"


NSString *const kMoviesAndWords_MovieObjSourceUrl = @"source_url";
NSString *const kMoviesAndWords_MovieObjTargetedWords = @"targetedWords";
NSString *const kMoviesAndWords_MovieObjName = @"name";
NSString *const kMoviesAndWords_MovieObjType = @"type";


@interface MoviesAndWords_MovieObj ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MoviesAndWords_MovieObj

@synthesize sourceUrl = _sourceUrl;
@synthesize targetedWords = _targetedWords;
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
            self.sourceUrl = [self objectOrNilForKey:kMoviesAndWords_MovieObjSourceUrl fromDictionary:dict];
            self.targetedWords = [self objectOrNilForKey:kMoviesAndWords_MovieObjTargetedWords fromDictionary:dict];
            self.name = [self objectOrNilForKey:kMoviesAndWords_MovieObjName fromDictionary:dict];
            self.type = [self objectOrNilForKey:kMoviesAndWords_MovieObjType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.sourceUrl forKey:kMoviesAndWords_MovieObjSourceUrl];
    NSMutableArray *tempArrayForTargetedWords = [NSMutableArray array];
    for (NSObject *subArrayObject in self.targetedWords) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTargetedWords addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTargetedWords addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTargetedWords] forKey:kMoviesAndWords_MovieObjTargetedWords];
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

    self.sourceUrl = [aDecoder decodeObjectForKey:kMoviesAndWords_MovieObjSourceUrl];
    self.targetedWords = [aDecoder decodeObjectForKey:kMoviesAndWords_MovieObjTargetedWords];
    self.name = [aDecoder decodeObjectForKey:kMoviesAndWords_MovieObjName];
    self.type = [aDecoder decodeObjectForKey:kMoviesAndWords_MovieObjType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_sourceUrl forKey:kMoviesAndWords_MovieObjSourceUrl];
    [aCoder encodeObject:_targetedWords forKey:kMoviesAndWords_MovieObjTargetedWords];
    [aCoder encodeObject:_name forKey:kMoviesAndWords_MovieObjName];
    [aCoder encodeObject:_type forKey:kMoviesAndWords_MovieObjType];
}

- (id)copyWithZone:(NSZone *)zone
{
    MoviesAndWords_MovieObj *copy = [[MoviesAndWords_MovieObj alloc] init];
    
    if (copy) {

        copy.sourceUrl = [self.sourceUrl copyWithZone:zone];
        copy.targetedWords = [self.targetedWords copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
    }
    
    return copy;
}


@end
