//
//  BookmarkNameController.h
//  iShamela
//
//  Created by Imran Bashir on 1/7/12.
//  Copyright (c) 2012 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookContent.h"
#import "BookInfo.h"
#import "TOC.h"
#import "DbManager.h"
#import "Translator.h"
#import "LangData.h"
#import "BookMark.h"

@interface BookmarkNameController : UIViewController < UITextViewDelegate>{
    
    UITextView *bMarkName;
    UITextView *bMarkDescription;
    
    UITextField *bmarkName;
    UITextField *bmarkDescription;
    
    UIButton *okButton;
    UIButton *cancelButton;
    
    NSMutableDictionary *bookMark;
    DbManager *db;
    NSMutableString *desc;
    NSString *editBookMark;

}


@property (nonatomic, retain) IBOutlet UITextView *bMarkName;
@property (nonatomic, retain) IBOutlet UITextView *bMarkDescription;
@property (nonatomic, retain) IBOutlet UITextField *bmarkName;
@property (nonatomic, retain) IBOutlet UITextField *bmarkDescription;
@property (nonatomic, retain) IBOutlet UIButton *okButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) NSMutableString *desc;
@property (nonatomic, retain) NSString *editBookMark;


@property(nonatomic, retain) NSMutableDictionary *bookMark;
-(void) okButtonPressed;
-(void)cancelButtonPressed;
-(IBAction)bkTouched:(id)sender;
@end