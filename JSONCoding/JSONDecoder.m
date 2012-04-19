//
//  JSONDecoder.m
//  JSONCoding
//
//  Created by Noura Hassan on 4/19/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import "JSONDecoder.h"
#import "NSData+Base64.h"
#import "NSString+Additions.h"

@interface JSONDecoder()

- (NSArray *)decodeArrayOfClass:(Class)class;
- (NSArray *)decodeArrayOfPrimitives;
- (NSObject *)decodeFoundationObject:(id) object;
- (void)pushObject:(id)jsonObject withId:(NSString *)jsonObjectId;
- (void)pop;
- (NSDictionary *)topJsonObject;
- (NSString *)topJsonObjectId;
- (Class) getClassForKey:(NSString *) key;

@end

@implementation JSONDecoder{
    NSMutableArray * objectIDStack;
    NSMutableArray * jsonObjectStack;    
    NSMutableDictionary * mappingClasses;
}

- (id) initWithResponse:(NSData *) response{
    self = [self init];
    if(self){
        NSError* error;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:response //1
                                                             options:0 
                                                               error:&error];
        if(error){
            NSLog(@"Error %@", [error userInfo]);
            return nil;
        }
        jsonObjectStack = [NSMutableArray new];
		objectIDStack = [NSMutableArray new];
        mappingClasses = [NSMutableDictionary new];
        
		[self pushObject:jsonObject withId:@"root"];
    }
    return self;
}

- (void) addAlias:(NSString *) alias forClass:(Class) aClass{
    [mappingClasses setObject:aClass forKey:alias];   
}

- (id)decodeObject {
    Class class = [self getClassForKey:[self topJsonObjectId]];
    
    //TODO add handle for hibernate proxies

	id object = nil;
	if ([class isSubclassOfClass:[NSNull class]]) {
		object = nil;
	} else if([[self topJsonObject] isKindOfClass:[NSArray class]]){
        
		object = [self decodeArrayOfClass:class];
        
	}else if([[self topJsonObject] isKindOfClass:[NSString class]]){
        
		object = [self topJsonObject];
        
	}else {
		object = [[class alloc] initWithCoder:self];
	}
	
	return object;
}

- (id)decodeObjectForKey:(NSString *)key {
	id object = [[self topJsonObject] objectForKey:key];
	if(!object) return nil;
    
    NSObject * decodedObject = [self decodeFoundationObject:object];
    if(decodedObject != nil){
        return decodedObject;
    }
	[self pushObject:object withId:key];
	object = [self decodeObject];
	[self pop];
    
	return object;
}

- (double)decodeDoubleForKey:(NSString *)key {
	NSDecimalNumber *doubleStr = [[self topJsonObject] valueForKey:key];
	return [doubleStr doubleValue];
}

- (NSArray *)decodeArrayOfClass:(Class)class{
    NSString * key = nil; 
    NSArray * jsonArray = nil;

	if([[self topJsonObject] isKindOfClass:[NSArray class]]){
        NSDictionary * innerDictionary = [(NSArray *)[self topJsonObject] objectAtIndex:0];
        
        if(![innerDictionary isKindOfClass:[NSDictionary class]]){
            return [self decodeArrayOfPrimitives];
        }
        if([[innerDictionary allKeys] count] > 1){
            jsonArray = (NSArray *) [self topJsonObject];
        }
        
	}else{
        NSDictionary * innerDictionary = [self topJsonObject];
        key = [[innerDictionary allKeys] objectAtIndex:0];
        jsonArray = [innerDictionary objectForKey:key];
    }
    
    
	if (! jsonArray) return nil;
    
	if(![jsonArray isKindOfClass:[NSArray class]]){
		//the set has only one item
		jsonArray = [NSArray arrayWithObject:jsonArray];
	}
    
    NSString * objectClass = [self topJsonObjectId];
    if([self getClassForKey:objectClass] == nil){
        NSLog(@"Change arrays class from %@ to %@", objectClass, key);
        objectClass = key;
    }
    
	NSMutableArray *list = [NSMutableArray array];
	for (id jsonObject in jsonArray) {
		[self pushObject:jsonObject withId:objectClass];
		
		id object = [self decodeObject];
		
		[self pop];
		
		[list addObject:object];
	}
	return list;
}

- (NSArray *)decodeArrayOfPrimitives{
    NSArray * jsonArray = (NSArray *)[self topJsonObject];
    
    NSMutableArray *list = [NSMutableArray array];
	for (id jsonObject in jsonArray) {
		
		id object = [self decodeFoundationObject:jsonObject];
		
		[list addObject:object];
	}
	return list;
}

- (NSObject *)decodeFoundationObject:(id) object{
    if([object isKindOfClass:[NSNumber class]]){
		return object;
	}
    
    if([object isKindOfClass:[NSString class]]){
        NSString * stringValue = (NSString *) object;
        if([stringValue hasSuffix:@"="]){
            //NSData
            return [NSData dataFromBase64String:stringValue];
        }
        //check if this a date
        NSDateFormatter * dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm':00' z"];
        NSDate * date = [dateFormatter dateFromString:stringValue];
        if(date != nil) return date;
        
		return object;
	}
    return nil; //object is a user class
}
- (void)pushObject:(id)jsonObject withId:(NSString *)jsonObjectId {
	[jsonObjectStack addObject:jsonObject];
	[objectIDStack addObject:jsonObjectId];
}

- (void)pop {
	[jsonObjectStack removeLastObject];
	[objectIDStack removeLastObject];
}

- (NSDictionary *)topJsonObject {
	return [jsonObjectStack lastObject];
}
- (NSString *)topJsonObjectId {
	return [objectIDStack lastObject];
}
- (Class) getClassForKey:(NSString *) key{
	if([[mappingClasses allKeys] containsObject:key]){
		return [mappingClasses objectForKey:key];
	}
	return NSClassFromString([key capitalizeFirstLetterString]);
}

@end
