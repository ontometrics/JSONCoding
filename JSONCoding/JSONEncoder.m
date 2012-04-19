//
//  JSONEncoder.m
//  JSONCoding
//
//  Created by Noura Hassan on 4/18/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import "JSONEncoder.h"
#import "NSData+Base64.h"

@interface JSONEncoder ()
    
- (void)push:(id)object;
- (void)pop;
- (Class)topObjectClass;
- (NSMutableDictionary *)topObject;
- (BOOL)isValidJSONObject:(NSObject *) object;
- (BOOL)isKeySuppressed:(NSString *)key forClass:(Class)class;
- (void)setObject:(NSObject *) object forKey:(NSString *) key;

- (void)encodeData:(NSData *)data forKey:(NSString *)key;
- (void)encodeDate:(NSDate *)date forKey:(NSString *)key;
@end
    
@implementation JSONEncoder{
    NSMutableSet*			encounteredObjects;
    NSMutableArray*			objectStack;
    NSMutableArray*			jsonObjectStack;    
    NSMutableDictionary*	suppressedKeys;
    NSDictionary * finalJSONObject;

}

+ (id)encoder {
	return [JSONEncoder new];
}

- (NSString *) json{
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:finalJSONObject
                                                    options:0 //0 for compressed 
                                                      error:&error];
    if(!error){
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];   
    }
    
    return nil;
}

- (id)init {
	if ((self = [super init])) {
		encounteredObjects = [NSMutableSet new];
		objectStack = [NSMutableArray new];
		suppressedKeys = [NSMutableDictionary new];
		
        jsonObjectStack = [NSMutableArray new];
	}
	
	return self;
}

- (void)suppressKey:(NSString *)key forClass:(Class)aClass{
	NSMutableSet *classSet = [suppressedKeys objectForKey:aClass];
	if (! classSet) {
		classSet = [NSMutableSet new];
		[suppressedKeys setObject:classSet forKey:aClass];
	}
	[classSet addObject:key];
}

- (BOOL)allowsKeyedCoding {
	return YES;
}

- (void)push:(id)object {
	[objectStack addObject:object];
    [jsonObjectStack addObject:[NSMutableDictionary new]];
}

- (void)pop {
	[objectStack removeLastObject];
	[jsonObjectStack removeLastObject];    
}

- (Class)topObjectClass {
	return [[objectStack lastObject] class];
}

- (NSMutableDictionary *)topObject{
    return [jsonObjectStack lastObject];
}

- (BOOL)isValidJSONObject:(NSObject *) object{
    //this will check top level is array or dictionary and inner objects are valid types
    if([NSJSONSerialization isValidJSONObject:object]){
        return YES;
    }
    if ([object isKindOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isKeySuppressed:(NSString *)key forClass:(Class)class {
	NSSet *classSet = [suppressedKeys objectForKey:class];
	return classSet ? [classSet containsObject:key] : NO;
}

- (void)setObject:(NSObject *) object forKey:(NSString *) key{
    if ([self isKeySuppressed:key forClass:[self topObjectClass]])
		return;
    
    [[self topObject] setObject:object forKey:key];    
}

- (void)encodeObject:(id)object {
    [encounteredObjects addObject:object];
	
    [self push:object];
    [object encodeWithCoder:self];
    
    finalJSONObject = [self topObject];
    [self pop];
}

- (void)encodeBool:(BOOL)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

- (void)encodeDouble:(double)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithDouble:value] forKey:key];    
}

- (void)encodeInt:(int)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (void)encodeInt64:(int64_t)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithLong:value] forKey:key];    
}

- (void)encodeObject:(id)object forKey:(NSString *)key {
	if(!object || [self isKeySuppressed:key forClass:[self topObjectClass]])
		return;
    if([self isValidJSONObject:object]){
        [self setObject:object forKey:key];   
    }else{ //TODO NSSet
        NSLog(@"%@ class not valid", [object class]);
        if ([object isKindOfClass:[NSData class]]) {
            [self encodeData:object forKey:key];
        }else if ([object isKindOfClass:[NSSet class]]) {
        }else if([object isKindOfClass:[NSDate class]]){
            [self encodeDate:(NSDate *)object forKey:key];
        }else{
            [encounteredObjects addObject:object];
                
            [self push:object];
            [object encodeWithCoder:self];
            
            NSDictionary * objectEncoding = [self topObject];
            
            [self pop];
            
            [[self topObject] setObject:objectEncoding forKey:key];
        }
	}
   // NSLog(@"jsonStack %@", jsonObjectStack);
}

- (void)encodeData:(NSData *)data forKey:(NSString *)key {
	if(data){
        [self setObject:[data base64EncodedString] forKey:key];
	}
}

- (void)encodeDate:(NSDate *)date forKey:(NSString *)key{
	if (date != nil) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm':00' z";
		
		NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
		[dateFormatter setTimeZone:gmt];
		[self setObject:[dateFormatter stringFromDate:date] forKey:key];
	}
}

@end
