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
    IBOutlet UITextField *whereField; // input for location
    IBOutlet UITextField *whatField; // input for event title
    IBOutlet UILabel *startLabel; // display of start date
    IBOutlet UILabel *endLabel; // display of end date

    // date input
    IBOutlet HBDatePicker *datePicker;
    IBOutlet HBDatePicker *endPicker;
    
    // date input output
    IBOutlet UIView *inputView;
    
    // action-specific objects
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *endButton;
    IBOutlet UIButton *nextButton;
    
    // dates stored in the heap until we need them
    NSDate *startDate;
    NSDate *endDate;
    
   
}

// methods for triggering actions
-(IBAction)pickStartDate:(id)sender;
-(IBAction)pickEndDate:(id)sender;
-(IBAction)previewInvite:(id)sender;

// helper methods involving date and time
-(void)processStartDate:(NSDate *)date;
-(void)processEndDate:(NSDate *)date;
@end
