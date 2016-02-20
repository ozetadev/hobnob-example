//
//  HBVideoPlayer.m
//  hobnob
//
//  Created by Philip Bernstein on 2/17/16.
//  Copyright © 2016 Philip Bernstein. All rights reserved.
//

#import "HBVideoPlayer.h"

@implementation HBVideoPlayer


-(void)loadVideoSource:(NSURL *)source {
    // sets up video player if we don't have one yet
     assetToPlay = [AVURLAsset assetWithURL:source];

    if (!player) {
        player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:assetToPlay]];

    }
    else {
        [player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithAsset:assetToPlay]];
    }
    
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone; // we don't want a pause
    
    // alerts us to restart the video
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];

    
    // sets up player layer (this actually outputs the video content)
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer insertSublayer:playerLayer atIndex:0];
    [player play];
}

-(AVPlayer *)player {
    return player;
}
-(void)finishedPlaying:(AVPlayerItem *)sender {
    [player seekToTime:kCMTimeZero];
    [player play];
}
-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    playerLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height); // ensure player always same dimensions
}

#pragma mark player controls

-(void)play {
    [player play];
}

-(void)pause {
    [player pause];
}

-(void)seek:(CMTime)timeRef {
    [player seekToTime:timeRef];
}

#pragma mark Initial Setup

-(void)commonInit {
    self.backgroundColor = [UIColor clearColor]; // don't want to bother you guys w/ random color when no video is loaded
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height-20-20-25, 45, 55);
    shareButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self addSubview:shareButton];
    [shareButton addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    xButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 30, 45, 45)];
    xButton.contentEdgeInsets = shareButton.contentEdgeInsets;
    [xButton setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [self addSubview:xButton];
    
    [xButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
}

-(void)shareClicked:(id)sender {
    if (_delegate) {
        [_delegate shareClicked];
    }
}

-(void)close {
    if (_delegate) {
        [_delegate userClosed];
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

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}


@end
