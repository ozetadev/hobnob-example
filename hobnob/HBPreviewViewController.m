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
@synthesize hasBunting = _hasBunting;

-(void)setHasBunting:(BOOL)hasBunting {
    _hasBunting = hasBunting;
}

-(BOOL)hasBunting {
    return _hasBunting;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:TRUE];
    
    
    [eventTitle setAdjustsFontSizeToFitWidth:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /*
    NSString *path = [[NSBundle mainBundle] pathForResource:@"champagne_vert" ofType:@"mov"];
    
    HBVideoRenderer *renderer = [[HBVideoRenderer alloc] init];
    
    [renderer renderVideoFromSource:path withOverlay:viewToRender callback:^(NSURL *outputFile, BOOL success, NSError *error) {
        NSLog(@"BOOM");
    }];
     */
}


@end
