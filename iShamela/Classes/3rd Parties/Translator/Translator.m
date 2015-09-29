//
//  Translator.m
//  iShamela
//
//  Created by Suhendra Ahmad on 12/20/10.
//  Copyright 2010 ShadowPlay Studios. All rights reserved.
//

#import "Translator.h"
#import "LangData.h"
#import "JSON.h"

@implementation Translator

@synthesize text, fromLang, toLang, delegate, languages;

#pragma mark -
#pragma mark Connection Delegates


- (void)invokeDelegate:(NSDictionary *)data
{
	NSString *op = [data objectForKey:@"selector"];
	
	if ([op isEqualToString:@"failed"])
	{
		if (self.delegate)
		{
			if ([self.delegate respondsToSelector:@selector(translator:Failed:)])
			{
				[self.delegate translator:self Failed:@"200"];
			}
		}		
	}
	
	if ([op isEqualToString:@"success"])
	{
		NSString *message = [data objectForKey:@"message"];
		if (self.delegate)
		{
			if ([self.delegate respondsToSelector:@selector(translator:didFinishWithText:)])
			{
				[self.delegate translator:self didFinishWithText:message];
			}
		}
	}
	
	if ([op isEqualToString:@"error"])
	{
		NSError *error = [data objectForKey:@"error"];
		if (self.delegate)
		{
			if ([self.delegate respondsToSelector:@selector(translator:ConnectionError:)])
			{
				[self.delegate translator:self ConnectionError:error];
			}
		}		
	}
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[responseData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData setData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connection release];
	
	[self performSelectorOnMainThread:@selector(invokeDelegate:) 
						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:
									   @"error", @"selector",
									   error, @"error",
									   nil]
						waitUntilDone:NO];
	
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	
	NSString *responseString = [[[NSString alloc] initWithData: responseData encoding: NSUTF8StringEncoding] autorelease];
	[responseData release];
	
	NSMutableDictionary *luckyNumbers = [responseString JSONValue];
    NSLog(@"%@",luckyNumbers);
	if (luckyNumbers != nil) {
		
		NSDecimalNumber * responStatus = [luckyNumbers objectForKey: @"responseStatus"];
		if ([responStatus intValue] != 200) {
			NSLog(@"Translator: RESPONSE STATUS=200");
			
			[self performSelectorOnMainThread:@selector(invokeDelegate:) 
								   withObject:[NSDictionary dictionaryWithObjectsAndKeys:
											   @"failed-200", @"selector",
											   @"200", @"message",
											   nil] 
								waitUntilDone:NO];
			
			return;
		}
		
		NSMutableDictionary *responseDataDict = [luckyNumbers objectForKey: @"responseData"];
		if (responseDataDict != nil) {

			NSString *translatedText = [responseDataDict objectForKey: @"translatedText"];
			
			[self performSelectorOnMainThread:@selector(invokeDelegate:) 
								   withObject:[NSDictionary dictionaryWithObjectsAndKeys:
											   @"success", @"selector",
											   translatedText, @"message",
											   nil]
								waitUntilDone:NO];
		}
	}
	
}

#pragma mark -
#pragma mark Translator

- (void)doTranslate:(NSString *)translateText FromLang:(NSString *)from ToLang:(NSString *)to
{
	NSLog(@"%@",translateText);
	
	self.text = translateText;
	self.fromLang = from;
	self.toLang = to;
	
	responseData = [[NSMutableData data] retain];
	
	langString = [NSString stringWithFormat:@"%@|%@", self.fromLang, self.toLang];
	
	NSString *textEscaped = [translateText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    
	NSString *langStringEscaped = [langString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/language/translate?key=AIzaSyAP1exiSGJafeX20WbrDhzXM9HNM6ZUg_s&q=%@&v=1.0&langpair=%@",
                     textEscaped, langStringEscaped];

   // 
	NSLog(@"%@",url);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease] ;
		
}

- (NSInteger) indexOfLangCode:(NSString *)code
{
	NSInteger index = 0;

	for (LangData *lang in languages) {
		if ([lang.langCode isEqualToString:code])
		{
			index = [languages indexOfObject:lang];
			break;
		}
	}
	
	return index;
}

- (void)deselectAll
{
	for (LangData *lang in languages)
	{
		lang.selected = NO;
	}
}

- (LangData *)selectedLanguage
{
	for (LangData *lang in languages)
	{
		if (lang.selected)
		{
			return lang;
		}
	}
	
	return nil;
}

- (void) selectLanguage:(NSString *)code
{
	[self deselectAll];
	
	NSInteger index = [self indexOfLangCode:code];
	LangData *lang = [languages objectAtIndex:index];
	lang.selected = YES;
}

#pragma mark Memory

- (id)init
{
	if (self = [super init])
	{
		languages = [[NSMutableArray alloc] init];
		[languages addObject:[LangData langWithCode:@"id" LangText:@"Indonesia"]];
		[languages addObject:[LangData langWithCode:@"en" LangText:@"English"]];
        [languages addObject:[LangData langWithCode:@"da" LangText:@"Danish"]];
        [languages addObject:[LangData langWithCode:@"de" LangText:@"German"]];
        [languages addObject:[LangData langWithCode:@"sv" LangText:@"Swedish"]];
        [languages addObject:[LangData langWithCode:@"no" LangText:@"Norwegian"]];
		
		LangData *lang = [languages objectAtIndex:0];
		lang.selected = YES;
	}
	return self;
}

- (void) dealloc
{
	self.delegate = nil;
	[responseData release];
	[text release];
	[fromLang release];
	[toLang release];
	[langString release];
	[languages release];
	
	[super dealloc];
}

@end
