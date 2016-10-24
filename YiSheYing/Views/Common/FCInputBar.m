//
//  FCInputBar.m
//  FunnyCamera
//
//  Created by Jinjin on 14/12/1.
//  Copyright (c) 2014年 AnnyFun. All rights reserved.
//

#import "FCInputBar.h"

#define InputBarMinHeight   44
#define InputBarMaxHeight   80

#define InputTBPadding      5
#define InputLPadding       15
#define InputRPadding       15
#define SendBtnWidth        40

@interface FCInputBar()<UITextViewDelegate>{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *placeHolder;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@end

@implementation FCInputBar

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupUI{

    self.backgroundColor = RGB(248, 248, 248);
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.bgImageView.image = [[UIImage imageNamed:@"comment_border"] stretchableImageWithLeftCapWidth:8 topCapHeight:7];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    
    self.inputView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.inputView.backgroundColor = [UIColor clearColor];
    self.inputView.layer.borderWidth = 0;
    self.inputView.layer.cornerRadius = 0;
    self.inputView.returnKeyType = UIReturnKeySend;
    self.inputView.delegate = self;
    self.inputView.font = font;
    self.inputView.showsVerticalScrollIndicator = NO;
    self.inputView.scrollsToTop = NO;
    self.inputView.textColor = [UIColor blackColor];
    self.inputView.enablesReturnKeyAutomatically = YES;
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.sendBtn addTarget:self action:@selector(sendBtnDidTap) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn.enabled = NO;
    [self.sendBtn setImage:[UIImage imageNamed:@"comment_btn_send"] forState:UIControlStateNormal];
    [self.sendBtn setImage:[UIImage imageNamed:@"comment_btn_send_s"] forState:UIControlStateHighlighted];
    
    self.placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(InputLPadding, 0, 320, 20)];
    self.placeHolder.textColor = [UIColor lightGrayColor];
    self.placeHolder.font = font;
    self.placeHolder.text = @"评论";
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.sendBtn];
    [self addSubview:self.inputView];
    [self addSubview:self.placeHolder];
    
    WS(ws);
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws).insets(UIEdgeInsetsMake(InputTBPadding, InputLPadding, InputTBPadding, InputRPadding));
    }];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.bgImageView).insets(UIEdgeInsetsMake(2, 2, 2, 2+SendBtnWidth));
    }];
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.inputView).insets(UIEdgeInsetsMake(0, 4, 0, 0));
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SendBtnWidth, InputBarMinHeight-InputTBPadding*2));
        make.bottom.mas_equalTo(ws.bgImageView);
        make.right.mas_equalTo(ws.mas_right).offset(-InputRPadding);
    }];
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    return ceilf([textView sizeThatFits:textView.frame.size].height);
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < InputBarMinHeight) {
        toHeight = InputBarMinHeight;
    }
    
    if (toHeight>InputBarMaxHeight) {
        toHeight = InputBarMaxHeight;
//        self.inputView.scrollEnabled = YES;
    }else{
//        self.inputView.scrollEnabled = NO;
    }
    
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        WS(ws);
        CGFloat animationDuration = 0;
        if (toHeight>_previousTextViewContentHeight) {
            animationDuration = 0.14;
        }
        [UIView animateWithDuration:animationDuration animations:^{
            CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
            CGRect rect = ws.frame;
            rect.size.height = toHeight;
            rect.origin.y -= changeHeight;
            ws.frame = rect;
        }];
        _previousTextViewContentHeight = toHeight;
    }
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    CGRect fromFrame = self.frame;
    CGFloat y = 0;
    CGFloat showHeight = [[UIScreen mainScreen] bounds].size.height-toFrame.origin.y;
    
    y = self.superview.frame.size.height - fromFrame.size.height - showHeight;
    
    CGRect newFrame = CGRectMake(fromFrame.origin.x, y, fromFrame.size.width, fromFrame.size.height);
    self.frame = newFrame;
}

- (void)hideKeyboard{
    
    [self.inputView resignFirstResponder];
}

- (void)sendBtnDidTap{
    [self sendText:self.inputView.text];
}

- (void)sendText:(NSString *)text{
    
    if (![self.delegate shouldBeginSendText:text]) {
        return;
    }
    [self.inputView resignFirstResponder];
    self.inputView.text = nil;
    [self textViewDidChange:self.inputView];
    
    if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
        [self.delegate didSendText:text];
    }
}

#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    [self.superview addGestureRecognizer:self.tap];
    _previousTextViewContentHeight = CGRectGetHeight(self.frame);
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.superview removeGestureRecognizer:self.tap];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{}

- (void)textViewDidEndEditing:(UITextView *)textView{}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text  && [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0) {
        self.placeHolder.hidden = YES;
        self.sendBtn.enabled = YES;
    }else{
        self.placeHolder.hidden = NO;
        self.sendBtn.enabled = NO;
    }
    [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputView]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self sendText:textView.text];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{

}


#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    WS(ws);
    void(^animations)() = ^{
        if (ws.changeBlock) {
            ws.changeBlock(endFrame);
        }
        [ws willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}
@end
