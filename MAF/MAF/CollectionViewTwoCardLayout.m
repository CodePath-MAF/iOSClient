//
//  CollectionViewTwoCardLayout.m
//  MAF
//
//  Created by Eddie Freeman on 7/19/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "CollectionViewTwoCardLayout.h"

static NSString * const GoalCardLayoutCellKind = @"GoalCardView";

@interface CollectionViewTwoCardLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic) UIEdgeInsets itemInsets;

@end

@implementation CollectionViewTwoCardLayout

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    NSLog(@"Setting Up Layout");
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.itemInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    self.minimumLineSpacing = 10.0f;
    self.minimumInteritemSpacing = 10.0f;
//    CGFloat itemHeight = (self.collectionView.bounds.size.height/2) - (self.sectionInset.bottom + self.minimumLineSpacing + self.sectionInset.top); // make room for two cards, do we use top inset?
//    CGFloat itemWidth = self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right);
//    
//    NSLog(@"itemHeight %0.2f", itemHeight);
//    NSLog(@"itemHeight %0.2f", itemWidth);
//    self.itemSize = CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - Layout

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForGoalCardAtIndexPath:indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[GoalCardLayoutCellKind] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[GoalCardLayoutCellKind][indexPath];
}

- (CGSize)collectionViewContentSize {
    NSInteger sections = [self.collectionView numberOfSections];
    CGFloat height = self.sectionInset.top + self.sectionInset.bottom + sections * self.itemSize.height + (sections - 1) * self.minimumInteritemSpacing;
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}


- (CGRect)frameForGoalCardAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemHeight = (self.collectionView.bounds.size.height/2) - (self.minimumLineSpacing + self.itemInsets.bottom/2); // make room for two cards, do we use top inset?
    CGFloat itemWidth = self.collectionView.bounds.size.width - (self.itemInsets.left + self.itemInsets.right);
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    CGFloat originX = floor(self.itemInsets.left); // + indexPath.item * (self.itemSize.width + self.minimumInteritemSpacing)
    CGFloat originY = floor(self.itemInsets.top + indexPath.item * (self.itemSize.height + self.minimumLineSpacing));
    
    NSLog(@"collectionView Height: %0.2f", self.collectionView.bounds.size.height);
    
    NSLog(@"Item #%d", indexPath.item);
    NSLog(@"OriginX: %0.2f", originX);
    NSLog(@"OriginY: %0.2f", originY);
    NSLog(@"itemHeight %0.2f", itemHeight);
    NSLog(@"itemWidth %0.2f", itemWidth);
    
    return CGRectMake(originX, originY, itemWidth, itemHeight);
}

@end
