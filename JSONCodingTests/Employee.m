//
//  Employee.m
//  JSONCoding
//
//  Created by Noura Hassan on 4/18/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import "Employee.h"
#import "Manager.h"

@implementation Employee

- (id)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
		self.title = [coder decodeObjectForKey:@"title"];
		self.resume = [coder decodeObjectForKey:@"resume"];        
		self.skills = [coder decodeObjectForKey:@"skills"];      
		self.workExperiences = [coder decodeObjectForKey:@"workExperiences"];              
		self.manager = [coder decodeObjectForKey:@"manager"];
		self.office = [coder decodeObjectForKey:@"office"];
 	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
	[coder encodeObject:self.title forKey:@"title"];    
	[coder encodeObject:self.resume forKey:@"resume"];
	[coder encodeObject:self.skills forKey:@"skills"];   
	[coder encodeObject:self.workExperiences forKey:@"workExperiences"];       
	[coder encodeObject:self.manager forKey:@"manager"];
	[coder encodeObject:self.office forKey:@"office"];
}

- (NSString *) description{
    return [NSString stringWithFormat:@"{title:%@, resume:%@, skills:%@, workExperience:%@, manager:%@, office:%@}", self.title, self.resume, self.skills, self.workExperiences, self.manager, self.office];
}
@end
