//
//  AppDelegate.h
//  VideoSplitter
//
//  Created by John Nimis on 11/16/15.
//  Copyright (c) 2015 Happy Camper Collective. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAssetReader.h>
#import <AVFoundation/AVAssetWriter.h>
#import <AVFoundation/AVAssetReaderOutput.h>
#import <AVFoundation/AVAssetExportSession.h>
#import "FileProgressView.h"

@import AVKit;

@interface AppDelegate : NSObject <NSApplicationDelegate, ProgressWindowDelegate>

@property (strong, nonatomic) NSString* inputPathString;
@property (strong, nonatomic) NSString* outputPathString;
@property (strong, nonatomic) NSString* ffmpegPath;
@property NSInteger roundLength;
@property NSInteger restLength;
@property (strong) IBOutlet NSComboBox *roundDurationComboBox;
@property (strong) IBOutlet NSComboBox *restDurationComboBox;
@property (strong) IBOutlet NSTextField *startTimeTextField;
@property (strong) IBOutlet AVPlayerView *playerView;
@property (strong) IBOutlet NSButton *roundStartMarkButton;
@property (strong) IBOutlet NSTextField *filenameTextField;
@property int secondsOffset;
@property CMTime preciseOffset;
@property bool cancelled;
@property dispatch_queue_t mainSerializationQueue;
@property dispatch_queue_t rwAudioSerializationQueue;
@property dispatch_queue_t rwVideoSerializationQueue;
@property (strong, nonatomic) AVAsset* readAsset;
@property (strong, nonatomic) NSURL* writeURL;
@property (strong, nonatomic) AVAssetReader *assetReader;
@property (strong, nonatomic) AVAssetWriter *assetWriter;
@property (strong, nonatomic) AVAssetReaderTrackOutput *assetReaderAudioOutput;
@property (strong, nonatomic) AVAssetWriterInput *assetWriterAudioInput;
@property (strong, nonatomic) AVAssetReaderTrackOutput *assetReaderVideoOutput;
@property (strong, nonatomic) AVAssetWriterInput *assetWriterVideoInput;
@property bool audioFinished;
@property bool videoFinished;
@property dispatch_group_t dispatchGroup;
@property (strong, nonatomic) FileProgressView* progressViewController;
@property (strong, nonatomic) NSTimer* progressBarTimer;
@property double progress;
@property (strong, nonatomic) NSString* currentFile;
@property (strong, nonatomic) AVAssetExportSession* currentExportSession;
@property (strong) IBOutlet NSButton *goButton;
@property (strong, nonatomic) NSString* exportPreset;

- (IBAction)roundDurationChanged:(id)sender;
- (IBAction)restDurationChanged:(id)sender;
- (IBAction)chooseInputFileClicked:(id)sender;
- (IBAction)chooseOutputFileClicked:(id)sender;
- (IBAction)goClicked:(id)sender;
- (IBAction)roundStartClicked:(id)sender;
- (IBAction)roundBeginEdited:(id)sender;
- (IBAction)showWindow:(id)sender;
- (IBAction)outputSettingsClicked:(id)sender;

@end

