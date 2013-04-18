//
//  ILViewController.m
//  CollectionViewTest
//
//  Created by Jeremias Nunez on 4/15/13.
//  Copyright (c) 2013 Jeremias Nunez. All rights reserved.
//

#import "ILViewController.h"
#import "CustomCell.h"
#import "RegularFlowLayout.h"
#import "LineLayout.h"

@interface ILViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) UIPopoverController *actionsPopover;

@end

@implementation ILViewController

#pragma mark - View Lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[CustomCell class]
            forCellWithReuseIdentifier:@"CustomCell"];
    
    // init with default flow layout with some customized params
    RegularFlowLayout* flowLayout = [[RegularFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = flowLayout;
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 60;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"CustomCell";
    
    CustomCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                 forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%i", indexPath.row];
    
    return cell;
}

#pragma mark - UIStoryboardSegue methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowActionsPopover"]) {
        
        ILActionsViewController* actionsVC = segue.destinationViewController;
        actionsVC.collectionView = self.collectionView;
        
        // we store the popover in case we press the action button again. we don't want to present another popover on top
        self.actionsPopover = ((UIStoryboardPopoverSegue*)segue).popoverController;
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowActionsPopover"] && self.actionsPopover) {
        
        [self.actionsPopover dismissPopoverAnimated:YES];
        return NO;
        
    } else {
        return YES;
    }
}

@end
