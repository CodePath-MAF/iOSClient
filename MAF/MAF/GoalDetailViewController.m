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

#import "LendingSocialCell.h"
#import "Friend.h"
#import "Utilities.h"
#import "SimpleTransactionViewController.h"
#import "ProgressView.h"
#import "ViewManager.h"
#import "Post.h"
#import "MessageCollectionViewCell.h"
#import "CSStickyHeaderFlowLayout.h"

// Goal Details Circle
#import <POP/POP.h>
#import "UIView+Animated.h"
#import "UIView+Circle.h"
#import "GoalDetailsCircleView.h"
#import "UIColor+CustomColors.h"

#define CIRCLE_OFFSET 8.0f
#define BIG_CIRCLE_DIAMETER 100.0f
#define SMALL_CIRCLE_DIAMETER 40.0f
#define BAR_HEIGHT 20.0f
#define DEFAULT_USER_COUNT 4.0f


@interface GoalDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *_collectionView;
- (IBAction)_addPostAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *_postTextField;

@property (strong, nonatomic) NSDictionary *_viewData;
@property (strong, nonatomic) Goal *_goal;
@property (strong, nonatomic) NSMutableArray *_posts;

@property (nonatomic, strong) UINib *_headerNib;

@property (nonatomic, strong) UIBezierPath *friendsPath;
@property (nonatomic) BOOL toggle;
@property (nonatomic, strong) GoalDetailsCircleView *goalDetailsCircle;
@property (nonatomic, strong) NSMutableArray *friendViews;
@property (nonatomic, strong) NSArray *circleDestinations;

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
    
//    [self addGoalDetailsView];
    
    // Pop In Center Circle
//    [self.goalDetailsCircle scaleUpTo:1.0f beginTime:0.0f onCompletion:nil];
//    
//    self.friendViews = [[NSMutableArray alloc] init];
//    CGFloat radius = BIG_CIRCLE_DIAMETER/2+CIRCLE_OFFSET+SMALL_CIRCLE_DIAMETER/2;
//    CGPoint topCenter = CGPointMake(self.goalDetailsCircle.center.x, self.goalDetailsCircle.center.y-radius);
//    
//    for (int userNum = 0; userNum < 8; userNum++) {
//        NSString *photoName = [[NSString alloc] initWithFormat:@"profile_%d", userNum+1];
//        UIImageView *friendView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:photoName]];
//        friendView.center = topCenter;
//        [friendView setRoundedWithDiameter:SMALL_CIRCLE_DIAMETER];
//        [self.friendViews addObject:friendView];
//        [self.view addSubview:friendView];
//    }
//    
//    // Find Destinations around Center Circle
//    self.circleDestinations = [self findPointsForItems:self.friendViews aroundCircleView:self.goalDetailsCircle];
//    
//    // Animate around Circle
//    [self popInViews:self.friendViews withDestinations:self.circleDestinations];
}

- (void)_setupParallaxHeader {
    CSStickyHeaderFlowLayout *layout = (id)self._collectionView.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(320, 300);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(320, 85);
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

#pragma mark - Add Views

- (void)addGoalDetailsView
{
    CGPoint goalCenter = CGPointMake(self.view.center.x, BIG_CIRCLE_DIAMETER + SMALL_CIRCLE_DIAMETER + CIRCLE_OFFSET);
    self.goalDetailsCircle = [[GoalDetailsCircleView alloc] initWithDiameter:BIG_CIRCLE_DIAMETER atPoint:goalCenter];
    self.goalDetailsCircle.backgroundColor = [UIColor clearColor];
    self.goalDetailsCircle.strokeColor = [UIColor customGreenColor];
    
    // first reduce the view to 1/100th of its original dimension
    CGAffineTransform trans = CGAffineTransformScale(self.goalDetailsCircle.transform, 0.01, 0.01);
    self.goalDetailsCircle.transform = trans;	// do it instantly, no animation
    
    [self.view addSubview:self.goalDetailsCircle];
}

#pragma mark - Goal Details Circle Animations

- (void)popInViews:(NSArray *)views withDestinations:(NSArray *)destinations {
    NSInteger itemCount = 0;
    for (UIView *friendView in self.friendViews) {
        CGPoint destination = [destinations[itemCount] CGPointValue];
        // first reduce the view to 1/100th of its original dimension
        CGAffineTransform trans = CGAffineTransformScale(friendView.transform, 0.01, 0.01);
        friendView.transform = trans;	// do it instantly, no animation
        // set starting point for friend view (NOT USED)
        //        CGPoint startPoint = (itemCount > 0) ? destination : friendView.center;
        NSLog((self.toggle)? @"YES":@"NO");
        if (!self.toggle) {
            friendView.center = destination;
        }
        
        if (itemCount % 2) { // TODO adjust to the current user/payment user
            friendView.layer.borderWidth = 2;
            friendView.layer.borderColor = [UIColor customGreenColor].CGColor;
        }
        // Not USED RIGHT NOW
        //        // find start/destination slope
        //        CGFloat radius = BIG_CIRCLE_DIAMETER/2+CIRCLE_OFFSET+SMALL_CIRCLE_DIAMETER/2;
        //
        //        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        //        positionAnimation.beginTime = CACurrentMediaTime() + itemCount*.25;
        //        positionAnimation.duration = .5;
        //        positionAnimation.path = [UIBezierPath bezierPathWithArcCenter:self.goalDetailsCircle.center
        //                                                                radius:radius
        //                                                            startAngle:0.2f
        //                                                              endAngle:0.2f
        //                                                             clockwise:YES].CGPath;
        //        positionAnimation.calculationMode = kCAAnimationPaced;
        //        [friendView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        [friendView scaleUpTo:1.0f beginTime:CACurrentMediaTime() + itemCount*.15 onCompletion:nil];
        itemCount++;
    }
}

- (void)animateViews:(NSArray *)views toDestinations:(NSArray *)destinations {
    for (NSInteger countA = 0; countA < [views count]; countA++) {
        CGPoint destination = [destinations[countA] CGPointValue];
        UIImageView *friendView = [views objectAtIndex:countA];
        
        // calculate animation path / arc
        if (countA % 2) {
            friendView.layer.borderWidth = 2;
            friendView.layer.borderColor = [UIColor customGreenColor].CGColor;
        }
        [friendView scaleUpTo:0.8f withCenter:destination beginTime:CACurrentMediaTime() + countA*.15 onCompletion:nil];
    }
}

- (NSArray *)findPointsForItems:(NSArray *)items onPath:(UIBezierPath *)path {
    NSMutableArray *destinations = [[NSMutableArray alloc] init];
    
    NSInteger itemCount = [items count];
    for (int itemNum = 0; itemNum < itemCount; itemNum++) {
        CGFloat x = (itemNum) * (SMALL_CIRCLE_DIAMETER) + SMALL_CIRCLE_DIAMETER/2 + CIRCLE_OFFSET;
        CGFloat y = BAR_HEIGHT + CIRCLE_OFFSET + SMALL_CIRCLE_DIAMETER;
        NSValue *destination = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [destinations addObject:destination];
    }
    
    return destinations;
}

- (NSArray *)findPointsForItems:(NSArray *)items aroundCircleView:(UIView *)view {
    NSMutableArray *destinations = [[NSMutableArray alloc] init];
    
    CGFloat radius = BIG_CIRCLE_DIAMETER/2 + SMALL_CIRCLE_DIAMETER/2 + CIRCLE_OFFSET;
    CGPoint center = view.center;
    NSInteger itemCount = [items count];
    for (int itemNum = 0; itemNum < itemCount; itemNum++) {
        CGFloat itemRatio = (float)itemNum/(float)itemCount;
        CGFloat x = center.x + radius * cosf(itemRatio * 2*M_PI - M_PI_2); // minus pi/2 to start at top of circle
        CGFloat y = center.y + radius * sinf(itemRatio * 2*M_PI - M_PI_2); // minus pi/2 to start at top of circle
        NSValue *destination = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [destinations addObject:destination];
    }
    
    return destinations;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"HeaderView"
                                                                                   forIndexPath:indexPath];
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
