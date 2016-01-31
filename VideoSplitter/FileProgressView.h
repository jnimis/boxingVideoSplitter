//
//  FileProgressView.h
//  VideoSplitter
//
//  Created by John Nimis on 12/27/15.
//  Copyright (c) 2015 Happy Camper Collective. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ProgressWindowDelegate <NSObject>
-(void)progressCancelled;
@end

@interface FileProgressView : NSWindowController

@property (strong) IBOutlet NSButton *cancelButton;
@property (strong) IBOutlet NSButton *okButton;
@property (strong) IBOutlet NSProgressIndicator *progressBar;
@property (strong) IBOutlet NSTextField *convertingFileName;
@property (weak) id<ProgressWindowDelegate>progressWindowDelegate;

- (IBAction)cancelClicked:(id)sender;

@end
