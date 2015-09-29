//
//  FeedbackViewController.h
//  iShamela
//
//  Created by Imran Bashir on 1/10/12.
//  Copyright (c) 2012 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface FeedbackViewController : UIViewController<UIAlertViewDelegate>
{
    UITextView *feedBackTitle;
    UITextView *feedBackNote;

    UITextField *fBackTitle;
    UITextField *fBackNote;

    UIButton *okButton;
    UIButton *cancelButton;
    NSMutableDictionary *feedBack;
    ASIFormDataRequest *request;
    BOOL questionSend;
    
}

@property (nonatomic, retain) IBOutlet UITextView *feedBackTitle;
@property (nonatomic, retain) IBOutlet UITextView *feedBackNote;
@property (nonatomic, retain) IBOutlet UITextField *fBackTitle;
@property (nonatomic, retain) IBOutlet UITextField *fBackNote;
@property (nonatomic, retain) IBOutlet UIButton *okButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) NSMutableDictionary *feedBack;

-(void) okButtonPressed;
-(void)cancelButtonPressed;
-(IBAction)bkTouched:(id)sender;
@end
