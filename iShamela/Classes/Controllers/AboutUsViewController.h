//
//  AboutUsViewController.h
//  iShamela
//
//  Created by Imran Bashir on 1/25/12.
//  Copyright (c) 2012 Aza Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController{
    
    UITextView *aboutUs;
    
    UITextField *aboutus;
    
}

@property (nonatomic, retain) IBOutlet UITextView *aboutUs;
@property (nonatomic, retain) IBOutlet UITextField *aboutus;

@end
