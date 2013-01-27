//
//  TestDomain.h
//  JSONCoding
//
//  Created by Noura Hassan on 4/18/12.
//  Copyright (c) 2012 Ontometrics. All rights reserved.
//

#import "Person.h"
#import "Employee.h"
#import "Manager.h"

#ifndef EmptyArrayJSON
#define EmptyArrayJSON @"{\"E\":0,\"D\":\"{\"emptyArray\":[]}\"}"
#endif

#ifndef SimpleJSON
#define SimpleJSON @"{\"nationalID\":12345678900008,\"name\":\"Ann\",\"title\":\"HR Manager\",\"resume\":\"ZW1wbG95ZWUgcmVzdW1lIC4uLi4=\",\"dateOfBirth\":\"1970-01-01 00:00:00 GMT\"}"
#endif

#ifndef JSONForEmployeeWithManager
#define JSONForEmployeeWithManager @"{\"nationalID\":12345678900008,\"name\":\"Ann\",\"title\":\"HR Manager\",\"resume\":\"ZW1wbG95ZWUgcmVzdW1lIC4uLi4=\",\"dateOfBirth\":\"1970-01-01 00:00:00 GMT\",\"manager\":{\"nationalID\":0,\"name\":\"Joe\"}}"
#endif

#ifndef JSONForEmployeeWithSkills
#define JSONForEmployeeWithSkills @"{\"dateOfBirth\":\"1970-01-01 00:00:00 GMT\",\"name\":\"Ann\",\"favoriteNumbers\":[100,10],\"resume\":\"ZW1wbG95ZWUgcmVzdW1lIC4uLi4=\",\"skills\":[\"XX\",\"YY\"],\"nationalID\":12345678900008,\"title\":\"HR Manager\"}"
#endif

#ifndef JSONContainsArrayOfStrings
#define JSONContainsArrayOfStrings @"{\"nationalID\":12345678900008,\"name\":\"Ann\",\"title\":\"HR Manager\",\"resume\":\"ZW1wbG95ZWUgcmVzdW1lIC4uLi4=\",\"dateOfBirth\":\"1970-01-01 00:00:00 GMT\",\"workExperiences\":[\"manager at xxxx\",\"manager at yyyy\"]}"
#endif

#ifndef JSONContainsArrayOfDates
#define JSONContainsArrayOfDates @"{\"name\":\"Joe\",\"nextMeetings\":[\"2012-04-20 00:05:00 GMT\",\"2012-04-20 03:05:00 GMT\"]}"
#endif

#ifndef JSONForManagerWithEmployees
#define JSONForManagerWithEmployees @"{\"name\":\"Joe\",\"employees\":[{\"nationalID\":12345678900008,\"name\":\"Ann\",\"title\":\"HR Manager\",\"resume\":\"ZW1wbG95ZWUgcmVzdW1lIC4uLi4=\",\"dateOfBirth\":\"1970-01-01 00:00:00 GMT\"},{\"nationalID\":30045678900008,\"name\":\"Nick\",\"dateOfBirth\":\"1984-12-28 00:00:00 GMT\"}]}"
#endif

#ifndef JSONForManagerWithEmployeesWithClass
#define JSONForManagerWithEmployeesWithClass @"{\"name\":\"Joe\",\"employees\":[{\"employee\":[{\"nationalID\":12345678900008,\"name\":\"Ann\",\"title\":\"HR Manager\",\"resume\":\"ZW1wbG95ZWUgcmVzdW1lIC4uLi4=\",\"dateOfBirth\":\"1970-01-01 00:00:00 GMT\"},{\"nationalID\":30045678900008,\"name\":\"Nick\",\"dateOfBirth\":\"1984-12-28 00:00:00 GMT\"}]}]}"
#endif

#ifndef JSONContainsHibernateDate
#define JSONContainsHibernateDate @"{\"name\":\"Ann\",\"dateOfBirth\":{\"@class\":\"sql-timestamp\",\"$\":\"1970-01-01 00:00:00\"}}"
#endif

#ifndef JSONContainsHibernateProxy
#define JSONContainsHibernateProxy @"{\"@class\":\"whatever_$$_javassist_58\",\"@resolves-to\":\"person\",\"name\":\"Ann\"}"
#endif

#ifndef JSONContainsEmptyList
#define JSONContainsEmptyList @"{\"list\":[]}"
#endif


#ifndef JSONContainsListOfStrings
#define JSONContainsListOfStrings @"{\"list\":[{\"string\":\"XXX\"}]}"
#endif

#ifndef JSONContainsListOfStrings2
#define JSONContainsListOfStrings2 @"{\"list\":[{\"string\":[\"XXX\", \"YYY\", \"ZZZ\"]}]}"
#endif

#ifndef JSONContainsListOfDictionaries
#define JSONContainsListOfDictionaries @"{\"list\":[{\"id\":30},{\"id\":\"asd\"},{\"id\":40,\"name\":\"Joe\"}]}"
#endif


