//
//  GoalDetailViewController.m
//  MAF
//
//  Created by Eddie Freeman on 7/14/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#define CIRCLE_FRIENDS_PER_PAGE 4

#import "OpenSansBoldLabel.h"
#import "OpenSansRegularLabel.h"
#import "OpenSansSemiBoldLabel.h"
#import "GoalDetailViewController.h"
#import "GoalDetailsHeaderView.h"

#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "PostDetailViewController.h"

#import "LendingSocialCell.h"
#import "Friend.h"
#import "Utilities.h"
#import "SimpleTransactionViewController.h"
#import "ProgressView.h"
#import "ViewManager.h"
#import "Post.h"
#import "MessageCollectionViewCell.h"
#import "PaymentCollectionViewCell.h"
#import "EventCollectionViewCell.h"
#import "CSStickyHeaderFlowLayout.h"

@interface GoalDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, GoalDetailsHeaderViewDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *_collectionView;

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
    [self registerForKeyboardNotifications];
    
    self._collectionView.delegate = self;
    self._collectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"MessageCollectionViewCell" bundle:nil];
    
    [self._collectionView registerNib:cellNib forCellWithReuseIdentifier:@"MessageCell"];
    
    UINib *paymentCellNib = [UINib nibWithNibName:@"PaymentCollectionViewCell" bundle:nil];
    [self._collectionView registerNib:paymentCellNib forCellWithReuseIdentifier:@"PaymentCell"];
    
    UINib *eventCellNib = [UINib nibWithNibName:@"EventCollectionViewCell" bundle:nil];
    [self._collectionView registerNib:eventCellNib forCellWithReuseIdentifier:@"EventCell"];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    self.navigationItem.title = self._goal.name;
    [self _setupParallaxHeader];
    
    self.navigationController.navigationBar.translucent = NO;
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

- (void)makePayment:(id)sender {
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
            
        case PostTypePayment: {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PaymentCell" forIndexPath:indexPath];
            [(PaymentCollectionViewCell *)cell setGoal:self._goal];
            break;
        }
            
        case PostTypeEvent: {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventCell" forIndexPath:indexPath];
            [(EventCollectionViewCell *)cell setPost:post];
            UITapGestureRecognizer *eventTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandCommentsForPost:)];
            [cell addGestureRecognizer:eventTap];
            break;
        }

        default: {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MessageCell" forIndexPath:indexPath];
            [(MessageCollectionViewCell *)cell setPost:post];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandCommentsForPost:)];
            [cell addGestureRecognizer:tapGesture];
            break;
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        GoalDetailsHeaderView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"HeaderView"
                                                                                   forIndexPath:indexPath];
        cell.viewData = self._viewData;
        cell.delegate = self;
        return cell;
    }
    return nil;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
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
//    PostDetailViewController *vc = [[PostDetailViewController alloc] initWithNibName:@"PostDetailViewController" bundle:nil];
//    vc.post = post;
//    [self.navigationController pushViewController:vc animated:YES];
    
    PostDetailViewController *modalVC = [PostDetailViewController new];
    modalVC.post = post;
    modalVC.transitioningDelegate = self;
    modalVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [self.navigationController presentViewController:modalVC animated:YES completion:nil];
}

- (void)addPost:(NSString *)contents {
    Post *post = [Post object];
    post.content = contents;
    post.goal = self._goal.parentGoal;
    post.type = PostTypeMessage;
    post.user = [User currentUser];
    post.comments = [[NSMutableArray alloc] init];
    [post saveInBackground];
    [self._posts insertObject:post atIndex:0];
#warning this could just be reload at index paths
    [self._collectionView reloadData];
    [[ViewManager instance] clearCache];
}

#pragma Handle Keyboard
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 223, 0.0);
    self._collectionView.contentInset = contentInsets;
    self._collectionView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self._collectionView.contentInset = contentInsets;
    self._collectionView.scrollIndicatorInsets = contentInsets;
}

@end
