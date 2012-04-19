//
//  BaseTestCase.h
//  dishapedia
//
//  Created by Rob Williams on 10/10/10.
//  Copyright 2010 Ontometrics. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <SenTestingKit/SenTestingKit.h>
#import "TestConstants.h"

/**
 * Just provides constants to keep asserts clean.
 */
@interface BaseTestCase : SenTestCase {
	
	NSNumber *Zero, *One, *Two, *Three, *Four, *Five, *Six;

}

@property(nonatomic, retain) NSNumber *Zero;
@property(nonatomic, retain) NSNumber *One;
@property(nonatomic, retain) NSNumber *Two;
@property(nonatomic, retain) NSNumber *Three;
@property(nonatomic, retain) NSNumber *Four;
@property(nonatomic, retain) NSNumber *Five;
@property(nonatomic, retain) NSNumber *Six;

-(void)setUp;

@end
