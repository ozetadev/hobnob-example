//
//  HBPreviewViewController.m
//  hobnob
//
//  Created by Philip Bernstein on 2/17/16.
//  Copyright © 2016 Philip Bernstein. All rights reserved.
//

#import "HBPreviewViewController.h"
#import "HBVideoRenderer.h"
#define screenSize [UIScreen mainScreen].bounds.size
@interface HBPreviewViewController ()

@end

@implementation HBPreviewViewController
@synthesize hasBunting = _hasBunting, eventTitle = _eventTitle, eventLocation = _eventLocation, startDate = _startDate, endDate = _endDate;

#pragma mark getters
-(NSString *)eventTitle {
    return _eventTitle;
}

-(NSString *)eventLocation {
    return _eventLocation;
}

-(NSDate *)startDate {
    return _startDate;
}

-(NSDate *)endDate {
    return _endDate;
}

#pragma mark setters

-(void)setEventTitle:(NSString *)eventTitle {
    _eventTitle = eventTitle;
    eventTitleLabel.text = _eventTitle;
}

-(void)setEventLocation:(NSString *)eventLocation {
    _eventLocation = eventLocation;
}

-(void)setStartDate:(NSDate *)startDate {
    _startDate = startDate;
    dayOfWeek.text = [self weekdayFromDate:startDate];
}

-(void)setEndDate:(NSDate *)endDate {
    _endDate = endDate;
}

#pragma mark utility methods

-(void)setHasBunting:(BOOL)hasBunting {
    _hasBunting = hasBunting;
}

-(BOOL)hasBunting {
    return _hasBunting;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:TRUE];
    
    
    [eventTitleLabel setAdjustsFontSizeToFitWidth:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(NSString *)weekdayFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:date];
}

@end
