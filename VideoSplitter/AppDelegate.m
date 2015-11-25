//
//  AppDelegate.m
//  VideoSplitter
//
//  Created by John Nimis on 11/16/15.
//  Copyright (c) 2015 Happy Camper Collective. All rights reserved.
//

#import "AppDelegate.h"
#include <AVFoundation/AVPlayer.h>
#include <AVFoundation/AVPlayerItem.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.roundLength = 180;
    self.restLength = 60;
    
    // should look for ffmpeg and find it
//    NSTask* task = [[NSTask alloc] init];
//    [task setLaunchPath:@"/usr/bin/which ffmpeg"];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)roundDurationChanged:(id)sender {
    
    NSInteger index = [sender indexOfSelectedItem];
    switch (index) {
        case 0:
            self.roundLength = 180;
            break;
        case 1:
            self.roundLength = 120;
            break;
        case 2:
            self.roundLength = 90;
            break;
    }
    
}

- (IBAction)restDurationChanged:(id)sender {
    
    NSInteger index = [sender indexOfSelectedItem];
    switch (index) {
        case 0:
            self.restLength = 60;
            break;
        case 1:
            self.restLength = 30;
            break;
    }
    
}

- (IBAction)chooseInputFileClicked:(id)sender {
    self.inputPathString = [self getPathStringFromDialogue:true];
}

- (IBAction)chooseOutputFileClicked:(id)sender {
    self.outputPathString = [self getPathStringFromDialogue:false];
}

- (NSString*)getPathStringFromDialogue:(bool)willSelectFile {
    
    __block NSString* pathString;
    
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    if (willSelectFile) {
        [panel setCanChooseFiles:YES];
    } else {
        [panel setCanChooseDirectories:YES];
    }
    [panel setAllowsMultipleSelection:false];
    
    if ( [panel runModal] == NSOKButton) {
        NSArray* files = [panel URLs];
        pathString = [NSString stringWithFormat:@"%@",[files objectAtIndex:0]];
    }
    
    return pathString;
}

- (IBAction)goClicked:(id)sender {
    bool shouldContinue = true;
    
    int startTime = (int)([self.startTimeTextField integerValue] - 1);
    if (startTime < 0) {
        startTime = 0;
    }
    int increment = (int)(self.roundLength + self.restLength);
    int roundInt = (int)(self.roundLength + 2);
    int index = 1;
    
    // check to make sure controls have valid values (esp. input path, output path, start time)
    if ((self.inputPathString != nil) && [self.outputPathString hasSuffix:@"/"] && (startTime > 0)) {
            
        // parse paths
        NSString* outputPath = [self.outputPathString substringFromIndex:7];
        NSString* inputPath = [self.inputPathString substringFromIndex:7];
        
        // determine overall file length to define path loop length
        while (shouldContinue) {
            
            NSString* outFilePath = [NSString stringWithFormat:@"%@outputFile%d.mp4",outputPath,index];
            NSTask *task = [[NSTask alloc] init];
            [task setLaunchPath:@"/usr/bin/ffmpeg"];
            NSArray* arguments = [NSArray arrayWithObjects: @"-i", inputPath, @"-ss", [NSString stringWithFormat:@"%d",startTime], @"-t",
                                  [NSString stringWithFormat:@"%d",roundInt], outFilePath, nil];
            [task setArguments:arguments];
            [task launch];
            [task waitUntilExit];
            
            startTime = startTime + increment;
            index++;
            if (index > 5) {
                shouldContinue = false;
            }
        }
    }
}

- (IBAction)viewVideoClicked:(id)sender {
  
  if (self.inputPathString != nil) {
//    NSString* inputPath = [self.inputPathString substringFromIndex:7];
    
    NSURL* url = [NSURL URLWithString:self.inputPathString];
//    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    
    self.controllerWindow = [[VideoWindowController alloc] initWithWindowNibName:@"VideoWindowController" owner:self];
//    self.controllerWindow.player =
    self.controllerWindow.playerView.player = [[AVPlayer alloc] initWithURL:url];
  
    [self.controllerWindow showWindow:self];
//    [self.playerItem addObserver:self.controllerWindow forKeyPath:@"status" options:0 context:nil];
//       I have no idea if the line above is right
    [self.controllerWindow.playerView.player play];
  }
}

- (IBAction)play:sender {

  [self.controllerWindow.playerView.player play];
  
}

- (IBAction)roundStartPressed:(id)sender {
  
}

- (IBAction)cancelPressed:(id)sender {
  
  [self.controllerWindow close];
}


@end
