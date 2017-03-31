//
//  PlayingCardView.m
//  Machismo
//
//  Created by 刘江 on 2017/3/24.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

#pragma mark - Properties

-(void)setCard:(PlayingCard *)card{
    _card = card;
    [self setNeedsDisplay];
}

-(UIColor *)cardColor { return ([self.card.suit isEqualToString:@"♥︎"] || [self.card.suit isEqualToString:@"♦︎"]) ? [UIColor redColor] : [UIColor blackColor]; }

#pragma mark - Draw

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

-(void)drawRect:(CGRect)rect{
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.card.isChosen) {
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [PlayingCard rankStrings][self.card.rank], self.card.suit]];
        if (faceImage) {
            CGRect rect = CGRectInset(self.bounds,
                                       self.bounds.size.width * (1.0 - DEFAULT_FACE_CARD_SCALE_FACTOR),
                                       self.bounds.size.height * (1.0 - DEFAULT_FACE_CARD_SCALE_FACTOR));
            [faceImage drawInRect:rect];
        } else {
            [self drawPips];
        }
        
        [self drawCorners];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

#pragma mark - Corners

- (void)drawCorners{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:[cornerFont pointSize]* [self cornerScaleFactor]];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",[PlayingCard rankStrings][self.card.rank],self.card.suit] attributes:@{ NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName: [self cardColor]}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotationUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

#pragma mark - Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.150
#define PIP_VOFFSET2_PERCENTAGE 0.280
#define PIP_VOFFSET3_PERCENTAGE 0.270
#define PIP_VOFFSET4_PERCENTAGE 0.250

- (void)drawPips{
    if ((self.card.rank == 1) || (self.card.rank == 3) || (self.card.rank == 5)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0.030
                        mirroredVertically:NO];
    }
    if ((self.card.rank == 6) || (self.card.rank == 7)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0.030
                        mirroredVertically:NO];
    }
    if ((self.card.rank == 2) || (self.card.rank == 3) || (self.card.rank == 7) || (self.card.rank == 9) || (self.card.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET4_PERCENTAGE
                        mirroredVertically:(self.card.rank != 7 && self.card.rank != 9)];
    }
    if ((self.card.rank == 4) || (self.card.rank == 5) || (self.card.rank == 6) || (self.card.rank == 7) || (self.card.rank == 8) || (self.card.rank == 9) || (self.card.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:YES];
    }
    if ((self.card.rank == 8) || (self.card.rank == 9) || (self.card.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

#define PIP_FONT_SCALE_FACTOR 0.012

- (void)pushContextAndRotationUpsideDown{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)drawPipsWithHorizontalOffset: (CGFloat)hoffset verticalOffset: (CGFloat)voffset upsidedown: (BOOL)upsidedown{
    if(upsidedown) [self pushContextAndRotationUpsideDown];
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.card.suit attributes:@{ NSFontAttributeName : pipFont, NSForegroundColorAttributeName : [self cardColor]}];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width/2.0 - hoffset*self.bounds.size.width,
                                    middle.y - pipSize.width/2.0 - voffset*self.bounds.size.height);
    [attributedSuit drawAtPoint:pipOrigin];
    if(hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }

    if(upsidedown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset: (CGFloat)hoffset verticalOffset: (CGFloat)voffset mirroredVertically: (BOOL)mirroredVertically{
    if (mirroredVertically) [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsidedown:YES];
    
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsidedown:NO];
}

#pragma mark - Initialization

- (void)setup{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

@end
