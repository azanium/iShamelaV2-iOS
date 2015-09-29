//
//  NSDictionary+Extensions.h
//  Molecule War
//
//  Created by Suhendra Ahmad on 2/8/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (Extensions)

- (float)floatForKey:(NSString *)key;
- (int)intForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;

@end
