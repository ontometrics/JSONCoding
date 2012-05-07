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
- (NSObject *)decodeHibernateProxy;
- (NSDate *) decodeDate;
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
    
	id object = nil;
    if([[self topJsonObject] isKindOfClass:[NSDictionary class]] &&
       [[[self topJsonObject] allKeys] containsObject:@"@class"]){
        
        object = [self decodeHibernateProxy];
        
    }else if ([class isSubclassOfClass:[NSNull class]]) {
		
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

- (int)decodeIntForKey:(NSString *)key {
    //TODO check, if hibernate can send a wrong format
    NSDecimalNumber * value = [[self topJsonObject] objectForKey:key];
	return [value intValue];
}

- (double)decodeDoubleForKey:(NSString *)key {
	NSDecimalNumber *doubleStr = [[self topJsonObject] valueForKey:key];
	return [doubleStr doubleValue];
}

- (NSArray *)decodeArrayOfClass:(Class)class{
    NSDictionary * innerDictionary = nil;    

	if([[self topJsonObject] isKindOfClass:[NSArray class]]){
        innerDictionary = [(NSArray *)[self topJsonObject] objectAtIndex:0];
        
        if(![innerDictionary isKindOfClass:[NSDictionary class]]){
            return [self decodeArrayOfPrimitives];
        }
        if([[innerDictionary allKeys] count] > 1){
            innerDictionary = [NSDictionary dictionaryWithObject:[self topJsonObject] forKey:@"object"];
        }
        
	}else{
        innerDictionary = [self topJsonObject];
    }
    
    NSString * key = [[innerDictionary allKeys] objectAtIndex:0];
    NSArray * jsonArray = [innerDictionary objectForKey:key];
    
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
		if(object != nil){
            [list addObject:object];
        }
	}
	return list;
}

- (NSObject *)decodeHibernateProxy{
    Class class = nil;    
    id object = nil;
    if([[[self topJsonObject] allKeys] containsObject:@"@class"]){
        if([[[self topJsonObject] objectForKey:@"@class"] isEqualToString:@"set"]){
//TODO handle            
//            object = [self decodeSet];
            
        }else if ([[[self topJsonObject] objectForKey:@"@class"] isEqualToString:@"list"]){
//TODO handle                        
//            object = [self decodeList];
            
        }else if ([[[self topJsonObject] objectForKey:@"@class"] isEqualToString:@"sql-timestamp"] ||
                  [[[self topJsonObject] objectForKey:@"@class"] isEqualToString:@"sql-time"] ||
                  [[[self topJsonObject] objectForKey:@"@class"] isEqualToString:@"sql-date"]){
            
            return [self decodeDate];
        }
    }

    NSString * resolvesToClassName = [[self topJsonObject] objectForKey:@"@resolves-to"];
    class = [self getClassForKey:resolvesToClassName];
    if(class == nil){
        NSString * className = [[self topJsonObject] objectForKey:@"@class"];
        class = [self getClassForKey:className];
    }
    object = [[class alloc] initWithCoder:self];
    return object;
}

- (NSDate *) decodeDate{
	NSString *jsonString = [[self topJsonObject] objectForKey:@"$"];
	if (! jsonString) return nil;
	
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	//we receive time in GMT zone
	NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	[dateFormatter setTimeZone:gmt];
    
	if([[[self topJsonObject] objectForKey:@"@class"] isEqualToString:@"sql-timestamp"]){
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	}else if([[[self topJsonObject] objectForKey:@"@class"] isEqualToString:@"sql-date"]){
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];		
	}else{
		[dateFormatter setDateFormat:@"HH:mm:ss"];
	}
    
	int length = [jsonString length];
	if(length > 2 && [[jsonString substringFromIndex:(length - 2)] isEqualToString:@".0"]){
		jsonString = [jsonString substringToIndex:(length - 2)];
	}
    
	return [dateFormatter dateFromString:jsonString];
}


- (NSObject *)decodeFoundationObject:(id) object{
    if([object isKindOfClass:[NSNumber class]]){
		return object;
	}
    
    if([object isKindOfClass:[NSString class]]){
        NSString * stringValue = (NSString *) object;
        
        if(![stringValue length]) return nil;
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
