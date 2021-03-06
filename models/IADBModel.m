//
//  NrstModel.m
//  airportsdb
//
//  Created by Christopher Hobbs on 2/18/14.
//  Copyright (c) 2014 Toonsy Net. All rights reserved.
//

#import "IADBModel.h"
#import "IADBAirport.h"
#import "IADBPersistence.h"

static IADBPersistence *_persistence = nil;

@implementation IADBModel

+(IADBPersistence *) persistence {
    if( !_persistence ) {
        _persistence = [[IADBPersistence alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"airportsdb" ofType:@"sqlite"]];
    }
    return _persistence;
}

+(void) setPersistencePath:(NSString *) path {
    _persistence = [[IADBPersistence alloc] initWithPath:path];
}

+(NSManagedObjectContext *) managedObjectContext {
    return [[self persistence] managedObjectContext];
}

+(NSInteger) countAll {
    NSError *error;
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:[self description]];
    NSUInteger count = [[IADBModel managedObjectContext] countForFetchRequest:fetch error:&error];
    NSAssert3(!error, @"Unhandled error counting in %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
    return count;
}

-(BOOL) isBlank {
    return ![self valueForKey:@"airportId"];
}

+(NSArray *) findAllByAirportId:(int32_t) airportId {
    
    NSManagedObjectContext *context = [IADBModel managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[self description] inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(airportId = %d)",airportId];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    NSAssert3(objects, @"Unhandled error removing file in %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
    
    return objects;
}

@end
