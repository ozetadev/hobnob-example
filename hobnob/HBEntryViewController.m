//
//  HBEntryViewController.m
//  hobnob
//
//  Created by Philip Bernstein on 2/17/16.
//  Copyright © 2016 Philip Bernstein. All rights reserved.
//

#import "HBEntryViewController.h"

@interface HBEntryViewController ()

@end

@implementation HBEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = TRUE;
    
    inputView.layer.cornerRadius = 8.0;
    startButton.layer.cornerRadius = 4.0;
    endButton.layer.cornerRadius = 4.0;
    nextButton.layer.cornerRadius = 4.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(IBAction)pickStartDate:(id)sender {
    datePicker = [[HBDatePicker alloc] init];
    datePicker.isStartDate = TRUE;
    datePicker.delegate = self;
    datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, datePicker.frame.size.height);
    [self.view addSubview:datePicker];

    
    // animate
    [UIView animateWithDuration:.25 animations:^{
        datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - datePicker.frame.size.height, [UIScreen mainScreen].bounds.size.width, datePicker.frame.size.height);
    }];
    
}
-(IBAction)pickEndDate:(id)sender {
    datePicker = [[HBDatePicker alloc] init];
    datePicker.delegate = self;
    datePicker.isStartDate = FALSE;
    datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, datePicker.frame.size.height);
    [self.view addSubview:datePicker];
    
    // animate
    [UIView animateWithDuration:.25 animations:^{
        datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - datePicker.frame.size.height, [UIScreen mainScreen].bounds.size.width, datePicker.frame.size.height);
    }];
}

-(void)datePickerEndedWithDate:(NSDate *)date {
    
    if (datePicker.isStartDate) {
        [self processStartDate:date];
    }
    else {
        [self processEndDate:date];
    }
    
    [UIView animateWithDuration:.25 animations:^{
        datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, datePicker.frame.size.height);
    } completion:^(BOOL finished) {
        datePicker = Nil;
    }];
}

-(void)datePickerCancelled {
    [UIView animateWithDuration:.25 animations:^{
        datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, datePicker.frame.size.height);
    } completion:^(BOOL finished) {
        datePicker = Nil;
    }];
    
}

-(void)processStartDate:(NSDate *)date {
    startDate = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    startLabel.text = [formatter stringFromDate:startDate];
}
-(void)processEndDate:(NSDate *)date {
    endDate = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    endLabel.text = [formatter stringFromDate:endDate];
}

@end
