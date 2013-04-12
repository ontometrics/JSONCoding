//
//  CodingTest.m
//  JSONCoding
//
//  Created by Noura on 4/12/13.
//  Copyright (c) 2013 Ontometrics. All rights reserved.
//

#import "BaseTestCase.h"
#import "TestDomain.h"
#import "JSONEncoder.h"
#import "JSONDecoder.h"
#import "NSData+Base64.h"

@interface CodingTest : BaseTestCase

@end

@implementation CodingTest{
    Employee * employee;
}

- (void) setUp{
    [super setUp];
    employee = [Employee new];
    [employee setName:@"Ann"];
    [employee setNationalID:[NSNumber numberWithDouble:12345678900008]];
    [employee setTitle:@"HR Manager"];
    [employee setDateOfBirth:[NSDate dateWithTimeIntervalSince1970:0]];
    [employee setResume:[@"employee resume ...." dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void) testCanDecodeAndEncode{
    NSString * json = [JSONEncoder JSONValueOfObject:employee];
    assertThat(json, notNilValue());
    
    Employee * decodedEmployee  = [JSONDecoder decodeWithData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    
    assertThat(decodedEmployee.name, is(employee.name));
    assertThat(decodedEmployee.nationalID, is(employee.nationalID));
    assertThat(decodedEmployee.title, is(employee.title));
    assertThat(decodedEmployee.dateOfBirth, is(employee.dateOfBirth));
    assertThat(decodedEmployee.resume, is(employee.resume));
}

@end
