//
//  NSString+Additions.m
//  Additions
//
//  Created by Noura Hassan on 7/2/10.
//  Copyright 2010 Ontometrics. All rights reserved.
//

#import "NSString+Additions.h"


@implementation NSString(Additions)

//
//return the string after converting first letter to lower case
//
- (NSString *)camelcaseString {
	NSString *firstChar = [[self substringToIndex:1] lowercaseString];
	return [self stringByReplacingCharactersInRange:(NSRange){.location=0, .length=1} withString:firstChar];
}

//
//return the string after converting first letter to upper case
//
-(NSString *)capitalizeFirstLetterString{
	NSString *firstChar = [[self substringToIndex:1] capitalizedString];
	return [self stringByReplacingCharactersInRange:(NSRange){.location=0, .length=1} withString:firstChar];
}
@end
