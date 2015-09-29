//
//  TermsConditionsViewConrtroller.h
//  iShamela
//
//  Created by Imran Bashir on 1/25/12.
//  Copyright (c) 2012 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsConditionsViewConrtroller : UIViewController{
    
    UITextView *termsConditions;
    
    UITextField *termsconditions;
    
    
}

@property (nonatomic, retain) IBOutlet UITextView *termsConditions;
@property (nonatomic, retain) IBOutlet UITextField *termsconditions;

@end
