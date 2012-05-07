//
//  JSONDecoder.h
//  JSONCoding
//
//  Created by Noura Hassan on 4/19/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

// decode object from a JSON representation

#import <Foundation/Foundation.h>

@interface JSONDecoder : NSCoder

- (id) initWithResponse:(NSData *) response;
- (void) addAlias:(NSString *) alias forClass:(Class) aClass; 
@end
