//
//  HBVideoRenderer.h
//  hobnob
//
//  Created by Philip Bernstein on 2/17/16.
//  Copyright © 2016 Philip Bernstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SDAVAssetExportSession.h"
/*
    Class for specifically rendering the final video, things can get messy here
 */

typedef void (^RenderCallback)(NSURL *outputFile, BOOL success, NSError *error);
@interface HBVideoRenderer : UIView <SDAVAssetExportSessionDelegate>
{
    NSURL *exportURL; // where rendered video will end up
    RenderCallback exportCallback;
    SDAVAssetExportSession *encoder;
    NSURL *finalOutput;
    CIContext *temporaryContext;
}

-(void)renderVideoFromSource:(NSString *)source withOverlay:(UIView *)overlay callback:(RenderCallback)callback;
@end
