//
//  FileProgressView.m
//  VideoSplitter
//
//  Created by John Nimis on 12/27/15.
//  Copyright (c) 2015 Happy Camper Collective. All rights reserved.
//

#import "FileProgressView.h"

@interface FileProgressView ()

@end

@implementation FileProgressView

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (IBAction)cancelClicked:(id)sender {
    [self.progressWindowDelegate progressCancelled];
}

@end
