//
//  ILActionsViewController.m
//  CollectionViewTest
//
//  Created by Jeremias Nunez on 4/16/13.
//  Copyright (c) 2013 Jeremias Nunez. All rights reserved.
//

#import "ILActionsViewController.h"
#import "RegularFlowLayout.h"
#import "LineLayout.h"
#import "PinchLayout.h"

typedef enum {
    RegularLayoutType,
    LineLayoutType,
    PinchLayoutType
} LayoutType;

@interface ILActionsViewController ()

// UI properties
@property (nonatomic, weak) IBOutlet UISlider *itemWidthSlider;
@property (nonatomic, weak) IBOutlet UISlider *itemHeightSlider;
@property (nonatomic, weak) IBOutlet UISegmentedControl *scrollDirectionControl;
@property (nonatomic, weak) IBOutlet UISlider *lineSpacingSlider;
@property (nonatomic, weak) IBOutlet UISlider *itemSpacingSlider;
@property (nonatomic, weak) IBOutlet UISlider *sectionInsetSlider;

@property (nonatomic, weak) IBOutlet UILabel *itemWidthLabel;
@property (nonatomic, weak) IBOutlet UILabel *itemHeightLabel;
@property (nonatomic, weak) IBOutlet UILabel *lineSpacingLabel;
@property (nonatomic, weak) IBOutlet UILabel *itemSpacingLabel;
@property (nonatomic, weak) IBOutlet UILabel *sectionInsetLabel;

// Non-UI properties
@property (nonatomic, strong) NSIndexPath* selectedLayoutPath;
@property (nonatomic, assign) LayoutType currentLayout;

// IBActions
- (IBAction)itemWidthValueChanged:(id)sender;
- (IBAction)itemHeightValueChanged:(id)sender;
- (IBAction)scrollDirectionValueChanged:(id)sender;
- (IBAction)lineSpacingValueChanged:(id)sender;
- (IBAction)itemSpacingValueChanged:(id)sender;
- (IBAction)sectionInsetValueChanged:(id)sender;

// Private methods
- (void)resetCustomizationControlValues;
- (void)toggleCustomizationControls:(BOOL)value;

@end

@implementation ILActionsViewController

#pragma mark - View Lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // get the type of layout we have so we can put a checkmark next to it
    UICollectionViewLayout* layout = self.collectionView.collectionViewLayout;
    
    if ([layout isKindOfClass:[RegularFlowLayout class]]) {
        self.currentLayout = RegularLayoutType;
        self.selectedLayoutPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    
    if ([layout isKindOfClass:[LineLayout class]]) {
        self.currentLayout = LineLayoutType;
        self.selectedLayoutPath = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    
    if ([layout isKindOfClass:[PinchLayout class]]) {
        self.currentLayout = PinchLayoutType;
        self.selectedLayoutPath = [NSIndexPath indexPathForRow:2 inSection:1];
    }
    
    [self resetCustomizationControlValues];
}

#pragma mark - IBActions
- (IBAction)itemWidthValueChanged:(id)sender;
{
    UISlider* widthControl = (UISlider*)sender;
    float newWidth = widthControl.value;
    
    self.itemWidthLabel.text = [NSString stringWithFormat:@"%.0f", newWidth];
    
    [self.collectionView performBatchUpdates:^{
        
        UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
        flowLayout.itemSize = CGSizeMake(newWidth, flowLayout.itemSize.height);
        
    } completion:nil];
}

- (IBAction)itemHeightValueChanged:(id)sender;
{
    UISlider* heightControl = (UISlider*)sender;
    float newHeight = heightControl.value;
    
    self.itemHeightLabel.text = [NSString stringWithFormat:@"%.0f", newHeight];
    
    [self.collectionView performBatchUpdates:^{
        
        UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
        flowLayout.itemSize = CGSizeMake(flowLayout.itemSize.width, newHeight);
        
    } completion:nil];
}

- (IBAction)scrollDirectionValueChanged:(id)sender
{
    UISegmentedControl* scrollDirectionControl = (UISegmentedControl*)sender;
    
    UICollectionViewScrollDirection newDirection = (scrollDirectionControl.selectedSegmentIndex == 0) ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
    
    [self.collectionView performBatchUpdates:^{
        
        UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
        flowLayout.scrollDirection = newDirection;
        
    } completion:nil];
}

- (IBAction)lineSpacingValueChanged:(id)sender
{
    UISlider* lineSpacingControl = (UISlider*)sender;
    float newLineSpacing = lineSpacingControl.value;
    
    self.lineSpacingLabel.text = [NSString stringWithFormat:@"%.0f", newLineSpacing];
    
    [self.collectionView performBatchUpdates:^{
        
        UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
        flowLayout.minimumLineSpacing = newLineSpacing;
        
    } completion:nil];
}

- (IBAction)itemSpacingValueChanged:(id)sender
{
    UISlider* itemSpacingControl = (UISlider*)sender;
    float newItemSpacing = itemSpacingControl.value;
    
    self.itemSpacingLabel.text = [NSString stringWithFormat:@"%.0f", newItemSpacing];
    
    [self.collectionView performBatchUpdates:^{
        
        UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
        flowLayout.minimumInteritemSpacing = newItemSpacing;
        
    } completion:nil];
}

- (IBAction)sectionInsetValueChanged:(id)sender
{
    UISlider* sectionInsetControl = (UISlider*)sender;
    float newInset = sectionInsetControl.value;
    
    self.sectionInsetLabel.text = [NSString stringWithFormat:@"%.0f", newInset];
    
    [self.collectionView performBatchUpdates:^{
        
        UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
        flowLayout.sectionInset = UIEdgeInsetsMake(newInset, newInset, newInset, newInset);
        
    } completion:nil];
}

#pragma mark - UITableViewDataSource methods
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView
                       cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 1 && indexPath.row == self.selectedLayoutPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 1 || self.selectedLayoutPath.row == indexPath.row) {
        return;
    }
    
    self.selectedLayoutPath = indexPath;
    
    switch (indexPath.row) {
        case 0:
            self.currentLayout = RegularLayoutType;
            break;
        case 1:
            self.currentLayout = LineLayoutType;
            break;
        case 2:
            self.currentLayout = PinchLayoutType;
            break;
            
        default:
            break;
    }
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView reloadData];
}

#pragma mark - Setter methods
- (void)setCurrentLayout:(LayoutType)newLayout
{
    if (newLayout == _currentLayout) {
        return;
    }
    
    _currentLayout = newLayout;
    UICollectionViewLayout* layout = nil;
    
    switch (newLayout) {
        case RegularLayoutType:
        {
            layout = [[RegularFlowLayout alloc] init];
            // we can customize anything we want here
            [self toggleCustomizationControls:YES];
            
            break;
        }
        case LineLayoutType:
        {
            layout = [[LineLayout alloc] init];
            // the layout parameters are specifically customized to achieve this look, if we changed them we'll lose it.
            // that's why we'll disable them
            [self toggleCustomizationControls:NO];
            
            break;
        }
        case PinchLayoutType:
        {
            layout = [[PinchLayout alloc] init];
            [self toggleCustomizationControls:YES];
        }
            
        default:
            break;
    }
    
    self.collectionView.collectionViewLayout = layout;
    
    [self resetCustomizationControlValues];
}

#pragma mark - Private methods
- (void)resetCustomizationControlValues
{
    UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    
    int currentScrollDirection = (flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical) ? 0 : 1;
    
    [self.itemWidthSlider setValue:flowLayout.itemSize.width];
    [self.itemHeightSlider setValue:flowLayout.itemSize.height];
    [self.lineSpacingSlider setValue:flowLayout.minimumLineSpacing];
    [self.itemSpacingSlider setValue:flowLayout.minimumInteritemSpacing];
    [self.sectionInsetSlider setValue:flowLayout.sectionInset.top];
    [self.scrollDirectionControl setSelectedSegmentIndex:currentScrollDirection];
    
    self.itemWidthLabel.text = [NSString stringWithFormat:@"%.0f", flowLayout.itemSize.width];
    self.itemHeightLabel.text = [NSString stringWithFormat:@"%.0f", flowLayout.itemSize.height];
    self.lineSpacingLabel.text = [NSString stringWithFormat:@"%.0f", flowLayout.minimumLineSpacing];
    self.itemSpacingLabel.text = [NSString stringWithFormat:@"%.0f", flowLayout.minimumInteritemSpacing];
    self.sectionInsetLabel.text = [NSString stringWithFormat:@"%.0f", flowLayout.sectionInset.top];
}

- (void)toggleCustomizationControls:(BOOL)value
{
    self.itemWidthSlider.enabled = value;
    self.itemHeightSlider.enabled = value;
    self.lineSpacingSlider.enabled = value;
    self.itemSpacingSlider.enabled = value;
    self.sectionInsetSlider.enabled = value;
    self.scrollDirectionControl.enabled = value;
    
    self.itemWidthLabel.enabled = value;
    self.itemHeightLabel.enabled = value;
    self.lineSpacingLabel.enabled = value;
    self.itemSpacingLabel.enabled = value;
    self.sectionInsetLabel.enabled = value;
}

@end
