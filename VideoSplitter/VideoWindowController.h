//
//  VideoWindowController.h
//  VideoSplitter
//
//  Created by John Nimis on 11/18/15.
//  Copyright © 2015 Happy Camper Collective. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@import AVKit;

@interface VideoWindowController : NSWindowController

@property (strong) IBOutlet NSButton *cancelButton;
@property (strong) IBOutlet NSButton *roundStartButton;
//@property (strong) IBOutlet AVPlayer *player;
@property (strong) IBOutlet AVPlayerView *playerView;

- (IBAction)roundStartPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;


@end
