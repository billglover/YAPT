//
//  RoundButton.m
//  YAPT
//
//  Created by Bill Glover on 20/09/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import "RoundButton.h"
IB_DESIGNABLE

@interface RoundButton ()
@property (nonatomic, strong, readwrite) CAShapeLayer *outlineLayer;
@property (nonatomic, strong, readwrite) CAShapeLayer *progressLayer;
@property (nonatomic, strong, readwrite) CALayer *backgroundLayer;
@end

@implementation RoundButton

#pragma mark - Initialisation

- (void)awakeFromNib {
    [self drawBackground];
    [self drawOutline];
    [self drawProgressBar];
}

- (void)prepareForInterfaceBuilder {
    [self drawBackground];
    [self drawOutline];
    [self drawProgressBar];
}

#pragma mark - Drawing

- (void) drawBackground {
    if (!self.backgroundLayer) {
        
        // trim the background based on button padding
        self.backgroundLayer = [CALayer layer];
        self.backgroundLayer.frame = CGRectInset(self.bounds, self.buttonPadding, self.buttonPadding);
        self.backgroundLayer.cornerRadius = self.backgroundLayer.bounds.size.width/2.0f;
        
        // set the background
        self.backgroundLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        // add the layer to the button
        [self.layer insertSublayer:self.backgroundLayer atIndex:0];
    }
    
}

- (void) drawOutline {
    
    if (!self.outlineLayer) {
    
        // create a rounded shape layer
        self.outlineLayer = [CAShapeLayer layer];
        self.outlineLayer.frame = self.bounds;
        self.outlineLayer.cornerRadius = self.outlineLayer.bounds.size.width/2.0f;
        [self.outlineLayer setMasksToBounds:YES];
        
        // Gather some useful details about the geometry
        CGPoint center = CGPointMake(CGRectGetMidX(self.outlineLayer.bounds), CGRectGetMidY(self.outlineLayer.bounds));
        CGFloat radius = MIN(CGRectGetMidY(self.outlineLayer.bounds), CGRectGetMidX(self.outlineLayer.bounds)) - self.buttonPadding;
        
        // we want a clear background
        self.progressLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        // draw the outline
        self.outlineLayer.path = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
        self.outlineLayer.strokeColor = self.tintColor.CGColor;
        self.outlineLayer.fillColor = [[UIColor clearColor] CGColor];
        self.outlineLayer.lineWidth = self.outlineWidth;
        self.outlineLayer.opacity = self.outlineAlpha;
        self.outlineLayer.strokeStart = 0.0f;
        self.outlineLayer.strokeEnd = 1.0f;
        
        // add the layer to the button
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
        CGFloat radius = MIN(CGRectGetMidY(self.progressLayer.bounds), CGRectGetMidX(self.progressLayer.bounds)) - self.buttonPadding;
        
        // we want a clear background
        self.progressLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        // draw the progress bar
        self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:center
                                                                 radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
        self.progressLayer.strokeColor = self.tintColor.CGColor;
        self.progressLayer.fillColor = [[UIColor clearColor] CGColor];
        self.progressLayer.lineWidth = self.progressBarWidth;
        self.progressLayer.lineCap = kCALineCapRound;
        self.progressLayer.strokeStart = 0.0f;
        self.progressLayer.strokeEnd = self.percent;
        
        // rotate so that we start at the 12 o'clock position
        self.progressLayer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 0.0, 1.0);

        // add the layer to the button
        [self.layer insertSublayer:self.progressLayer atIndex:0];
    }
}

#pragma mark - User Interaction

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        
        // change the background color without action ("animation")
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.backgroundLayer.backgroundColor = self.tintColor.CGColor;
        self.backgroundLayer.opacity = self.backgroundAlphaHighlighted;
        [CATransaction commit];
    } else {
        
        // change the background color without action ("animation")
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.backgroundLayer.backgroundColor = [UIColor clearColor].CGColor;
        [CATransaction commit];
    }
    
    // redraw the background
    [self.outlineLayer setNeedsDisplay];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    // Only handle touch events inside the circle
    // Code from: http://stackoverflow.com/questions/9871740/circle-button-on-ios
    
    // check we are inside the super view
    if(![super pointInside:point withEvent:event]) return NO;
    
    // check we are inside the circle
    CGFloat radius = self.bounds.size.width * 0.5f;
    CGFloat squareOfDistanceFromCentre = (radius - point.x)*(radius - point.x) + (radius - point.y)*(radius - point.y);
    if(squareOfDistanceFromCentre > radius*radius) return NO;
    
    // touch is inside the circle
    return YES;
    
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
    
    // re-draw the progress bar
    self.progressLayer.strokeEnd = _percent;
    [self.progressLayer setNeedsDisplay];
}

@end
