//
//  LineLayout.m
//  CollectionViewTest
//
//  Created by Jeremias Nunez on 4/17/13.
//  Copyright (c) 2013 Jeremias Nunez. All rights reserved.
//

#import "LineLayout.h"

@interface LineLayout ()

- (UIEdgeInsets)sectionInsetsForCurrentInterfaceOrientation;

@end

@implementation LineLayout

#define ACTIVE_DISTANCE 200.0f
#define ZOOM_FACTOR 0.3f

/**
 * Here's a totally obvious but no-so-easy-to-see condition regarding itemSize I came across while testing:
 *
 * item height <= collectionView.bounds.size.height - (top section inset + bottom section inset)
 * item width <= collectionView.bounds.size.widt - (left section inset + right section inset)
 **/
#define ITEM_SIZE 200.0f

#define SECTION_INSETS_PORTRAIT UIEdgeInsetsMake(300.0f, 0.0f, 300.0f, 0.0f)
#define SECTION_INSETS_LANDSCAPE UIEdgeInsetsMake(200.0f, 0.0f, 200.0f, 0.0f);

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.itemSize = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = [self sectionInsetsForCurrentInterfaceOrientation];
        self.minimumLineSpacing = 50.0f;
        
    }
    
    return self;
}

#pragma mark - Private methods
- (UIEdgeInsets)sectionInsetsForCurrentInterfaceOrientation
{
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        return SECTION_INSETS_PORTRAIT;
    } else {
        return SECTION_INSETS_LANDSCAPE;
    }
}

#pragma mark - UICollectionViewLayout methods
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    // update the layout (redraw) when we scroll throught it, we do this so we can zoom in on the center element
    // we also update the section inset here (it's bigger for portrait) so we always have ONE row, maintaining the "line" layout
    self.sectionInset = [self sectionInsetsForCurrentInterfaceOrientation];
    
    return YES;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* attribsArray = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect = CGRectZero;
    
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in attribsArray) {
        // we'll apply a small zoom to the items that are on the visible area
        if (CGRectIntersectsRect(attributes.frame, visibleRect)) {
            // do some weird math
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0f);
                // put on top
                attributes.zIndex = 1;
            }
        }
    }
    
    return attribsArray;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // adjust the offset so that when we finish scrolling, the target cell is centered in the scroll properly
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0f);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0f, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray* attribsArray = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in attribsArray) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
