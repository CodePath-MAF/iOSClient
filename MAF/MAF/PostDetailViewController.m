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
#import "EventCollectionViewCell.h"
#import "ViewManager.h"
#import "UIView+Animated.h"

@interface PostDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSArray *_comments;
@property (weak, nonatomic) IBOutlet UICollectionView *_collectionView;
@property (weak, nonatomic) IBOutlet UITextField *_commentContentTextField;
@property (weak, nonatomic) IBOutlet UIView *_postView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) CGPoint originalCenter;


- (IBAction)_addComment:(id)sender;
- (IBAction)dismiss:(id)sender;

@end

@implementation PostDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [self.view addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Get the size of the keyboard.
    self.tapGesture.enabled = YES;
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat diffY = keyboardRect.origin.y - (self.view.center.y + self.view.frame.size.height/2);
    self.originalCenter = self.view.center;
    [self.view moveToPoint:CGPointMake(self.view.center.x, self.view.center.y - diffY) withBeginTime:CACurrentMediaTime() onCompletion:nil];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view moveToPoint:self.originalCenter withBeginTime:CACurrentMediaTime() onCompletion:nil];
    self.tapGesture.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.cornerRadius = 8.0f;
    self._collectionView.delegate = self;
    self._collectionView.dataSource = self;
    self._commentContentTextField.delegate = self;

    [self _registerNibs];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    switch (self.post.type) {
        case PostTypeEvent: {
            EventCollectionViewCell *eventView = [[[NSBundle mainBundle] loadNibNamed:@"EventCollectionViewCell" owner:nil options:nil] firstObject];
            eventView.post = self.post;
            [self._postView addSubview:eventView];
            break;
        }
            
        default: {
            MessageCollectionViewCell *postView = [[[NSBundle mainBundle] loadNibNamed:@"MessageCollectionViewCell" owner:nil options:nil] firstObject];
            postView.post = self.post;
            [self._postView addSubview:postView];
            break;
        }
    }
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

#pragma mark - TextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self._commentContentTextField) {
        if ([textField.text isEqual:@""]) {
            [self _addComment:textField];
        }
        
        [textField resignFirstResponder];
        [self dismiss:textField];
    }
    return YES;
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

- (void)dismissKeyboard:(id)sender {
    [self._commentContentTextField resignFirstResponder];
}

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
