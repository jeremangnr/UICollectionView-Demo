//
//  PinchLayout.m
//  CollectionViewTest
//
//  Created by Jeremias Nunez on 4/17/13.
//  Copyright (c) 2013 Jeremias Nunez. All rights reserved.
//

#import "PinchLayout.h"

@implementation PinchLayout

- (id)init
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

#pragma mark - UICollectionViewLayout methods
- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* attribsArray = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes* attributes in attribsArray) {
        
        if ([attributes.indexPath isEqual:self.pinchedCellPath]) {
            // zoom in and move the selected cell according to the gesture params
            CATransform3D pinchZoomTransform = CATransform3DMakeScale(self.pinchedCellScale, self.pinchedCellScale, 1.0f);
            CATransform3D rotationTransform = CATransform3DMakeRotation(self.pinchedCellRotationAngle, 0.0f, 0.0f, 1.0f);
            
            attributes.transform3D = CATransform3DConcat(pinchZoomTransform, rotationTransform);
            attributes.center = self.pinchedCellCenter;
            attributes.zIndex = 1;
            
            // in this case we are only interested in this cell
            break;
        }
        
    }
    
    return attribsArray;
}


#pragma mark - Setter methods
- (void)setPinchedCellScale:(CGFloat)scale
{
    if (_pinchedCellScale == scale) {
        return;
    }
    
    _pinchedCellScale = scale;
    [self invalidateLayout];
}

- (void)setPinchedCellCenter:(CGPoint)origin
{
    if (CGPointEqualToPoint(_pinchedCellCenter, origin)) {
        return;
    }
    
    _pinchedCellCenter = origin;
    [self invalidateLayout];
}

- (void)setPinchedCellRotationAngle:(CGFloat)pinchedCellRotationAngle
{
    if (_pinchedCellRotationAngle == pinchedCellRotationAngle) {
        return;
    }
    
    _pinchedCellRotationAngle = pinchedCellRotationAngle;
    [self invalidateLayout];
}

@end
