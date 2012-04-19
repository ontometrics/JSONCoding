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

- (NSObject *) getEncodingFor:(NSObject *) object;
- (NSObject *) getEncodingForDate:(NSDate *)date;
- (NSObject *) getEncodingForArray:(NSArray *)array;
@end
    
@implementation JSONEncoder{
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
    if([object isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([object isKindOfClass:[NSNumber class]]) {
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

- (NSObject *) getEncodingFor:(id) object{
    if([objectStack containsObject:object]){
        [NSException raise:@"Circular Reference Not Allowed" format:@"Found circular reference for %@ ", object];
    }

    if([self isValidJSONObject:object]){
        return object;   
    }else{
        if ([object isKindOfClass:[NSData class]]) {
            return [(NSData *) object base64EncodedString];
        }else if ([object isKindOfClass:[NSSet class]]) {
            return [self getEncodingForArray:[(NSSet *) object allObjects]];
            
        }else if ([object isKindOfClass:[NSArray class]]) {
            return [self getEncodingForArray:(NSArray *) object];
            
        }else if([object isKindOfClass:[NSDate class]]){
            return [self getEncodingForDate:(NSDate *) object];
        }else{
            [self push:object];
            [object encodeWithCoder:self];
            
            NSDictionary * objectEncoding = [self topObject];
            
            [self pop];
            
            return objectEncoding;
        }
	}

}

- (NSObject *) getEncodingForDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm':00' z";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    return [dateFormatter stringFromDate:date];

}

- (NSObject *) getEncodingForArray:(NSArray *)arrayObject{
	if (![arrayObject count]) {
		return nil;
	}else{
        [self push:arrayObject];
        
        NSMutableArray * array = [NSMutableArray new];
        for (id object in arrayObject) {
            NSObject *objectEncoding = [self getEncodingFor:object];
            if(objectEncoding){
                [array addObject:objectEncoding];
            }
		}
        
        [self pop];
        
        return array;
	}
}

- (void)encodeObject:(id)object forKey:(NSString *)key {
	if(!object || [self isKeySuppressed:key forClass:[self topObjectClass]])
		return;
    
    NSObject *objectEncoding = [self getEncodingFor:object];
    if(objectEncoding){
        [[self topObject] setObject:objectEncoding forKey:key];
    }
    NSLog(@"stack %@", jsonObjectStack);
}

@end
