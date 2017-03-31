//
//  CardMatchingGame.h
//  Machismo
//
//  Created by 刘江 on 2017/3/22.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSInteger)index;
- (Card *)cardAtIndex:(NSInteger)index;

@property (nonatomic,readonly) NSInteger score;

@end
