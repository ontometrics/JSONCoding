//
//  Employee.h
//  JSONCoding
//
//  Created by Noura Hassan on 4/18/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import "Person.h"

@class Manager;

@interface Employee : Person

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSData * resume;
@property (nonatomic, strong) NSSet * skills;
@property (nonatomic, strong) NSArray * workExperiences;
@property (nonatomic, strong) Manager * manager;
@end
