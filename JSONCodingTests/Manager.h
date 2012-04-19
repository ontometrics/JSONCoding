//
//  Manager.h
//  JSONCoding
//
//  Created by Noura Hassan on 4/18/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import "Employee.h"

@interface Manager : Employee

@property (nonatomic, strong) NSSet * employees;
@property (nonatomic, strong) NSArray * nextMeetings; //array of dates

- (void) addEmployee:(Employee *) employee;
@end
