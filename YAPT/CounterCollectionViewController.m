//
//  CounterViewControllerCollectionViewController.m
//  YAPT
//
//  Created by Bill Glover on 11/10/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import "CounterCollectionViewController.h"

#define NUMBER_OF_ITEMS 30

@interface CounterCollectionViewController ()

@end

@implementation CounterCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ChalkCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self numberOfBlocksForCount:self.count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChalkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSLog(@"Fetching cell for block %lu which has %lu strokes", (long)indexPath.item, (long)[self numberOfStrokesForBlock:indexPath.item]);
    
    cell.count = [self numberOfStrokesForBlock:indexPath.item];
    
    return cell;
}

- (NSInteger)numberOfBlocksForCount:(NSInteger)count {
    if (count == 0) return 0;
    
    NSInteger blocks = (int)(self.count / 5) + 1;
    
    return blocks;
    
}

- (NSInteger)numberOfStrokesForBlock:(NSInteger)block {
    
    NSInteger strokes;
    NSInteger totalBlocks = [self numberOfBlocksForCount:self.count];
    
    if (block + 1 < totalBlocks) {
        strokes = 5;
    } else {
        strokes = (NSInteger)(self.count % 5) + 1;
    }
    
    return strokes;
    
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - Layout
/*
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    double area = collectionView.frame.size.height * collectionView.frame.size.width;
    double cellArea = area / NUMBER_OF_ITEMS;
    double cellWidth = 60.0;
    double cellHeight = cellArea / cellWidth;
    
    return CGSizeMake(cellWidth, cellHeight);
}
*/

@end
