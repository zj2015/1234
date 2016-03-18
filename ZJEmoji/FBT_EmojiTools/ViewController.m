//
//  ViewController.m
//  FBT_PublishTool
//
//  Created by 张杰 on 16/2/29.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "ViewController.h"
#import "FBT_EmojScrollView.h"
#import "FBT_EmojKeyBar.h"
#import "FBT_TextView.h"
#import "UIView+ZJExtension.h"

@interface ViewController ()<FBT_emojKeyBarDelegate>

@property (nonatomic, weak) FBT_EmojKeyBar *keybar;
@property (nonatomic, weak) FBT_TextView *textView;
@property (nonatomic, strong) FBT_EmojScrollView *keyboard;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBT_TextView *textView = [[FBT_TextView alloc]initWithFrame:CGRectMake(0, 20, KScreenW, 100)];
    textView.backgroundColor = [UIColor yellowColor];
    self.textView = textView;
    [self.view addSubview:textView];
    
    FBT_EmojScrollView *scrollView = [[FBT_EmojScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 216) EmojScrollView:^(FBT_TextAttachment *attachment) {
        
        [textView oppendEmotion:attachment];
        
    }];
    self.keyboard = scrollView;
    FBT_EmojKeyBar *keybar = [[FBT_EmojKeyBar alloc]initWithFrame:CGRectMake(0, KScreenH-35, KScreenW, 35) andType:FBKeybarDefult];
    self.keybar = keybar;
    self.keybar.delegate = self;
    [self.view addSubview:keybar];
    [textView becomeFirstResponder];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    
}


- (void)keyboardWillShow:(NSNotification*)note
{
    
    NSDictionary *info = note.userInfo;
    CGSize KSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSNumber *animateT = info[UIKeyboardAnimationDurationUserInfoKey];
    double time = animateT.doubleValue;
    
    [UIView animateWithDuration:time animations:^{
        
        self.keybar.zj_y = KScreenH - 35 - KSize.height;
        
    }];
    

}


#pragma mark - keybarDelegate
- (void)keybar:(FBT_EmojKeyBar *)keybar InselectedKeyBarType:(FBKeybarType)keybarType
{
    switch (keybarType) {
        case FBKeybarEmoji:
        {
            [self openEmojikeyboard];
        }
            break;
        case FBKeybarLoction:
            
            break;
        case FBKeybarPhoto:
            
            break;
        case FBKeybarTalk:
            
            break;
        case FBKeybarVoice:
            
            break;
            
        default:
            break;
    }
}


#pragma mark - 打开键盘
- (void)openEmojikeyboard
{
    if (self.textView.inputView) {
        self.textView.inputView = nil;
    }else{
        self.textView.inputView = self.keyboard;
    }
    // 关闭键盘
    [self.textView resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 打开键盘
        [self.textView becomeFirstResponder];
    });

}


@end
