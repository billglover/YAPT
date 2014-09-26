//
//  RoundButton.m
//  YAPT
//
//  Created by Bill Glover on 20/09/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import "RoundButton.h"
IB_DESIGNABLE

#define BUTTON_PADDING 2.0f

@interface RoundButton ()
@property (nonatomic, strong, readwrite) CAShapeLayer *outlineLayer;
@property (nonatomic, strong, readwrite) CAShapeLayer *progressLayer;
@end


@implementation RoundButton


// Only handle touch events inside the circle
// Code from: http://stackoverflow.com/questions/9871740/circle-button-on-ios
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // check we are inside the super view
    if(![super pointInside:point withEvent:event]) return NO;
    
    // check we are inside the circle
    CGFloat radius = self.bounds.size.width * 0.5f;
    CGFloat squareOfDistanceFromCentre = (radius - point.x)*(radius - point.x) + (radius - point.y)*(radius - point.y);
    if(squareOfDistanceFromCentre > radius*radius) return NO;
    
    // touch is inside the circle
    return YES;

}

- (id)initWithCoder:(NSCoder *)coder {

    self = [super initWithCoder:coder];

    if (self) {
        [self drawOutline];
        [self drawProgressBar];
    }

    return self;
}

- (void)prepareForInterfaceBuilder {
    [self drawOutline];
    [self drawProgressBar];
}

- (void) drawOutline {
    
    if (!self.outlineLayer) {
    
        // create a rounded shape layer
        self.outlineLayer = [CAShapeLayer layer];
        self.outlineLayer.frame = self.bounds;
        self.outlineLayer.cornerRadius = self.outlineLayer.bounds.size.width/2.0f;
        [self.layer setMasksToBounds:YES];
        
        // Gather some useful details about the geometry
        CGPoint center = CGPointMake(CGRectGetMidX(self.outlineLayer.bounds), CGRectGetMidY(self.outlineLayer.bounds));
        CGFloat radius = MIN(CGRectGetMidY(self.outlineLayer.bounds), CGRectGetMidX(self.outlineLayer.bounds)) - BUTTON_PADDING;
        
        // we want a clear background
        self.progressLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        self.outlineLayer.path = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
        self.outlineLayer.strokeColor = [[UIColor whiteColor] CGColor];
        self.outlineLayer.fillColor = [[UIColor clearColor] CGColor];
        self.outlineLayer.lineWidth = 1.0f;
        self.outlineLayer.opacity = 0.20f;
        self.outlineLayer.strokeStart = 0.0f;
        self.outlineLayer.strokeEnd = 1.0f;
        
        [self.layer insertSublayer:self.outlineLayer atIndex:0];
    }
}

- (void) drawProgressBar {
    
    if (!self.progressLayer) {
        
        // create a rounded shape layer
        self.progressLayer = [CAShapeLayer layer];
        self.progressLayer.frame = self.bounds;
        self.progressLayer.cornerRadius = self.progressLayer.bounds.size.width/2.0f;
        [self.progressLayer setMasksToBounds:YES];
        
        // Gather some useful details about the geometry
        CGPoint center = CGPointMake(CGRectGetMidX(self.progressLayer.bounds), CGRectGetMidY(self.progressLayer.bounds));
        CGFloat radius = MIN(CGRectGetMidY(self.progressLayer.bounds), CGRectGetMidX(self.progressLayer.bounds)) - BUTTON_PADDING;
        
        // we want a clear background
        self.progressLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        // draw the progress bar
        self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:center
                                                                 radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
        self.progressLayer.strokeColor = [[UIColor whiteColor] CGColor];
        self.progressLayer.fillColor = [[UIColor clearColor] CGColor];
        self.progressLayer.lineWidth = 2.5f;
        self.progressLayer.lineCap = kCALineCapRound;
        self.progressLayer.strokeStart = 0.0f;
        self.progressLayer.strokeEnd = 1.0f;
        
        // rotate so that we start at the 12 o'clock position
        self.progressLayer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 0.0, 1.0);

        [self.layer insertSublayer:self.progressLayer atIndex:0];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        
        // change the background color without action ("animation")
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.outlineLayer.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.25].CGColor;
        [CATransaction commit];
    } else {
        
        // change the background color without action ("animation")
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.outlineLayer.backgroundColor = [UIColor clearColor].CGColor;
        [CATransaction commit];
    }
    [self.outlineLayer setNeedsDisplay];
}

#pragma mark - Getters & Setters

- (void)setPercent:(CGFloat)percent {
    if (percent > 1.0f) {
        _percent = 1.0f;
    } else if (percent < 0.0f) {
        _percent = 0.0f;
    } else {
        _percent = percent;
    }
    
    // we need to re-draw
    NSLog(@"roundButton: percent = %f", _percent);
    self.progressLayer.strokeEnd = _percent;
}

@end
