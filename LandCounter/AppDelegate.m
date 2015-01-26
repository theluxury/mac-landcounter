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
@property (nonatomic) NSInteger sizeOfDeckInt;
@property (nonatomic) NSInteger numberOfLandsInt;
@property (nonatomic) NSInteger wantedLandsInt;
@property (nonatomic) NSInteger byTurnInt;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)calculatePercentage:(id)sender {
    _sizeOfDeckInt = [_sizeOfDeck integerValue];
    _numberOfLandsInt = [_numberOfLands integerValue];
    _wantedLandsInt = [_wantedLands integerValue];
    _byTurnInt = [_byTurn integerValue];
    NSInteger numberOfCardsInHand;
    
    // Assuming on play for now. Is 6 because turn 1, you have 7 cards.
    if ([[_playOrDrawButton titleOfSelectedItem] isEqualToString:@"Play"]) {
        numberOfCardsInHand = _byTurnInt + 6;
        NSLog(@"on play");
    }
    else {
        numberOfCardsInHand = _byTurnInt + 7;
        NSLog(@"on draw");
    }
    
    float probability = [self findProbabilityOfHavingAtLeastXLandsInYCards:_wantedLandsInt numberOfCardsInHard:numberOfCardsInHand];
    [_probabilityLabel setStringValue:[NSString stringWithFormat:@"%f%%", probability]];

}

- (float)findProbabilityOfHavingAtLeastXLandsInYCards:(NSInteger)lands numberOfCardsInHard:(NSInteger)cards {
    float probability = 0;
    // Take sum of probability of lands from wanted lands to number of cards in hand.
    for (NSInteger i = lands; i <= cards; i++) {
        // Find probability of having i lands in numberOfCardsInHand cards.
        probability = probability + [self findProbabilityOfHavingXLandsInYCards:i numberOfCardsInHand:cards];
    }
    
    return probability;
}

- (float)findProbabilityOfHavingXLandsInYCards:(NSInteger)lands numberOfCardsInHand:(NSInteger)cards {
    // is (number of lands in deck choose number of lands) * (number of non lands in deck choose number of non lands in hand) / (deck size choose hand size).
    
    // (number of lands in deck choose number of lands)
    NSInteger numberOfNonLandsInHand = cards - lands;
    NSInteger numberOfNonLandsInDeck = _sizeOfDeckInt - _numberOfLandsInt;
    float a = 1;
    for (int i = 0; i < lands; i++) {
        a = a * (_numberOfLandsInt - i) / (lands - i);
    }
    
    // number of non lands in deck choose number of non lands in hand
    float b = 1;
    for (int i = 0; i < numberOfNonLandsInHand; i++) {
        b = b * (numberOfNonLandsInDeck - i) / (numberOfNonLandsInHand - i);
    }
    
    // deck size choose hand size
    float c = 1;
    for (int i = 0; i < cards; i++) {
        c = c * (_sizeOfDeckInt - i) / (cards - i);
    }
    
    return (a * b) / c;
}

@end
