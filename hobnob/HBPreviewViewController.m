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

-(void)userClosed {
    [videoPlayer destroy];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    else {
        dayOfWeek.text = [NSString stringWithFormat:@"%@-%@", [self weekdayFromDate:_startDate], [self timeFromDate:_startDate]];
        timeLabel.text = [NSString stringWithFormat:@"TILL %@-%@", [self weekdayFromDate:_endDate], [self timeFromDate:_endDate]];
        dateTextLabel.text = [NSString stringWithFormat:@"%@-%@", [self restOfDateFromDate:_startDate], [self getDateFromDate:_endDate]];
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

-(void)viewDidAppear:(BOOL)animated {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        renderer = [[HBVideoRenderer alloc] init];
        NSString *source = [[NSBundle mainBundle] pathForResource:@"champagne_vert" ofType:@"mov"];
        
        [renderer renderVideoFromSource:source withOverlay:viewToRender callback:^(NSURL *output, BOOL success, NSError *error) {
            [self showVideo:output];
        }];
    });
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
-(void)showVideo:(NSURL *)video {
    outputFile = video;
    dispatch_async(dispatch_get_main_queue(), ^{
        videoPlayer = [[HBVideoPlayer alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen  mainScreen].bounds.size.height)];
        [videoPlayer loadVideoSource:video];
        [videoPlayer play];
        videoPlayer.delegate = self;
        
        [UIView animateWithDuration:.3 animations:^{
            logo.frame = CGRectMake(logo.frame.origin.x, -150, 75, 75);
            tagline.frame = CGRectMake(tagline.frame.origin.x, -140, tagline.frame.size.width, tagline.frame.size.height);
        } completion:^(BOOL finished) {
            [self.view addSubview:videoPlayer];
        }];
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getDateFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    NSInteger day = [components day];
    return [NSString stringWithFormat:@"%lu", day];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)shareClicked {
    NSArray *activityItems = @[outputFile];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [activityViewController setValue:@"Video" forKey:@"subject"];
    [self presentViewController:activityViewController animated:YES completion:nil];
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
    timeFormatter.dateFormat = @"hh";
    
   NSString *time = [[timeFormatter stringFromDate: date] stringByAppendingString:@" O'CLOCK"];
    
    // fixed leading zeros
    if ([[time substringToIndex:1] isEqualToString:@"0"]) {
        time = [time substringFromIndex:1];
    }
    
    return time;
}
@end
