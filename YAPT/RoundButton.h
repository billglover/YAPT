//
//  RoundButton.h
//  YAPT
//
//  Created by Bill Glover on 20/09/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundButton : UIButton
@property (nonatomic, readwrite) IBInspectable CGFloat percent;
@property (nonatomic, readwrite) IBInspectable CGFloat backgroundAlphaHighlighted;
@property (nonatomic, readwrite) IBInspectable CGFloat outlineAlpha;
@property (nonatomic, readwrite) IBInspectable CGFloat outlineWidth;
@property (nonatomic, readwrite) IBInspectable CGFloat progressBarWidth;
@property (nonatomic, readwrite) IBInspectable CGFloat buttonPadding;
@end

