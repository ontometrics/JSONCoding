//
//  JSONEncoder.h
//  JSONCoding
//
//  Created by Noura Hassan on 4/18/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

// The encoder is used to get a JSON representation for any object. 
// The object should implement the NSCoding protocol, the encoder will be passed to the object then 
// caller should call the json method to get the JSON representation.

#import <Foundation/Foundation.h>

@interface JSONEncoder : NSCoder

+ (NSString*) JSONValueOfObject:(id)object;
+ (id)encoder;
- (NSString *) json;

//
// Allow caller to skip some properties in the encoded object. 
// suppress key: "id" from class "Person", will not add the person's id to the JSON representation. 
//
- (void)suppressKey:(NSString *)key forClass:(Class)aClass;
@end
