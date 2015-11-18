//
//  AppDelegate.h
//  VideoSplitter
//
//  Created by John Nimis on 11/16/15.
//  Copyright (c) 2015 Happy Camper Collective. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) NSString* inputPathString;
@property (strong, nonatomic) NSString* outputPathString;
@property (strong, nonatomic) NSString* ffmpegPath;
@property NSInteger roundLength;
@property NSInteger restLength;
@property (strong) IBOutlet NSComboBox *roundDurationComboBox;
@property (strong) IBOutlet NSComboBox *restDurationComboBox;
@property (strong) IBOutlet NSTextField *startTimeTextField;

- (IBAction)roundDurationChanged:(id)sender;
- (IBAction)restDurationChanged:(id)sender;
- (IBAction)chooseInputFileClicked:(id)sender;
- (IBAction)chooseOutputFileClicked:(id)sender;
- (IBAction)goClicked:(id)sender;

@end

