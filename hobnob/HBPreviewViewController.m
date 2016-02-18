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
@synthesize hasBunting = _hasBunting, titleOfEvent = _titleOfEvent, eventLocation = _eventLocation, startDate = _startDate, endDate = _endDate;

#pragma mark getters
-(NSString *)titleOfEvent {
    return _titleOfEvent;
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

-(void)settitleOfEvent:(NSString *)titleOfEvent {
    _titleOfEvent = titleOfEvent;
}

-(void)setEventLocation:(NSString *)eventLocation {
    _eventLocation = eventLocation;
}

-(void)setStartDate:(NSDate *)startDate {
    _startDate = startDate;
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
    eventTitleLabel.text = _titleOfEvent;
    address.text = _eventLocation;
    address.textColor = [UIColor whiteColor];
    
    if (!_endDate) { // single day foirè
        dateTextLabel.text = [self restOfDateFromDate:_startDate];
        dayOfWeek.text = [self weekdayFromDate:_startDate];
        timeLabel.text = [self timeFromDate:_startDate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark date utilities

-(NSString *)weekdayFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:date];
}

-(NSString *)restOfDateFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"MMMM d"]];
    return [dateFormatter stringFromDate:date];
}

-(NSString *)timeFromDate:(NSDate *)date {
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"H";
    
   return [[timeFormatter stringFromDate: date] stringByAppendingString:@" O'CLOCK"];
}

@end
