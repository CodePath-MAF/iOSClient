//
//  PostDetailViewController.m
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Comment.h"
#import "CommentCollectionViewCell.h"
#import "MessageCollectionViewCell.h"
#import "PostDetailViewController.h"
#import "ViewManager.h"

@interface PostDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *_comments;
@property (weak, nonatomic) IBOutlet UICollectionView *_collectionView;
@property (weak, nonatomic) IBOutlet UITextField *_commentContentTextField;
@property (weak, nonatomic) IBOutlet UIView *_postView;

- (IBAction)_addComment:(id)sender;

@end

@implementation PostDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self._collectionView.delegate = self;
    self._collectionView.dataSource = self;
    
    MessageCollectionViewCell *postView = [[[NSBundle mainBundle] loadNibNamed:@"MessageCollectionViewCell" owner:nil options:nil] firstObject];
    postView.post = self.post;
    [self._postView addSubview:postView];
    
    [self _registerNibs];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setPost:(Post *)post {
    _post = post;
    self._comments = [post getComments];
}

- (void)_registerNibs {
    UINib *postNib = [UINib nibWithNibName:@"PostDetailCollectionViewCell" bundle:nil];
    [self._collectionView registerNib:postNib forCellWithReuseIdentifier:@"PostView"];
    
    UINib *commentNib = [UINib nibWithNibName:@"CommentCollectionViewCell" bundle:nil];
    [self._collectionView registerNib:commentNib forCellWithReuseIdentifier:@"CommentView"];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self._comments count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Comment *comment = self._comments[indexPath.item];
    CommentCollectionViewCell *commentView = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentView"
                                                                                 forIndexPath:indexPath];
    commentView.comment = comment;
    return commentView;
}

- (IBAction)_addComment:(id)sender {
    Comment *comment = [Comment object];
    comment.user = [User currentUser];
    comment.post = self.post;
    comment.content = self._commentContentTextField.text;
    [self.post.comments addObject:comment];
    [PFCloud callFunctionInBackground:@"createComment" withParameters:@{@"postId": self.post.objectId, @"userId": comment.user.objectId, @"content": comment.content} block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"error saving comment: %@", error);
        }
    }];
    self._commentContentTextField.text = @"";
    [self._collectionView reloadData];
    [[ViewManager instance] clearCache];
}

@end
