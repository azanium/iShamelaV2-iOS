//
//  ShUtils.m
//  iShamela
//
//  Created by Suhendra Ahmad on 4/7/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "ShUtils.h"


@implementation ShUtils


+ (bool)boolForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)setBool:(bool)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value 
                                            forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)stringForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setString:(NSString *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)intForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)setInt:(int)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)dictionaryForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    return (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:key];    
}

+ (void)setDictionary:(NSDictionary *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)arrayForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    return (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setArray:(NSArray *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
