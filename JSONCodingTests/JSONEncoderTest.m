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
    Employee * employee, *employee2; 
    Manager * manager;
    JSONEncoder * encoder;
    NSString * json;
}

- (void) setUp{
    [super setUp];
    employee = [Employee new];
    [employee setName:@"Ann"];
    [employee setNationalID:[NSNumber numberWithDouble:12345678900008]];
    [employee setTitle:@"HR Manager"];
    [employee setDateOfBirth:[NSDate dateWithTimeIntervalSince1970:0]];
    [employee setResume:[@"employee resume ...." dataUsingEncoding:NSUTF8StringEncoding]];
    
    employee2 = [Employee new];
    [employee2 setName:@"Nick"];
    [employee2 setNationalID:[NSNumber numberWithDouble:30045678900008]];
    [employee2 setDateOfBirth:[NSDate dateWithTimeIntervalSince1970:3600 * 24 * 365 * 15]];
    

    manager = [Manager new];
    [manager setName:@"Joe"];
    
}

- (void) testEncoding{
    //test encode superclass & subclass properties, and encoding NSData, NSDate
    encoder = [JSONEncoder encoder]; 
    [encoder encodeObject:employee];
    json = [encoder json];
    NSLog(@"JSON %@", json);

    assertThat(json, containsString(@"\"name\":\"Ann\""));
    assertThat(json, containsString(@"\"title\":\"HR Manager\""));    
    assertThat(json, containsString(@"\"nationalID\":12345678900008"));    
    assertThat(json, containsString(@"\"dateOfBirth\":\"1970-01-01 00:00:00 GMT\""));
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
    
    encoder = [JSONEncoder encoder]; 
    [encoder encodeObject:employee];
    NSString * jsonWithManager = [encoder json];
    NSLog(@"JSON With Manager %@", jsonWithManager);
    encoder = [JSONEncoder encoder]; 
    [encoder suppressKey:@"manager" forClass:[Employee class]];
    [encoder encodeObject:employee];
    NSString * jsonWithoutManager = [encoder json];
    
    assertThat(jsonWithManager, containsString(@"\"name\":\"Joe\""));
    assertThat(jsonWithoutManager, isNot(containsString(@"\"name\":\"Joe\"")));    
}

- (void) testCanEncodeSetsOfPrimitives{
    [employee setFavoriteNumbers:[NSSet setWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:100], nil]];    
    [employee setSkills:[NSSet setWithObjects:@"XX", @"YY", nil]];
    
    encoder = [JSONEncoder encoder]; 
    [encoder encodeObject:employee];
    json = [encoder json];
    NSLog(@"JSON w/ set of primitives %@", json);
    assertThat(json, anyOf(containsString(@"\"skills\":[\"XX\",\"YY\"]"), 
                           containsString(@"\"skills\":[\"YY\",\"XX\"]"), nil));    
    assertThat(json, anyOf(containsString(@"\"favoriteNumbers\":[10,100]"),
                           containsString(@"\"favoriteNumbers\":[100,10]"), nil));        
}

- (void) testCanEncodeArrays{
    [employee setWorkExperiences:[NSArray arrayWithObjects:@"manager at xxxx", @"manager at yyyy", nil]];    
    
    encoder = [JSONEncoder encoder]; 
    [encoder encodeObject:employee];
    json = [encoder json];
    //this should be sorted
    assertThat(json, containsString(@"\"workExperiences\":[\"manager at xxxx\",\"manager at yyyy\"]"));
    NSLog(@"JSON %@", json);
    NSDate * date1 = [NSDate dateWithTimeIntervalSinceNow:3600];
    NSDate * date2 = [NSDate dateWithTimeIntervalSinceNow:3600 * 4];    
    [manager setNextMeetings:[NSArray arrayWithObjects:date1, date2, nil ]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm':00' z";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];

    encoder = [JSONEncoder encoder]; 
    [encoder encodeObject:manager];
    json = [encoder json];
    NSLog(@"JSON %@", json);
    assertThat(json, containsString([NSString stringWithFormat:@"\"nextMeetings\":[\"%@\",\"%@\"]", [dateFormatter stringFromDate:date1], [dateFormatter stringFromDate:date2]]));
}

- (void) testCircularReferenceNotAllowed{
    [manager addEmployee:employee];
    [manager addEmployee:employee2];
    
    encoder = [JSONEncoder encoder]; 
    @try {
        [encoder encodeObject:manager];
        assertThat(One, is(Two));        
    }
    @catch (NSException *exception) {
        assertThat([exception name], containsString(@"Circular Reference"));
    }

    encoder = [JSONEncoder encoder];
    [encoder suppressKey:@"manager" forClass:[Employee class]];
    [encoder encodeObject:manager];
    
    json = [encoder json];
    NSLog(@"JSON %@", json);
    
    assertThat(json, containsString(@"\"name\":\"Ann\""));
    assertThat(json, containsString(@"\"name\":\"Joe\""));    
    assertThat(json, containsString(@"\"name\":\"Nick\""));        
}

@end
