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
@property (nonatomic) NSInteger playOrDrawNumberOfCards;

@property (nonatomic) NSInteger colorlessCostOfGoldSpell;
@property (nonatomic) NSInteger coloredCostOfGoldSpellA;
@property (nonatomic) NSInteger coloredCostOfGoldSpellB;
@property (nonatomic) NSInteger numberOfDualLands;
@property (nonatomic) NSInteger numberOfColoredLandsA;
@property (nonatomic) NSInteger numberOfColoredLandsB;
@property (nonatomic) NSInteger castGoldByTurn;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)calculatePercentage:(id)sender {
    [self setNumbers];
    
    // Think 50k is roughly good enough.
    float probability = [self runSimulations:@"lands" numberOfSimulation:50000];
    [_probabilityLabel setStringValue:[NSString stringWithFormat:@"%f%%", probability]];
}

- (IBAction)calculateCastPercentage:(id)sender {
    [self setNumbers];

    
    float probability = [self runSimulations:@"cast" numberOfSimulation:50000];
    [_castProbabilityLabel setStringValue:[NSString stringWithFormat:@"%f%%", probability]];
    
}

- (IBAction)calculateGoldCastPercentage:(id)sender {
    [self setNumbers];
    float probability = [self runSimulations:@"gold" numberOfSimulation:50000];
    NSLog(@"probability is %f", probability);
    
}

- (void)setNumbers {
    _sizeOfDeckInt = [_sizeOfDeck integerValue];
    _numberOfLandsInt = [_numberOfLands integerValue];
    _wantedLandsInt = [_wantedLands integerValue];
    _byTurnInt = [_byTurn integerValue];
    
    _numberOfColoredLandsInt = [_numberOfColoredLands integerValue];
    _castByTunInt = [_castByTurn integerValue];
    _colorlessSpellCostInt = [_colorlessCostOfSpell integerValue];
    _coloredSpellCostInt = [_coloredCostOfSpell integerValue];
    
    if ([[_playOrDrawButton titleOfSelectedItem] isEqualToString:@"Play"]) {
        _playOrDrawNumberOfCards =  6;
    }
    else {
        _playOrDrawNumberOfCards =  7;
    }

}

- (float)runSimulations:(NSString *)simulationType numberOfSimulation:(NSInteger)numberOfSimulations{
    
    float numberOfHits = 0;
    if ([simulationType isEqualToString:@"lands"]) {
        NSInteger numberOfCardsInHand = _byTurnInt + _playOrDrawNumberOfCards;
        for (int i = 0; i < numberOfSimulations; i++) {
            if ([self getAtLeastXLandsInYCards:_wantedLandsInt numberOfCardsInHard:numberOfCardsInHand])
                numberOfHits ++;
        }
    } else if ([simulationType isEqualToString:@"cast"]) {
        // Different number of cards in hand, since two different inputs. 
        NSInteger numberOfCardsInHand = _castByTunInt + _playOrDrawNumberOfCards;
        for (int i = 0; i < numberOfSimulations; i++) {
            if ([self getAtLeastXColoredAndYColorlessInZCards:_coloredSpellCostInt colorless:_colorlessSpellCostInt cards:numberOfCardsInHand])
                numberOfHits ++;
        }
    } else {
        NSInteger numberOfCardsInHand = _castGoldByTurn + _playOrDrawNumberOfCards;
        for (int i = 0; i < numberOfSimulations; i++) {
            if ([self canCastGoldSpellInXCards:numberOfCardsInHand])
                numberOfHits ++;
        }

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

- (BOOL)canCastGoldSpellInXCards:(NSInteger)cards {
    // Bah, I'll generalize it tomorrow.
    
    NSMutableIndexSet *randomNumbersAlreadyGenerated = [[NSMutableIndexSet alloc] init];
    int numberOfLandsInHand = 0;
    int numberOfDualLandsInHand = 0;
    int numberOfColoredLandsAInHand = 0;
    int numberOfColoredLandsBInHand = 0;
    
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
        if (r < _numberOfDualLands) {
            numberOfDualLandsInHand++;
            numberOfLandsInHand++;
        } else if (r < (_numberOfDualLands + _numberOfColoredLandsA)) {
            numberOfColoredLandsAInHand++;
            numberOfLandsInHand++;
        } else if (r < (_numberOfDualLands + _numberOfColoredLandsA + _numberOfColoredLandsB)) {
            numberOfColoredLandsBInHand++;
            numberOfLandsInHand++;
        } else if (r < _numberOfLandsInt) {
            numberOfLandsInHand++;
        }
    }
    
    NSInteger totalCost = _colorlessCostOfGoldSpell + _coloredCostOfGoldSpellA + _coloredCostOfGoldSpellB;
    if (numberOfLandsInHand < totalCost)
        return NO;
    
    // Don't have to check for number of lands in hand since the above already checks to make that true.
    // If can cast without dual land, you're fine.
    if (_coloredCostOfGoldSpellA <= numberOfColoredLandsAInHand &&  _coloredCostOfGoldSpellB <= numberOfColoredLandsBInHand )
        return YES;
    
    // Now checks to see about dual land. Take sum of the lack of mana for the two colors, then sees if the dual land can cover the sum of difference.
    int coloredLandDifference = 0;
    if (numberOfColoredLandsAInHand < _coloredCostOfGoldSpellA) {
        coloredLandDifference = coloredLandDifference + (_coloredCostOfGoldSpellA - numberOfColoredLandsAInHand);
    }
    
    if (numberOfColoredLandsBInHand < _coloredCostOfGoldSpellB) {
        coloredLandDifference = coloredLandDifference + (_coloredCostOfGoldSpellB - numberOfColoredLandsBInHand);
    }
    
    if (coloredLandDifference <= numberOfDualLandsInHand)
        return YES;
    
    // defaults to return no. 
    return NO;

    
}

@end
