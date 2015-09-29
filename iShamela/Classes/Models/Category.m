//
//  Category.m
//  iShamela
//
//  Created by Suhendra Ahmad on 4/6/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import "Category.h"


@implementation Category

@synthesize categoryId, categoryOrder, categoryLevel, categoryName, selected;

+ (Category *)categoryWithId:(NSString *)_categoryId catOrd:(NSString *)_categoryOrder level:(NSString *)_categoryLevel name:(NSString *)_catoryName;
{
    Category *category = [[[Category alloc] init] autorelease];
    
    category.categoryId = _categoryId;
    category.categoryOrder = _categoryOrder;
    category.categoryLevel = _categoryLevel;
    category.categoryName= _catoryName;
    
    return category;
}

@end
