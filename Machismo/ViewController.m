//
//  ViewController.m
//  Machismo
//
//  Created by 刘江 on 2017/3/21.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "ViewController.h"
#import "PlayingDeck.h"
#import "CardMatchingGame.h"
#import "PlayingCardView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(PlayingCardView) NSArray *playingCardViews;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingDeck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation ViewController


-(CardMatchingGame *)game{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.playingCardViews count] usingDeck:self.deck];
    }
    return _game;
}

-(PlayingDeck *)deck{
    if (!_deck) {
        _deck = [[PlayingDeck alloc] init];
    }
    return _deck;
}


-(void)tap:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        NSInteger chosenButtonIndex = [self.playingCardViews indexOfObject:gesture.view];
        [self.game chooseCardAtIndex:chosenButtonIndex];
        [self updateUI];
        self.flipCount++;
    }
}

-(void)updateUI{
    for (PlayingCardView *playcardView in self.playingCardViews) {
        NSInteger viewIndex = [self.playingCardViews indexOfObject:playcardView];
        Card *card = [self.game cardAtIndex:viewIndex];
        playcardView.card = (PlayingCard *)card;
        playcardView.userInteractionEnabled = !card.isMatch;
        if (card.isMatch) {
            playcardView.alpha = 0.3f;
        }
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld",self.game.score];
    }
}

-(NSMutableAttributedString *)titleForCard:(Card *)card {
    if (!card.isChosen) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:card.contents];
    if ([card.contents hasSuffix:@"♥︎"] || [card.contents hasSuffix:@"♦︎"]) {
        [title setAttributes:@{ NSForegroundColorAttributeName: [UIColor redColor]
                                } range:NSMakeRange(0, [title length])];
    } else {
        [title setAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor]
                                } range:NSMakeRange(0, [title length])];
    }
    
    return title;
}

-(UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    for (PlayingCardView *view in self.playingCardViews) {
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }
}



@end
