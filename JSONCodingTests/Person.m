//
//  Person.m
//  JSONCoding
//
//  Created by Noura Hassan on 4/18/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super init])) {
        
		self.name = [coder decodeObjectForKey:@"name"];
        self.dateOfBirth = [coder decodeObjectForKey:@"dateOfBirth"];
		self.nationalID = [NSNumber numberWithDouble:[coder decodeDoubleForKey:@"nationalID"]];
        self.favoriteNumbers = [coder decodeObjectForKey:@"favoriteNumbers"];        
 	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.dateOfBirth forKey:@"dateOfBirth"];
	[coder encodeDouble:[self.nationalID doubleValue] forKey:@"nationalID"];
    [coder encodeObject:self.favoriteNumbers forKey:@"favoriteNumbers"];
}


@end
