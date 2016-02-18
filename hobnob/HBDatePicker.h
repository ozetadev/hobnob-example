//
//  HBDatePicker.h
//  hobnob
//
//  Created by Philip Bernstein on 2/17/16.
//  Copyright © 2016 Philip Bernstein. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HBDatePickerDelegate
-(void)datePickerEndedWithDate:(NSDate *)date;
-(void)datePickerCancelled;
@end
@interface HBDatePicker : UIView
{
    UIView *topBar;
    UIView *topLine;
}

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, weak) id<HBDatePickerDelegate> delegate;
@property (nonatomic) BOOL isStartDate;
@end
