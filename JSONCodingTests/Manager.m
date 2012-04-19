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

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
		self.employees = [coder decodeObjectForKey:@"employees"];     
 	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
	[coder encodeObject:self.employees forKey:@"employees"];    
}

@end
