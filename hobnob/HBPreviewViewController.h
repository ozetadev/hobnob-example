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
#import "HBVideoRenderer.h"

/*
    The implementation of this is kind of... strange. The overlay with text is actually rendered and drawn into an image, and then ovlay during video transcoding. Later on, the video is filtered, and shown (with share sheet button and x button)
 
 */

@interface HBPreviewViewController : UIViewController <HBVideoPlayerDelegate>
{
    IBOutlet UIView *viewToRender;
    
    // preview fields
    IBOutlet UILabel *dayOfWeek; // title showing day of week
    IBOutlet UILabel *eventTitleLabel; // title showing event title (60 char limit)
    IBOutlet UILabel *timeLabel; // label showing (usually) time of event, sometimes date range
    IBOutlet UILabel *dateTextLabel; // this shows the date "September 22"
    IBOutlet UILabel *tagline; 
    IBOutlet UITextView *address; // This is a text view allowing expanded, multiline text
    IBOutlet UIImageView *logo; // image containing circular hobnob logo
    IBOutlet UIImageView *loadingScrum;
    IBOutlet UIImageView *flourish; // image containing flourish

    // video playback
    HBVideoPlayer *videoPlayer;
    
    // video rendering
    HBVideoRenderer *renderer;
    NSURL *outputFile;
}

// properties so entry view can pass along variables
@property BOOL hasBunting;
@property (nonatomic, retain) NSString *titleOfEvent;
@property (nonatomic, retain) NSString *eventLocation;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@end
