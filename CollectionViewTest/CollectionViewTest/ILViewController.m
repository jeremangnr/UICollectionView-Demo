//
//  ILViewController.m
//  CollectionViewTest
//
//  Created by Jeremias Nunez on 4/15/13.
//  Copyright (c) 2013 Jeremias Nunez. All rights reserved.
//

#import "ILViewController.h"
#import "LabelCell.h"
#import "RoundedCell.h"
#import "RegularFlowLayout.h"
#import "PinchLayout.h"
#import "CircleLayout.h"

@interface ILViewController ()

// UI Properties
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIButton *addCellButton;
@property (nonatomic, weak) IBOutlet UILabel *deleteCellLabel;


// Non-UI Properties
@property (nonatomic, weak) UIPopoverController *actionsPopover;
@property (nonatomic, assign) int items;

// Gesture Recognizers
@property (nonatomic, strong) UIPinchGestureRecognizer* pinchRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer* rotationRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer* tapRecognizer;

// IBActions
- (IBAction)addCellButtonPressed:(id)sender;

// Private methods
- (void)handlePinchGesture:(UIPinchGestureRecognizer*)sender;
- (void)handleRotationGesture:(UIRotationGestureRecognizer*)sender;
- (void)handleTapGesture:(UITapGestureRecognizer*)sender;

@end

@implementation ILViewController

#pragma mark - View Lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // observe changes on the collection view's layout so we can update our data source if needed
    [self.collectionView addObserver:self
                          forKeyPath:@"collectionViewLayout"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
    
    [self.collectionView registerClass:[LabelCell class] forCellWithReuseIdentifier:@"LabelCell"];
    [self.collectionView registerClass:[RoundedCell class] forCellWithReuseIdentifier:@"RoundedCell"];
    
    // init with default flow layout with some customized params (check init to see them)
    RegularFlowLayout* flowLayout = [[RegularFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = flowLayout;
    
    _rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    
    self.pinchRecognizer.delegate = self;
    self.rotationRecognizer.delegate = self;
    self.tapRecognizer.delegate = self;
    
    [self.collectionView addGestureRecognizer:self.rotationRecognizer];
    [self.collectionView addGestureRecognizer:self.pinchRecognizer];
    [self.collectionView addGestureRecognizer:self.tapRecognizer];
    
    self.pinchRecognizer.enabled = NO;
    self.rotationRecognizer.enabled = NO;
    self.tapRecognizer.enabled = NO;
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* labelCellIdentifier = @"LabelCell";
    static NSString* roundedCellIdentifier = @"RoundedCell";
    
    UICollectionViewLayout* layout = collectionView.collectionViewLayout;
    BOOL isFlowLayout = [layout isKindOfClass:[UICollectionViewFlowLayout class]];
    
    NSString* identifier =  isFlowLayout ? labelCellIdentifier : roundedCellIdentifier;
    UICollectionViewCell* cell = nil;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                     forIndexPath:indexPath];
    
    if (isFlowLayout) {
        ((LabelCell*)cell).textLabel.text = [layout isKindOfClass:[PinchLayout class]] ? @"Pinch Me!" : [NSString stringWithFormat:@"%i", indexPath.row];
    }
    
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

#pragma mark - UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIGestureRecognizer handling methods
- (void)handlePinchGesture:(UIPinchGestureRecognizer*)sender
{
    // these are only used in the PinchLayout
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
    // these are only used in the PinchLayout
    if (![self.collectionView.collectionViewLayout isKindOfClass:[PinchLayout class]]) {
        return;
    }
    
    PinchLayout* layout = (PinchLayout*)self.collectionView.collectionViewLayout;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        // get the index path of the pinched cell, we need this so we know on which cell to apply the rotation attributes
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

- (void)handleTapGesture:(UITapGestureRecognizer*)sender
{
    if (![self.collectionView.collectionViewLayout isKindOfClass:[CircleLayout class]]) {
        return;
    }
    
    CGPoint tapLocation = [sender locationInView:self.collectionView];
    NSIndexPath* tappedItemIndexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    
    if (tappedItemIndexPath) {
        
        self.items--;
        
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:tappedItemIndexPath]];
        } completion:nil];
        
    }
}

#pragma mark - NSKeyValueObserving methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"collectionViewLayout"]) {
        UICollectionViewLayout* layout = [change objectForKey:NSKeyValueChangeNewKey];
        
        // reset values
        self.items = 60;
        self.addCellButton.hidden = YES;
        self.deleteCellLabel.hidden = YES;
        self.pinchRecognizer.enabled = NO;
        self.rotationRecognizer.enabled = NO;
        self.tapRecognizer.enabled = NO;
        
        // the "add cell" button is only used in the circle layout
        if ([layout isKindOfClass:[CircleLayout class]]) {
            self.items = 20;
            
            // unhide buttons
            self.addCellButton.hidden = NO;
            self.deleteCellLabel.hidden = NO;
            
            // used to delete cells by tapping on them
            self.tapRecognizer.enabled = YES;
        }
        
        if ([layout isKindOfClass:[PinchLayout class]]) {
            self.pinchRecognizer.enabled = YES;
            self.rotationRecognizer.enabled = YES;
        }
        
        [self.collectionView reloadData];
    }
}

#pragma mark - IBActions
- (IBAction)addCellButtonPressed:(id)sender
{
    self.items++;
    
    NSIndexPath* insertPath = [NSIndexPath indexPathForRow:self.items - 1 inSection:0];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:insertPath]];
    } completion:nil];
}
@end
