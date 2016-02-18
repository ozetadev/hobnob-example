//
//  HBDatePicker.m
//  hobnob
//
//  Created by Philip Bernstein on 2/17/16.
//  Copyright © 2016 Philip Bernstein. All rights reserved.
//

#import "HBDatePicker.h"

@implementation HBDatePicker
@synthesize datePicker;

@synthesize delegate = _delegate;

-(void)commonInit {
    
    if (datePicker)
        return;
    
    // just UI setup for our code picker
    datePicker.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, datePicker.frame.size.width);
    datePicker.backgroundColor = [UIColor colorWithHue:0.603 saturation:0.304 brightness:0.271 alpha:1.000];
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    self.backgroundColor = [UIColor blackColor];
    self.frame = CGRectMake(0, 0, datePicker.frame.size.width, datePicker.frame.size.height+50);
    [self addSubview:datePicker];
    
    topBar = [[UIView alloc] initWithFrame:CGRectMake(0, -10, self.frame.size.width+60, 50)];
    topBar.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:topBar];
    
    UIButton *done = [UIButton buttonWithType:UIButtonTypeSystem];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    done.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-65, 5, 45, 40);
    [topBar addSubview:done];
    [done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cancel.frame = CGRectMake(20, 5, 55, 40);
    [topBar addSubview:cancel];
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [done addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    self.maskView = FALSE; // im tricky :)
    
    topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, 1)];
    topLine.backgroundColor = [UIColor whiteColor];
    [topBar addSubview:topLine];

}

-(void)done {
    if (_delegate) {
        [_delegate datePickerEndedWithDate:datePicker.date];
    }
}

-(void)cancel {
    if (_delegate) {
        [_delegate datePickerCancelled];
    }
}

-(id)init {
    self = [super init];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    //datePicker.frame = CGRectMake(0, self.frame.size.height - datePicker.frame.size.height, datePicker.frame.size.width, datePicker.frame.size.height);
}

@end
