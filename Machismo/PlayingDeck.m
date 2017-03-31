//
//  PlayingDeck.m
//  Machismo
//
//  Created by 刘江 on 2017/3/22.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "PlayingDeck.h"
#import "PlayingCard.h"

@implementation PlayingDeck

- (instancetype)init{
    self = [super init];
    if (self) {
        for (NSString *suit in [PlayingCard validSuits]) {
            for (int i=1; i<=[PlayingCard maxRank]; i++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.suit = suit;
                card.rank = i;
                [self addCard:card];
            }
        }
    }
    return  self;
}

@end
