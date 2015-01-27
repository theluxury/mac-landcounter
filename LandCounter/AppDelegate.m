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
@property (nonatomic) NSInteger castByTunInt;
@property (nonatomic) NSInteger numberOfColoredLandsInt;
@property (nonatomic) NSInteger colorlessSpellCostInt;
@property (nonatomic) NSInteger coloredSpellCostInt;

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
    }
    else {
        numberOfCardsInHand = _byTurnInt + 7;
    }
    
    // Think 50k is roughly good enough.
    float probability = [self runSimulations:50000 numberOfLands:_wantedLandsInt numberOfCardsInHand:numberOfCardsInHand];
    [_probabilityLabel setStringValue:[NSString stringWithFormat:@"%f%%", probability]];
}

- (IBAction)calculateCastPercentage:(id)sender {
    _sizeOfDeckInt = [_sizeOfDeck integerValue];
    _numberOfLandsInt = [_numberOfLands integerValue];
    _numberOfColoredLandsInt = [_numberOfColoredLands integerValue];
    _castByTunInt = [_castByTurn integerValue];
    _colorlessSpellCostInt = [_colorlessCostOfSpell integerValue];
    _coloredSpellCostInt = [_coloredCostOfSpell integerValue];
    
    
    
    NSInteger numberOfCardsInHand;
    
    // This is 1 lower than the lands thing because for you to cast the spell, you're assuming that at least one of your cards is not a land.
    if ([[_playOrDrawButton titleOfSelectedItem] isEqualToString:@"Play"]) {
        numberOfCardsInHand = _castByTunInt + 6;
    }
    else {
        numberOfCardsInHand = _castByTunInt + 7;
    }
    
    float probability = [self runCastingSimulations:50000 coloredCost:_coloredSpellCostInt colorlessCost:_colorlessSpellCostInt cards:numberOfCardsInHand];
    [_castProbabilityLabel setStringValue:[NSString stringWithFormat:@"%f%%", probability]];
    
}

- (float)runCastingSimulations:(NSInteger)numberOfSimulations coloredCost:(NSInteger)colored colorlessCost:(NSInteger)colorless cards:(NSInteger)cards {
    
    float numberOfHits = 0;
    for (int i = 0; i < numberOfSimulations; i++) {
        if ([self getAtLeastXColoredAndYColorlessInZCards:colored colorless:colorless cards:cards])
            numberOfHits ++;
    }
    
    return numberOfHits / (float) numberOfSimulations ;
    
    
}

- (float)runSimulations:(NSInteger)numberOfSimulations numberOfLands:(NSInteger)lands numberOfCardsInHand:(NSInteger)cards {
    
    float numberOfHits = 0;
    for (int i = 0; i < numberOfSimulations; i++) {
        if ([self getAtLeastXLandsInYCards:lands numberOfCardsInHard:cards])
            numberOfHits ++;
    }
    
    return numberOfHits / (float) numberOfSimulations ;
}

- (BOOL)getAtLeastXLandsInYCards:(NSInteger)lands numberOfCardsInHard:(NSInteger)cards {
    
    NSMutableIndexSet *randomNumbersAlreadyGenerated = [[NSMutableIndexSet alloc] init];
    int numberOfLandsInHand = 0;
    
    for (int i = 0; i < cards; i++) {
        // First, make an NSSet that contains the numbers already generated.
        int r;
        // Generate a random number until you get one that hasn't been hit yet.
        do {
            r = arc4random_uniform(_sizeOfDeckInt);
        } while ([randomNumbersAlreadyGenerated containsIndex:r]);
        // So this r is not in the index set yet, so add it.
        [randomNumbersAlreadyGenerated addIndex:r];
        
        // Want less than since r starts at 0 and ends at _sizeOfDeckInt - 1. 
        if (r < _numberOfLandsInt) {
            numberOfLandsInHand++;
        }
    }
    
    // return YES if the simulation has at least that many lands, no if it doesn't.
    if (numberOfLandsInHand >= lands)
        return YES;
    else
        return NO;
}

- (BOOL)getAtLeastXColoredAndYColorlessInZCards:(NSInteger)colored colorless:(NSInteger)colorless cards:(NSInteger)cards {
    
    NSMutableIndexSet *randomNumbersAlreadyGenerated = [[NSMutableIndexSet alloc] init];
    int numberOfLandsInHand = 0;
    int numberOfColoredLandsInHand = 0;
    // Needs the cards - 1 here because it's assumed that one of your cards is the spell you want to cast in question.
    NSInteger numberOfRelevantCardsInHand = cards - 1;
    // This is sizeOfDeck - 1 because one again, assumed that one of the cards is the spell you want to cast.
    NSInteger numberOfRelevantCardsInDeck = _sizeOfDeckInt - 1;
    
    for (int i = 0; i < numberOfRelevantCardsInHand; i++) {
        // First, make an NSSet that contains the numbers already generated.
        int r;
        // Generate a random number until you get one that hasn't been hit yet.
        do {
            r = arc4random_uniform(numberOfRelevantCardsInDeck);
        } while ([randomNumbersAlreadyGenerated containsIndex:r]);
        // So this r is not in the index set yet, so add it.
        [randomNumbersAlreadyGenerated addIndex:r];
        
        // Want less than since r starts at 0 and ends at _sizeOfDeckInt - 2.
        if (r < _numberOfColoredLandsInt) {
            numberOfLandsInHand++;
            numberOfColoredLandsInHand++;
        } else if (r < _numberOfLandsInt) {
            numberOfLandsInHand++;
        }
    }
    
    // return YES if the simulation has at least that many lands, no if it doesn't.
    if (numberOfLandsInHand >= (colored + colorless) && numberOfColoredLandsInHand >= colored)
        return YES;
    else
        return NO;
}

@end
