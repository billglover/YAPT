//
//  RoundButton.m
//  YAPT
//
//  Created by Bill Glover on 20/09/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import "RoundButton.h"
IB_DESIGNABLE
@implementation RoundButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect innerRect = CGRectInset(rect, 2.0f, 2.0f);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextAddEllipseInRect(context, innerRect);
    CGContextStrokePath(context);
    
    if (self.state == UIControlStateHighlighted) {
        CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:1.0f alpha:0.08f].CGColor);
        CGContextFillEllipseInRect(context, innerRect);
    }
    
}

- (void)setHighlighted:(BOOL)highlighted {
    
    [super setHighlighted:highlighted];
    
    [self setNeedsDisplay];
}

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

-(void)awakeFromNib {
    
    // Add some padding to the button content
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    [self setContentEdgeInsets:contentInsets];
    [self sizeToFit];
   
    
    // If we need to force a 1:1 aspect ratio in code.
    // For now we will do this in Interface Builder.
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0/1.0 // 1:1
                                                                   constant:0.0f];
    [self addConstraint:constraint];
    
}

@end
