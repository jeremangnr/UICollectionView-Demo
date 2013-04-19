//
//  RoundedCell.m
//  CollectionViewTest
//
//  Created by Jeremias Nunez on 4/19/13.
//  Copyright (c) 2013 Jeremias Nunez. All rights reserved.
//

#import "RoundedCell.h"

@implementation RoundedCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.contentView.layer.cornerRadius = 35.0f;
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.contentView.backgroundColor = [UIColor underPageBackgroundColor];
        
    }
    
    return self;
}

@end
