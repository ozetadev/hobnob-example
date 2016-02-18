//
//  HBEntryViewController.h
//  hobnob
//
//  Created by Philip Bernstein on 2/17/16.
//  Copyright © 2016 Philip Bernstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBDatePicker.h"
#import "HBPreviewViewController.h" // just for passing off information
/*
    User input controller, passes off data to he rendered
 */

@interface HBEntryViewController : UIViewController <HBDatePickerDelegate>
{
    // user input
    IBOutlet UITextField *whereField;
    IBOutlet UITextField *whatField;
    IBOutlet HBDatePicker *datePicker;
    IBOutlet HBDatePicker *endPicker;
    
    // date input output
    IBOutlet UILabel *whenLabel;
    
    IBOutlet UIView *inputView;
    
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *endButton;
    IBOutlet UIButton *nextButton;
    
    NSDate *startDate;
    NSDate *endDate;
    
    IBOutlet UILabel *startLabel;
    IBOutlet UILabel *endLabel;
}

-(IBAction)pickStartDate:(id)sender;
-(IBAction)pickEndDate:(id)sender;
-(IBAction)previewInvite:(id)sender;

-(void)processStartDate:(NSDate *)date;
-(void)processEndDate:(NSDate *)date;
@end
