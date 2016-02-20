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
    
    // just trying to make it pretty :)
    inputView.layer.cornerRadius = 8.0;
    startButton.layer.cornerRadius = 4.0;
    endButton.layer.cornerRadius = 4.0;
    nextButton.layer.cornerRadius = 4.0;
    
    // crude way of making text input look correct
    whereField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    whatField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);

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
    if (datePicker)
        return;
    
    [whereField resignFirstResponder];
    [whatField resignFirstResponder];

    // bring up our custom date picker
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
    
    if (datePicker)
        return;
    
    [whereField resignFirstResponder];
    [whatField resignFirstResponder];
    
    // bring up our custom date picker (again)
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
    
    // both date pickers call same delegate method, here we decide what to store
    if (datePicker.isStartDate) {
        [self processStartDate:date];
    }
    else {
        [self processEndDate:date];
    }
    
    [self hideDatePicker];
    
}

-(void)hideDatePicker {
    [UIView animateWithDuration:.25 animations:^{
        datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+100, [UIScreen mainScreen].bounds.size.width, datePicker.frame.size.height);
    } completion:^(BOOL finished) {
        datePicker = Nil;
    }];
}
-(IBAction)previewInvite:(id)sender {
    
    // ensures button cannot be pressed without enough data present
    if ([whereField.text isEqualToString:@""] || [whatField.text isEqualToString:@""] || !startDate) {
        [UIView animateWithDuration:.2 animations:^{
            nextButton.backgroundColor = [UIColor redColor];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 animations:^{
               nextButton.backgroundColor = [UIColor colorWithHue:0.393 saturation:0.451 brightness:0.745 alpha:1.000];
            }];
        }];
        return; // aint nobody making an invite without my persmission
    }
    
    HBPreviewViewController *previewView = (HBPreviewViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"preview"];
    
    previewView.titleOfEvent = whatField.text;
    previewView.startDate = startDate;
    previewView.endDate = endDate;
    previewView.eventLocation = whereField.text;

    [self.navigationController pushViewController:previewView animated:YES];
}
-(void)datePickerCancelled {
    [self hideDatePicker];
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

// limit title to 60 char
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 60 && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {return YES;}
}

-(void)viewWillAppear:(BOOL)animated {
    whatField.text = @"";
    whereField.text = @"";
    startDate = Nil;
    endDate = Nil;
    startLabel.text = @"";
    endLabel.text = @"OPTIONAL";
    
    // get rid of files
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* VideoName = [NSString stringWithFormat:@"%@/hobnob.mp4",documentsDirectory];
    [[NSFileManager defaultManager] removeItemAtPath:VideoName error:Nil];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [path objectAtIndex:0];
    NSString* video = [NSString stringWithFormat:@"%@/final.mp4",directory];
    [[NSFileManager defaultManager] removeItemAtPath:video error:Nil];

}
-(IBAction)textDidEnd:(UITextField *)sender {
    if (sender == whatField) {
        [whatField resignFirstResponder];
        [whereField becomeFirstResponder];
    }
    else {
        [whereField resignFirstResponder];
        [whatField resignFirstResponder];
    }
}

@end
