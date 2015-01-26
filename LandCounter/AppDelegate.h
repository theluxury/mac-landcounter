//
//  AppDelegate.h
//  LandCounter
//
//  Created by Mark Wang on 1/25/15.
//  Copyright (c) 2015 Mark Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTextField *sizeOfDeck;
@property (weak) IBOutlet NSTextField *numberOfLands;
@property (weak) IBOutlet NSTextField *wantedLands;
@property (weak) IBOutlet NSTextField *byTurn;
@property (weak) IBOutlet NSTextField *probabilityLabel;
@property (weak) IBOutlet NSPopUpButton *playOrDrawButton;

- (IBAction)calculatePercentage:(id)sender;


@end

