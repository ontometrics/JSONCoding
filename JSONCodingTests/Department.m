//
//  Department.m
//  JSONCoding
//
//  Created by Noura on 6/10/13.
//  Copyright (c) 2013 Ontometrics. All rights reserved.
//

#import "Department.h"

@implementation Department

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super init])) {
		self.name = [coder decodeObjectForKey:@"name"];
 	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.name forKey:@"name"];
}

@end
