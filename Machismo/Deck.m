//
//  Deck.m
//  Machismo
//
//  Created by 刘江 on 2017/3/22.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (nonatomic,strong) NSMutableArray *cards;
@end

@implementation Deck

-(NSMutableArray *)cards{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

-(void)addCard:(Card *)card atTop:(BOOL)atTop{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

-(void)addCard:(Card *)card{
    return [self addCard:card atTop:false];
}

-(Card *)drawRandomCard{
    Card *randomCard = nil;
    if ([self.cards count]) {
        int randIndex = arc4random() % [self.cards count];
        randomCard = self.cards[randIndex];
        [self.cards removeObjectAtIndex:randIndex];
    }
    return randomCard;
}
@end
