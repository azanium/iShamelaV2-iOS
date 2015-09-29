//
//  NSDictionary+Extensions.m
//  Molecule War
//
//  Created by Suhendra Ahmad on 2/8/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "NSDictionary+Extensions.h"


@implementation NSDictionary (Extensions)

- (float)floatForKey:(NSString *)key
{
	NSNumber *number = [self valueForKey:key];
	
	return [number floatValue];
}

- (int)intForKey:(NSString *)key
{
	NSNumber *number = [self valueForKey:key];
	
	return [number intValue];
}

- (BOOL)boolForKey:(NSString *)key
{
	return [[self valueForKey:key] boolValue];
}

@end
