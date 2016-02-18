//
//  HBVideoRenderer.m
//  hobnob
//
//  Created by Philip Bernstein on 2/17/16.
//  Copyright © 2016 Philip Bernstein. All rights reserved.
//

#import "HBVideoRenderer.h"

@implementation HBVideoRenderer

-(void)renderVideoFromSource:(NSString *)filePath withOverlay:(UIView *)overlay callback:(RenderCallback)callback {
    
    // apologies for the messiness of this method -- there's a lot going on
    
    exportCallback = callback; // saving for later use
    
    // grabbing graphics from view b/c using the straight CGLayer causes issues
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageWithView:overlay]];
    imageView.backgroundColor = [UIColor clearColor];
    
    // asset from initial video URL
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:filePath]  options:nil];
    
    // setting up composition
    AVMutableComposition* invitationComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack = [invitationComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // adding video track from asset to composition
    AVAssetTrack *invitationVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:invitationVideoTrack atTime:kCMTimeZero error:nil];
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    // setting up CALayer for overlay of invitation content
    CGSize videoSize = [invitationVideoTrack naturalSize]; // preserve size of original video
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    imageView.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);

    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:imageView.layer];
    
    // final composition
    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = videoSize;
    videoComp.frameDuration = CMTimeMake(1, 30);
    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    // adding instructions to include our overlay
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [invitationComposition duration]);
    AVAssetTrack *videoTrack = [[invitationComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComp.instructions = [NSArray arrayWithObject: instruction];
    
    // preserve quality of invitation
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:invitationComposition presetName:AVAssetExportPresetHighestQuality];
    assetExport.videoComposition = videoComp;
    
    // setting the temporary save location (before export to camera roll)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* VideoName = [NSString stringWithFormat:@"%@/hobnob.mp4",documentsDirectory];
    
    
    exportURL = [NSURL fileURLWithPath:VideoName];
    
    // AVAssetExporrtSession can't overrwrite video, so we have to delete the old one (sry not sry)
    if ([[NSFileManager defaultManager] fileExistsAtPath:VideoName])
    {
        [[NSFileManager defaultManager] removeItemAtPath:VideoName error:nil];
    }
    
    // then finally, we export
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    assetExport.outputURL = exportURL;
    assetExport.shouldOptimizeForNetworkUse = YES; // this just means we're moving mov atom to front for streaming
    
    [assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         
         if (assetExport.status == AVAssetExportSessionStatusCompleted)
             exportCallback(exportURL, YES, Nil);
     }
     ];
}



// creates image from CG context on view, makes sure it doesn't come out opaque
-(UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}
@end
