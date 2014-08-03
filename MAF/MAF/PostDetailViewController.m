//
//  PostDetailViewController.m
//  MAF
//
//  Created by mhahn on 8/2/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Comment.h"
#import "CommentReusableView.h"
#import "PostDetailViewController.h"

@interface PostDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *_comments;
@property (weak, nonatomic) IBOutlet UICollectionView *_collectionView;
@property (weak, nonatomic) IBOutlet UITextField *_commentContentTextField;
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
    UINib *postNib = [UINib nibWithNibName:@"PostDetailReusableView" bundle:nil];
    [self._collectionView registerNib:postNib forCellWithReuseIdentifier:@"PostView"];
    
    UINib *commentNib = [UINib nibWithNibName:@"CommentReusableView" bundle:nil];
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
    CommentReusableView *commentView = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentView"
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
    [self.post saveInBackground];
    self._commentContentTextField.text = @"";
    [self._collectionView reloadData];
}
@end
