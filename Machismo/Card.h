//
//  Card.h
//  Machismo
//
//  Created by 刘江 on 2017/3/22.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic,copy) NSString *contents;

@property (nonatomic,getter=isChosen) BOOL chosen;
@property (nonatomic,getter=isMatch) BOOL matched;

-(int)match:(NSArray *)otherCards;
@end
