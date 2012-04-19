//
//  JSONDecoderTest.m
//  JSONCoding
//
//  Created by Noura Hassan on 4/19/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import "BaseTestCase.h"
#import "JSONDecoder.h"
#import "TestDomain.h"

@interface JSONDecoderTest : BaseTestCase{
    JSONDecoder * decoder;
}

@end

@implementation JSONDecoderTest

- (void) testDecoding{
    decoder = [[JSONDecoder alloc] initWithResponse:[SimpleJSON dataUsingEncoding:NSUTF8StringEncoding]];
    Employee * employee = [[Employee alloc] initWithCoder:decoder];
    assertThat(employee, notNilValue());
    assertThat(employee, hasProperty(@"name", @"Ann"));
    assertThat(employee, hasProperty(@"title", @"HR Manager"));    
    assertThat(employee, hasProperty(@"nationalID", [NSNumber numberWithDouble:12345678900008]));        
    assertThat([employee resume], notNilValue());

    NSString * resume = [[NSString alloc] initWithData:[employee resume] encoding:NSUTF8StringEncoding];
    assertThat(resume, is(@"employee resume ...."));
    
    assertThat(employee, hasProperty(@"dateOfBirth", [NSDate dateWithTimeIntervalSince1970:0]));
}

- (void) testCanDecodeSingleRelationship{
    decoder = [[JSONDecoder alloc] initWithResponse:[JSONForEmployeeWithManager dataUsingEncoding:NSUTF8StringEncoding]];
    Employee * employee = [[Employee alloc] initWithCoder:decoder];
    assertThat(employee, notNilValue());
    assertThat([employee manager], notNilValue());
    assertThat([employee manager], hasProperty(@"name", @"Joe"));
}

- (void) testCanDecodeOneToManyRelationship{
    decoder = [[JSONDecoder alloc] initWithResponse:[JSONForManagerWithEmployees dataUsingEncoding:NSUTF8StringEncoding]];
    [decoder addAlias:@"employees" forClass:[Employee class]];
    Manager * manager = [[Manager alloc] initWithCoder:decoder];    
    assertThat(manager, notNilValue());
    assertThat([manager employees], containsInAnyOrder(hasProperty(@"name", @"Ann"),
                                                       hasProperty(@"name", @"Nick"), nil));
}

- (void) testCanDecodeSetsOfPrimitives{
    decoder = [[JSONDecoder alloc] initWithResponse:[JSONForEmployeeWithSkills dataUsingEncoding:NSUTF8StringEncoding]];
    Employee * employee = [[Employee alloc] initWithCoder:decoder];
    assertThat(employee, notNilValue());
    assertThat([employee favoriteNumbers], containsInAnyOrder([NSNumber numberWithInt:10], [NSNumber numberWithInt:100], nil));
    assertThat([employee skills], containsInAnyOrder(@"XX", @"YY", nil));
}

- (void) testCanDecodeArrays{
    decoder = [[JSONDecoder alloc] initWithResponse:[JSONContainsArrayOfStrings dataUsingEncoding:NSUTF8StringEncoding]];
    Employee * employee = [[Employee alloc] initWithCoder:decoder];
    assertThat(employee, notNilValue());
    assertThat([employee workExperiences], contains(@"manager at xxxx", @"manager at yyyy", nil));
    
    decoder = [[JSONDecoder alloc] initWithResponse:[JSONContainsArrayOfDates dataUsingEncoding:NSUTF8StringEncoding]];
    Manager * manager = [[Manager alloc] initWithCoder:decoder];
    assertThat(manager, notNilValue());
    assertThat([manager nextMeetings], contains(hasProperty(@"description", startsWith(@"2012-04-20 00:05:00")), 
                                                hasProperty(@"description", startsWith(@"2012-04-20 03:05:00")), nil));
}

@end
