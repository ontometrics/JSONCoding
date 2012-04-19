//
//  JSONEncoder.h
//  JSONCoding
//
//  Created by Noura Hassan on 4/18/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONEncoder : NSCoder

+ (id)encoder;
- (NSString *) json;
- (void)suppressKey:(NSString *)key forClass:(Class)aClass;
@end
