//
//  AppDelegate.m
//  VideoSplitter
//
//  Created by John Nimis on 11/16/15.
//  Copyright (c) 2015 Happy Camper Collective. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.roundLength = 180;
    self.restLength = 60;
    self.preciseOffset = CMTimeMakeWithSeconds(-1, 1);
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-d-yy"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    [self.filenameTextField setStringValue:[NSString stringWithFormat:@"%@-Boxing", dateString]];
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
    
    // initialize video window
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.inputPathString]];
    self.playerView.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
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
    bool useIntValue = false;
    int startTime = 0;
    int roundCount = 1;
    
    CMTime preciseStartTime;
    
    if (CMTimeCompare( self.preciseOffset , CMTimeMakeWithSeconds(-1, 1))) {
        startTime = (int)([self.startTimeTextField integerValue] - 1);
        if (startTime < 0) {
            startTime = 0;
        }
        useIntValue = true;
        preciseStartTime = CMTimeMakeWithSeconds(startTime, 1);
    }
    
    if (!(self.outputPathString == nil || self.inputPathString == nil)) {
    
        // make window here
        self.progressViewController = [[FileProgressView alloc] initWithWindowNibName:@"FileProgressView"];
        self.progressViewController.progressWindowDelegate = self;
        [self.progressViewController showWindow:nil];
        self.progressBarTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateExportDisplay) userInfo:nil repeats:YES];

        [self recursiveStartExport:preciseStartTime roundNum:roundCount];
    
    }
}

-(void)recursiveStartExport:(CMTime)startTime roundNum:(int)roundCount {
    
    // set up file paths
    NSString* thisFileName = [NSString stringWithFormat:@"%@%d.mp4", self.filenameTextField, roundCount];
    NSURL* thisFileToWrite = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.outputPathString, thisFileName]];
    
    // probably need NSFileManager somewhere?
    // the following based on http://stackoverflow.com/questions/13097331/unable-to-trim-a-video-using-avassetexportsession
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *outputURL = paths[0];
    NSFileManager *manager = [NSFileManager defaultManager];
    //        [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    //        outputURL = [outputURL stringByAppendingPathComponent:thisFileName];
    //        [manager removeItemAtPath:outputURL error:nil];
    
    NSLog(@"start time is %f and URL is %@", CMTimeGetSeconds(startTime), thisFileToWrite);
    // initialize time variables
    CMTime duration = CMTimeMakeWithSeconds(self.roundLength + 2, 1);
    CMTimeRange range = CMTimeRangeMake(startTime, duration);
    
    // create "round" asset
    AVAsset* assetToRead = self.playerView.player.currentItem.asset;
    self.readAsset = assetToRead;
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:self.readAsset];
    if ([compatiblePresets containsObject:AVAssetExportPreset640x480]) {
        
        AVAssetExportSession* exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:self.readAsset presetName:AVAssetExportPreset640x480];
        exportSession.outputURL = thisFileToWrite;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.timeRange = range;
        self.currentExportSession = exportSession;
        self.currentFile = thisFileName;
        
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export cancelled");
                    break;
                default:
                    NSLog(@"Export session didn't fail or cancel");
                    break;
            }
            
            CMTime newStartTime = CMTimeMake(CMTimeGetSeconds(startTime) + self.roundLength + self.restLength, 1);

            if ((CMTimeGetSeconds(newStartTime) + self.roundLength) <
                CMTimeGetSeconds(self.playerView.player.currentItem.asset.duration)) {
                
                [self recursiveStartExport:newStartTime roundNum:(roundCount + 1)];
                
            }

//            dispatch_semaphore_signal(sema);
            
        }];
        
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
}

- (void)writeAssetFrom:(CMTime)startTime atFile:(NSURL*)fileURL {
    
    NSLog(@"start time is %f and URL is %@", CMTimeGetSeconds(startTime), fileURL);
    // initialize time variables
    CMTime duration = CMTimeMakeWithSeconds(self.roundLength + 2, 1);
    CMTimeRange range = CMTimeRangeMake(startTime, duration);
    
    // create "round" asset
    AVAsset* assetToRead = self.playerView.player.currentItem.asset;
    self.readAsset = assetToRead;
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:self.readAsset];
    if ([compatiblePresets containsObject:AVAssetExportPreset640x480]) {
        
        AVAssetExportSession* exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:self.readAsset presetName:AVAssetExportPreset640x480];
        exportSession.outputURL = fileURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.timeRange = range;
        self.currentExportSession = exportSession;
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export cancelled");
                    break;
                default:
                    NSLog(@"Export session didn't fail or cancel");
                    break;
            }
            
            dispatch_semaphore_signal(sema);
            
        }];
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
}


- (IBAction)roundStartClicked:(id)sender {
    
    self.preciseOffset = self.playerView.player.currentTime;
    int timeInSeconds = CMTimeGetSeconds(self.preciseOffset);
    [self.startTimeTextField setStringValue:[NSString stringWithFormat:@"%d",timeInSeconds]];
    [self.playerView.player pause];
    
}

- (IBAction)roundBeginEdited:(id)sender {
    self.preciseOffset = CMTimeMakeWithSeconds(-1, 1);
}

- (IBAction)showWindow:(id)sender {
    
    self.progressViewController = [[FileProgressView alloc] initWithWindowNibName:@"FileProgressView"];
    self.progressViewController.progressWindowDelegate = self;
    [self.progressViewController showWindow:nil];

}

-(void)updateExportDisplay {
    if (self.currentExportSession != nil) {
        [self.progressViewController.convertingFileName setStringValue:self.currentFile];
        self.progress = self.currentExportSession.progress * 100;
        [self.progressViewController.progressBar setDoubleValue:self.progress];
    }
}

-(void)progressCancelled {
    [self.progressViewController close];
}

@end
