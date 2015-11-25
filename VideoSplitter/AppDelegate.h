//
//  AppDelegate.h
//  VideoSplitter
//
//  Created by John Nimis on 11/16/15.
//  Copyright (c) 2015 Happy Camper Collective. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VideoWindowController.h"

@import AVKit;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) NSString* inputPathString;
@property (strong, nonatomic) NSString* outputPathString;
@property (strong, nonatomic) NSString* ffmpegPath;
@property NSInteger roundLength;
@property NSInteger restLength;
@property (strong) IBOutlet NSComboBox *roundDurationComboBox;
@property (strong) IBOutlet NSComboBox *restDurationComboBox;
@property (strong) IBOutlet NSTextField *startTimeTextField;
//@property (strong, nonatomic) AVPlayerItem* playerItem;
@property (strong, nonatomic) AVPlayerView* playerView;
@property (strong, nonatomic) VideoWindowController *controllerWindow;

- (IBAction)roundDurationChanged:(id)sender;
- (IBAction)restDurationChanged:(id)sender;
- (IBAction)chooseInputFileClicked:(id)sender;
- (IBAction)chooseOutputFileClicked:(id)sender;
- (IBAction)goClicked:(id)sender;
- (IBAction)viewVideoClicked:(id)sender;
- (IBAction)roundStartPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)play:(id)sender;


@end

