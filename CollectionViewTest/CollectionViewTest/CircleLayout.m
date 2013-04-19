//
//  CircleLayout.m
//  CollectionViewTest
//
//  Created by Jeremias Nunez on 4/19/13.
//  Copyright (c) 2013 Jeremias Nunez. All rights reserved.
//

#import "CircleLayout.h"

@interface CircleLayout ()

// store these here just for practicality
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) CGPoint center;

@end

@implementation CircleLayout

#define ITEM_SIZE 70.0f

- (id)init
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

#pragma mark - UICollectionViewLayout methods
-(void)prepareLayout
{
    [super prepareLayout];
    
    CGSize size = self.collectionView.frame.size;
    
    // there's a slight but important difference when setting these params here rather than using init. this method gets called EVERY TIME the
    // layout is invalidated, so it could get called any number of times. putting this code in init only runs it when we create the instance
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    self.center = CGPointMake(size.width / 2.0f, size.height / 2.0f);
    self.radius = MIN(size.width, size.height) / 2.5f;
}

-(CGSize)collectionViewContentSize
{
    return [self collectionView].frame.size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    // this class does not extend FlowLayout, so we don't have any of the "standard" attributes for our cells. luckily for this
    // type of layout all we need to do is set the center right
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    
    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    attributes.center = CGPointMake(_center.x + _radius * cosf(2 * path.item * M_PI / self.cellCount),
                                    _center.y + _radius * sinf(2 * path.item * M_PI / self.cellCount));
    
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    
    for (int i = 0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes* cellAttribs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [attributes addObject:cellAttribs];
    }
    
    return attributes;
}

// these methods animate insertion/deletion of cells
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    attributes.alpha = 0.0f;
    attributes.center = CGPointMake(self.center.x, self.center.y);
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    attributes.alpha = 0.0f;
    attributes.center = CGPointMake(self.center.x, self.center.y);
    attributes.transform3D = CATransform3DMakeScale(0.1f, 0.1f, 1.0f);
    
    return attributes;
}

@end
