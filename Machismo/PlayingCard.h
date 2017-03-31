//
//  PlayingCard.h
//  Machismo
//
//  Created by 刘江 on 2017/3/22.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (copy,nonatomic) NSString *suit;
@property (nonatomic) NSInteger rank;

+(NSArray *)validSuits;
+(NSArray *)rankStrings;
+(NSInteger)maxRank;

@end
