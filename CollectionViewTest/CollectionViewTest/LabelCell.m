//
//  CustomCell.m
//  CollectionViewTest
//
//  Created by Jeremias Nunez on 4/17/13.
//  Copyright (c) 2013 Jeremias Nunez. All rights reserved.
//

#import "LabelCell.h"

@implementation LabelCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.textLabel.backgroundColor = [UIColor underPageBackgroundColor];
        self.textLabel.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:self.textLabel];
        
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }
    
    return self;
}

@end
