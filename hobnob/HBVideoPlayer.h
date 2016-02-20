//
//  HBVideoPlayer.h
//  hobnob
//
//  Created by Philip Bernstein on 2/17/16.
//  Copyright © 2016 Philip Bernstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/*
    Wrapper around video playback functions. Don't want to bloat the controllers.
    This video player can play any video that apple supports, and wraps together player, asset, and player layer
 */
@protocol HBVideoPlayerDelegate
-(void)userClosed;
-(void)shareClicked;
@end
@interface HBVideoPlayer : UIView
{
    AVPlayerLayer *playerLayer;
    AVPlayer *player;
    UIButton *shareButton;
    AVURLAsset *assetToPlay;
    
    UIButton *xButton;
}
-(AVPlayerLayer *)playerLayer;
@property (weak) id<HBVideoPlayerDelegate> delegate;
-(void)loadVideoSource:(NSURL *)source;
-(void)play;
-(void)pause;
-(void)seek:(CMTime)timeRef; // cmtime is the bain of my existence
-(AVPlayer *)player;
@end
