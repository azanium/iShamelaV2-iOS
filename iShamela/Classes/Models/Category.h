//
//  Category.h
//  iShamela
//
//  Created by Suhendra Ahmad on 4/6/11.
//  Copyright 2011 Aza Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Category : NSObject {
    NSString *catoryName;
    NSString *categoryId;
    NSString *categoryOrder;
	NSString *categoryLevel;
	BOOL selected;
}

@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *categoryOrder;
@property (nonatomic, copy) NSString *categoryLevel;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, assign) BOOL selected;

+ (Category *)categoryWithId:(NSString *)_categoryId catOrd:(NSString *)_categoryOrder level:(NSString *)_categoryLevel name:(NSString *)_catoryName;

@end
