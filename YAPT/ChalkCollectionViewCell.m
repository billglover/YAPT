//
//  ChalkCollectionViewCell.m
//  YAPT
//
//  Created by Bill Glover on 11/10/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import "ChalkCollectionViewCell.h"

// Constants that affect the geometry
#define SKEW_OFFSET 3
#define FRAME_OFFSET_PERCENT 0.2

// Constants that define the basic counter
#define COUNTER_MAX 5
#define COUNTER_MIN 0

@implementation ChalkCollectionViewCell

#pragma mark - Initialisation

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)prepareForReuse {
    self.count = 0;
    [self.contentView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

#pragma mark - Getters and Setters

- (void)setCount:(NSInteger)count {
    
    // make sure we keep the counter within bounds
    if (count > COUNTER_MAX) {
        NSLog(@"Attemt to set count to %lu. Capping at maximum allowed value of %d", (long)count, COUNTER_MAX);
        _count = COUNTER_MAX;
    } else if (count < COUNTER_MIN) {
        NSLog(@"Attemt to set count to %lu. Capping at minimum allowed value of %d", (long)count, COUNTER_MIN);
        _count = COUNTER_MIN;
    } else {
        _count = count;
    }
    
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [self drawStrokeCountInRect:rect];
}

- (void)drawStrokeCountInRect:(CGRect)rect {
    for (int i = 1; i <= self.count; i++) {
        [self drawStroke:i
                  inRect:rect];
    }
}

- (void)drawStroke:(int)stroke inRect:(CGRect)rect {
    
    // give ourselves a frame in which to work
    rect = CGRectInset(rect, rect.size.width * FRAME_OFFSET_PERCENT, rect.size.height * FRAME_OFFSET_PERCENT);
    
    // give ourselves some tools to work with
    CGPoint startOfLine = CGPointZero;
    CGPoint endOfLine = CGPointZero;
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // the first four strokes are vertical lines
    if (stroke < COUNTER_MAX) {
        double lineSeparation = rect.size.width / 3.0;
        double x = rect.origin.x + ((stroke - 1) * lineSeparation);
        startOfLine = CGPointMake(x, rect.origin.y);
        endOfLine = CGPointMake(x, rect.origin.y + rect.size.height);
        
    // the list stroke is a strike through the first four
    } else if (stroke == COUNTER_MAX) {
        startOfLine = CGPointMake(rect.origin.x - SKEW_OFFSET, rect.origin.y + rect.size.height - SKEW_OFFSET);
        endOfLine = CGPointMake(rect.origin.x + rect.size.width + SKEW_OFFSET, rect.origin.y + SKEW_OFFSET);
    }
    
    // move to the start of the line and then stroke to the end
    [path moveToPoint:startOfLine];
    [path addLineToPoint:endOfLine];
    
    // add the stroke to the frame and set some properties
    pathLayer.frame = self.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor whiteColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 2.0f;
    pathLayer.lineCap = kCALineCapRound;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (self.animateFinalStroke && stroke == self.count) {
        pathAnimation.duration = stroke == self.count ? 0.1 : 0.0;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    }
    
    // add this layer to the parent view
    [self.contentView.layer addSublayer:pathLayer];

}

    
@end
