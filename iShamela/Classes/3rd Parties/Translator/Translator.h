//
//  Translator.h
//  iShamela
//
//  Created by Suhendra Ahmad on 12/20/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Translator;
@class LangData;

@protocol TranslatorDelegate <NSObject>

@optional
- (void)translator:(Translator *)sender ConnectionError:(NSError *)error;
- (void)translator:(Translator *)sender Failed:(NSString *)message;
- (void)translator:(Translator *)sender didFinishWithText:(NSString *)result;

@end


@interface Translator : NSObject {
	id <TranslatorDelegate> delegate;
	
	NSMutableData *responseData;
	NSString *text;
	NSString *fromLang;
	NSString *toLang;
	
	NSString *langString;
	
	NSMutableArray *languages;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *fromLang;
@property (nonatomic, copy) NSString *toLang;
@property (nonatomic, retain) id <TranslatorDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *languages;

- (void)doTranslate:(NSString *)translateText FromLang:(NSString *)from ToLang:(NSString *)to;
- (NSInteger)indexOfLangCode:(NSString *)code;
- (void)deselectAll;
- (LangData *)selectedLanguage;
- (void)selectLanguage:(NSString *)code;

@end
