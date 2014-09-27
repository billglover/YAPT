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
@property (nonatomic, readwrite) IBInspectable CGFloat backgroundAlpha;
@end

// TODO: use IBInspectable properties to set the alpha
// TODO: use IBInspectable properties to set the progress width