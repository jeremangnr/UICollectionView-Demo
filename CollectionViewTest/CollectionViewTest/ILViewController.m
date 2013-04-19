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
#import "PinchLayout.h"

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
    
    // init with default flow layout with some customized params (check init to see them)
    RegularFlowLayout* flowLayout = [[RegularFlowLayout alloc] init];
    
    self.collectionView.collectionViewLayout = flowLayout;
    
    // add pinch recognizer to use with pinch layout
    UIRotationGestureRecognizer* rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(handleRotationGesture:)];
    
    UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handlePinchGesture:)];
    
    pinchRecognizer.delegate = self;
    
    [self.collectionView addGestureRecognizer:rotationRecognizer];
    [self.collectionView addGestureRecognizer:pinchRecognizer];
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

#pragma mark - UIGestureRecognizer handling methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer*)sender
{
    if (![self.collectionView.collectionViewLayout isKindOfClass:[PinchLayout class]]) {
        return;
    }
    
    PinchLayout* layout = (PinchLayout*)self.collectionView.collectionViewLayout;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        // get the index path of the pinched cell, we need this so we now on which cell to apply the pinch attributes
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath* pinchedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        
        layout.pinchedCellPath = pinchedCellPath;
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        // update when moving or pinching
        layout.pinchedCellScale = sender.scale;
        layout.pinchedCellCenter = [sender locationInView:self.collectionView];
        
    } else {
        
        [self.collectionView performBatchUpdates:^{
            
            layout.pinchedCellPath = nil;
            layout.pinchedCellScale = 1.0f;
            layout.pinchedCellRotationAngle = 0.0f;
            
        } completion:nil];
        
    }
}

- (void)handleRotationGesture:(UIRotationGestureRecognizer*)sender
{
    if (![self.collectionView.collectionViewLayout isKindOfClass:[PinchLayout class]]) {
        return;
    }
    
    PinchLayout* layout = (PinchLayout*)self.collectionView.collectionViewLayout;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        // get the index path of the pinched cell, we need this so we now on which cell to apply the rotation attributes
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath* pinchedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        
        layout.pinchedCellPath = pinchedCellPath;
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        layout.pinchedCellRotationAngle = sender.rotation;
        layout.pinchedCellCenter = [sender locationInView:self.collectionView];
        
    } else {
        
        [self.collectionView performBatchUpdates:^{
            
            layout.pinchedCellPath = nil;
            layout.pinchedCellScale = 1.0f;
            layout.pinchedCellRotationAngle = 0.0f;
            
        } completion:nil];
        
    }
}

@end
