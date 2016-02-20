//
//  HBVideoRenderer.m
//  hobnob
//
//  Created by Philip Bernstein on 2/17/16.
//  Copyright © 2016 Philip Bernstein. All rights reserved.
//

#import "HBVideoRenderer.h"

@implementation HBVideoRenderer

- (void)exportSession:(SDAVAssetExportSession *)exportSession renderFrame:(CVPixelBufferRef)pixelBuffer withPresentationTime:(CMTime)presentationTime toBuffer:(CVPixelBufferRef)renderBuffer {
    
    /*
     This is custom written to add the photo effect that you guys use on your invitations. It essentially takes each frame (pixel buffer) and then applies the filter, and then appends it to the video. This is not a particularly efficient approach, if I were to do this with more time I would use an OpenGL alternative, such as GPUImage
     */
    
    /*
     As a note, Core Image is notoriously slow compared to its counterparts of GPUImage and Metal, but I wanted to perfectly emulated your real Instant Filter
     
     */
    
    /*
        Most of the time I would seperate these processes but they are too closely linked in this instance.
     */
    
    CIImage *theImage = [CIImage imageWithCVPixelBuffer:pixelBuffer]; // image from buffer
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"
                                  keysAndValues: kCIInputImageKey, theImage, nil]; // filter to apply
    theImage = [filter outputImage]; // applying filter
    
    // for memory sake I only create 1 context per render
    EAGLContext *glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSMutableDictionary *glOptions = [[NSMutableDictionary alloc] init];
    [glOptions setObject: [NSNull null] forKey: kCIContextWorkingColorSpace];
    temporaryContext = [CIContext contextWithEAGLContext:glContext options:glOptions];
    
    // picture settings
    CVPixelBufferRef pbuff = NULL;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          theImage.extent.size.width,
                                          theImage.extent.size.height,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef)(options),
                                          &pbuff);
    
    // write rendered image to pixelBuffer
    if (status == kCVReturnSuccess) {
        [temporaryContext render:theImage
                 toCVPixelBuffer:renderBuffer
                          bounds:theImage.extent
                      colorSpace:CGColorSpaceCreateDeviceRGB()];
        
        temporaryContext = Nil;
        theImage = Nil;
        options = Nil;
    }
}
-(void)renderVideoFromSource:(NSString *)filePath withOverlay:(UIView *)overlay callback:(RenderCallback)callback {
    
    /*
        This is a very simpe AVMutableComposition. The video and audio tracks are added, and then the overlay (our text) is added to the video layer, then the video is rendered out
     
        Note: Combining filtering and texting would be much more efficient given time
     */
    
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
         if (assetExport.status == AVAssetExportSessionStatusCompleted) {
             [self exportDidFinish:assetExport];
             [assetExport cancelExport];
         }
        }
     ];
}

-(void)exportDidFinish:(AVAssetExportSession*)session
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* VideoName = [NSString stringWithFormat:@"%@/final.mp4",documentsDirectory];
    unlink([VideoName UTF8String]);
    
    [[NSFileManager defaultManager] removeItemAtPath:VideoName error:Nil];
    
    finalOutput = [NSURL fileURLWithPath:VideoName];
    
    encoder = [SDAVAssetExportSession.alloc initWithAsset:[AVURLAsset assetWithURL:exportURL]];
    encoder.outputFileType = AVFileTypeMPEG4;
    encoder.outputURL = finalOutput;
    encoder.delegate = self;
    encoder.videoSettings = @
    {
    AVVideoCodecKey: AVVideoCodecH264,
    AVVideoWidthKey: @1080,
    AVVideoHeightKey: @1920,
    AVVideoCompressionPropertiesKey: @
        {
        AVVideoAverageBitRateKey: @6000000,
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
        },
    };
    encoder.audioSettings = @
    {
    AVFormatIDKey: @(kAudioFormatMPEG4AAC),
    AVNumberOfChannelsKey: @2,
    AVSampleRateKey: @44100,
    AVEncoderBitRateKey: @128000,
    };
    
    [encoder exportAsynchronouslyWithCompletionHandler:^
     {
         encoder.cutItOut = TRUE;
         if (encoder.status == AVAssetExportSessionStatusCompleted)
         {
             NSLog(@"Video export succeeded");
             exportCallback(finalOutput, YES, Nil); // no errors to be seen here
         }
         else if (encoder.status == AVAssetExportSessionStatusCancelled)
         {
             NSLog(@"Video export cancelled");
         }
         else
         {
             NSLog(@"Video export failed with error: %@", encoder.error.localizedDescription);
         }
     }];
    
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
