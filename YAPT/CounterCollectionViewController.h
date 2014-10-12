//
//  CounterViewControllerCollectionViewController.h
//  YAPT
//
//  Created by Bill Glover on 11/10/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChalkCollectionViewCell.h"

@interface CounterCollectionViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, readwrite) NSInteger count;

@end
