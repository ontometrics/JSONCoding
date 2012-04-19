//
//  Person.h
//  JSONCoding
//
//  Created by Noura Hassan on 4/18/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

@property(nonatomic, strong) NSString * name;
@property(nonatomic, strong) NSDate * dateOfBirth;
@property(nonatomic, strong) NSNumber * nationalID;

@end
