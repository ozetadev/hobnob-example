//
//  HBPreviewViewController.h
//  hobnob
//
//  Created by Philip Bernstein on 2/17/16.
//  Copyright © 2016 Philip Bernstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HBVideoPlayer.h"

@interface HBPreviewViewController : UIViewController
{
    IBOutlet UIView *viewToRender;
    
    // preview fields
    IBOutlet UILabel *dayOfWeek;
    IBOutlet UILabel *eventTitleLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *dateTextLabel;
    IBOutlet UITextView *address;
    
    // video playback
    HBVideoPlayer *videoPlayer;
    IBOutlet UIImageView *loadingScrum;
}

@property BOOL hasBunting;
@property (nonatomic, retain) NSString *titleOfEvent;
@property (nonatomic, retain) NSString *eventLocation;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@end
