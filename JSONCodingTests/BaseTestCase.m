//
//  BaseTestCase.m
//  dishapedia
//
//  Created by Rob Williams on 10/10/10.
//  Copyright 2010 Ontometrics. All rights reserved.
//

#import "BaseTestCase.h"

/**
 * Just sets up constants used to keep assertions clean.
 */
@implementation BaseTestCase

@synthesize Zero, One, Two, Three, Four, Five, Six;

-(void)setUp {
	self.Zero = [NSNumber numberWithInt:0];
	self.One = [NSNumber numberWithInt:1];
	self.Two = [NSNumber numberWithInt:2];
	self.Three = [NSNumber numberWithInt:3];
	self.Four = [NSNumber numberWithInt:4];
	self.Five = [NSNumber numberWithInt:5];
	self.Six = [NSNumber numberWithInt:6];
}

@end
