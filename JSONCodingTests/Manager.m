//
//  Manager.m
//  JSONCoding
//
//  Created by Noura Hassan on 4/18/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import "Manager.h"

@implementation Manager
@synthesize employees;
@synthesize nextMeetings;

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
		self.employees = [coder decodeObjectForKey:@"employees"];     
		self.nextMeetings = [coder decodeObjectForKey:@"nextMeetings"];             
 	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
	[coder encodeObject:self.employees forKey:@"employees"];   
	[coder encodeObject:self.nextMeetings forKey:@"nextMeetings"];       
}

- (void) addEmployee:(Employee *) employee{
    if(self.employees == nil){
        employees = [NSMutableSet new];
    }
    [(NSMutableSet *) employees addObject:employee];
    [employee setManager:self];
}

@end
