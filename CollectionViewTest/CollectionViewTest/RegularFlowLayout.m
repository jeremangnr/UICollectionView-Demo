//
//  RegularFlowLayout.m
//  CollectionViewTest
//
//  Created by Jeremias Nunez on 4/17/13.
//  Copyright (c) 2013 Jeremias Nunez. All rights reserved.
//

#import "RegularFlowLayout.h"

@implementation RegularFlowLayout

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.itemSize = CGSizeMake(120.0f, 120.0f);
        self.sectionInset = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 10.0f;
        self.minimumInteritemSpacing = 10.0f;
        
    }
    
    return self;
}

@end
