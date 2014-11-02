//
//  ChalkCollectionViewCell.h
//  YAPT
//
//  Created by Bill Glover on 11/10/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChalkCollectionViewCell : UICollectionViewCell
@property (nonatomic, readwrite) NSInteger count;
@property (nonatomic, readwrite) BOOL animateFinalStroke;
@end
