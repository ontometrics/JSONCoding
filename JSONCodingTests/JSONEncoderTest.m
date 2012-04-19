//
//  JSONEncoderTest.m
//  JSONCoding
//
//  Created by Noura Hassan on 4/18/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import "BaseTestCase.h"
#import "TestDomain.h"
#import "JSONEncoder.h"
#import "NSData+Base64.h"
#import "Manager.h"

@interface JSONEncoderTest : BaseTestCase

@end

@implementation JSONEncoderTest{
    Employee * employee; 
    Manager * manager;
    NSString * json;
}

- (void) setUp{
    [super setUp];
    employee = [Employee new];
    [employee setName:@"Ann"];
    [employee setNationalID:[NSNumber numberWithDouble:12345678900008]];
    [employee setTitle:@"HR Manager"];
    [employee setDateOfBirth:[NSDate dateWithTimeIntervalSince1970:0]];
    [employee setResume:[[NSString stringWithString:@"employee resume ...."] dataUsingEncoding:NSUTF8StringEncoding]];
    
    manager = [Manager new];
    [manager setName:@"Joe"];
    
    JSONEncoder * encoder = [JSONEncoder encoder]; 
    [encoder encodeObject:employee];
    json = [encoder json];
    NSLog(@"JSON %@", json);
}

- (void) testSuperClassEncoded{
    assertThat(json, containsString(@"\"name\":\"Ann\""));
}

- (void) testSubClassEncoded{
    assertThat(json, containsString(@"\"title\":\"HR Manager\""));
}

- (void) testNumberEncoded{
    assertThat(json, containsString(@"\"nationalID\":12345678900008"));
}

- (void) testDateEncoded{
    assertThat(json, containsString(@"\"dateOfBirth\":\"1970-01-01 00:00:00 GMT\""));
}

- (void) testDataEncoded{
    assertThat(json, containsString(@"\"resume\":"));
    NSRange range = [json rangeOfString:@"resume\":\""];
    if(range.length > 0){
        NSString * dataString = [json substringFromIndex:(range.location + range.length)];
        dataString = [dataString substringToIndex:[dataString rangeOfString:@"\""].location];
        NSData * data = [NSData dataFromBase64String:dataString];
        NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        assertThat(result, is(@"employee resume ...."));
    }
                         
}

- (void) testCanSuppressKeys{
    [employee setManager:manager];
    
    JSONEncoder * encoder = [JSONEncoder encoder]; 
    [encoder encodeObject:employee];
    NSString * jsonWithManager = [encoder json];
    
    encoder = [JSONEncoder encoder]; 
    [encoder suppressKey:@"manager" forClass:[Employee class]];
    [encoder encodeObject:employee];
    NSString * jsonWithoutManager = [encoder json];
    
    assertThat(jsonWithManager, containsString(@"\"name\":\"Joe\""));
    assertThat(jsonWithoutManager, isNot(containsString(@"\"name\":\"Joe\"")));    
}

@end
