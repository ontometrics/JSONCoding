//
//  NSString+Additions.m
//  dishapedia
//
//  Created by Noura Hassan on 7/2/10.
//  Copyright 2010 Ontometrics. All rights reserved.
//

#import "NSString+Additions.h"


@implementation NSString(Additions)
- (NSString *)camelcaseString {
	NSString *firstChar = [[self substringToIndex:1] lowercaseString];
	return [self stringByReplacingCharactersInRange:(NSRange){.location=0, .length=1} withString:firstChar];
}
-(NSString *)capitalizeFirstLetterString{
	NSString *firstChar = [[self substringToIndex:1] capitalizedString];
	return [self stringByReplacingCharactersInRange:(NSRange){.location=0, .length=1} withString:firstChar];
}
@end
