//
//  GoalDetailViewController.m
//  MAF
//
//  Created by Eddie Freeman on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#define CIRCLE_FRIENDS_PER_PAGE 4

#import "PostDetailViewController.h"
#import "OpenSansBoldLabel.h"
#import "OpenSansRegularLabel.h"
#import "OpenSansSemiBoldLabel.h"
#import "GoalDetailViewController.h"
#import "GoalDetailsHeaderView.h"

#import "LendingSocialCell.h"
#import "Friend.h"
#import "Utilities.h"
#import "SimpleTransactionViewController.h"
#import "ProgressView.h"
#import "ViewManager.h"
#import "Post.h"
#import "MessageCollectionViewCell.h"
#import "CSStickyHeaderFlowLayout.h"

@interface GoalDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *_collectionView;
- (IBAction)_addPostAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *_postTextField;

@property (strong, nonatomic) NSDictionary *_viewData;
@property (strong, nonatomic) Goal *_goal;
@property (strong, nonatomic) NSMutableArray *_posts;

@property (nonatomic, strong) UINib *_headerNib;

@end

@implementation GoalDetailViewController

- (void)setViewData:(NSDictionary *)viewData {
    self._viewData = viewData;
    self._goal = viewData[@"goal"];
    self._posts = viewData[@"posts"];
    [self._collectionView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self._headerNib = [UINib nibWithNibName:@"GoalDetailsHeaderView" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self._collectionView.delegate = self;
    self._collectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"MessageCollectionViewCell" bundle:nil];
    
    [self._collectionView registerNib:cellNib forCellWithReuseIdentifier:@"MessageCell"];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    self.navigationItem.title = self._goal.name;
    [self _setupParallaxHeader];
    
}

- (void)_setupParallaxHeader {
    CSStickyHeaderFlowLayout *layout = (id)self._collectionView.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(320, 450);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(320, 150);
        layout.parallaxHeaderAlwaysOnTop = YES;
    }
    
    [self._collectionView registerNib:self._headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"HeaderView"];
}

- (void)viewWillAppear:(BOOL)animated {
        
}

- (IBAction)makePayment:(id)sender {
    SimpleTransactionViewController *simpleTransVC = [[SimpleTransactionViewController alloc] initWithNibName:@"SimpleTransactionViewController" bundle:nil];
    [simpleTransVC setLabelsAndButtons:MakePayment goal:self._goal amount:self._goal.paymentAmount];
    [self.navigationController pushViewController:simpleTransVC animated:YES];
}

#pragma mark - Helper Functions

- (CGRect)frameForContentController {
  CGRect contentFrame = self.view.bounds;
  CGFloat heightOffset = self.navigationController.navigationBar.bounds.size.height;
  contentFrame.origin.y += heightOffset;
  contentFrame.size.height -= heightOffset;
  return contentFrame;
}

#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self._posts count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = self._posts[indexPath.item];
    UICollectionViewCell *cell;
    switch (post.type) {

        default:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MessageCell" forIndexPath:indexPath];
            [(MessageCollectionViewCell *)cell setPost:post];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandCommentsForPost:)];
            [cell addGestureRecognizer:tapGesture];
            break;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        GoalDetailsHeaderView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"HeaderView"
                                                                                   forIndexPath:indexPath];
        cell.viewData = self._viewData;
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = self._posts[indexPath.item];
    CGFloat height = 75.0;
    if (post.content.length > 50) {
        height = 110.0;
    }
    return CGSizeMake(320, height);
}

- (void)expandCommentsForPost:(UITapGestureRecognizer *)gestureRecognizer {
    Post *post = [(MessageCollectionViewCell *)gestureRecognizer.view post];
    PostDetailViewController *vc = [[PostDetailViewController alloc] initWithNibName:@"PostDetailViewController" bundle:nil];
    vc.post = post;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)_addPostAction:(id)sender {
    Post *post = [Post object];
    post.content = self._postTextField.text;
    post.goal = self._goal.parentGoal;
    post.type = PostTypeMessage;
    post.user = [User currentUser];
    post.comments = [[NSMutableArray alloc] init];
    [post saveInBackground];
    NSMutableArray *posts = [[NSMutableArray alloc] initWithObjects:post, nil];
    [posts addObjectsFromArray:self._posts];
    self._posts = posts;
#warning this could just be reload at index paths
    [self._collectionView reloadData];
    self._postTextField.text = @"";
    [[ViewManager instance] clearCache];
}

@end
