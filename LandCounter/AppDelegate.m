//
//  AppDelegate.m
//  LandCounter
//
//  Created by Mark Wang on 1/25/15.
//  Copyright (c) 2015 Mark Wang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)calculatePercentage:(id)sender {
    NSInteger sizeOfDeck = [_sizeOfDeck integerValue];
    NSInteger numberOfLands = [_numberOfLands integerValue];
    NSInteger wantedLands = [_wantedLands integerValue];
    NSInteger byTurn = [_byTurn integerValue];
    
    
    
}

@end
