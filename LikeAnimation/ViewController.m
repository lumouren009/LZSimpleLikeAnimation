//
//  ViewController.m
//  LikeAnimation
//
//  Created by 卢政 on 15/8/14.
//  Copyright (c) 2015年 卢政. All rights reserved.
//

#import "ViewController.h"
#include <stdlib.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isFiring;
@property (nonatomic, assign) NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFiring = NO;
    _count = 0;

}

- (void)viewDidAppear:(BOOL)animated{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)likeBtnClicked:(id)sender {
    // 产生随机的心形，成团出现
    
    _count += 1;
    if (_count < 10) {
        [self showHeartNamed:@"red"];
    }else if(_count < 20){
        [self showHeartNamed:@"blue"];
    }else if(_count < 30){
        [self showHeartNamed:@"yellow"];
    }else{
        _count = 0;
    }
}


- (void)showHeartNamed:(NSString *)imageName{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = CGRectOffset(self.likeBtn.frame, 0, -25);
    [self.view addSubview:imageView];
    [self animateImage:imageView];
}

- (void)animateImage:(UIImageView *)animationView{
    animationView.alpha = 1.0f;
    // 调整心形位置
    CGRect imageFrame = animationView.frame;
    CGPoint viewOrigin = animationView.frame.origin;
    viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0f;
    viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0f;
    animationView.frame = imageFrame;
    animationView.layer.position = viewOrigin;
    
    // 动画：渐变
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.0]];
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.removedOnCompletion = NO;
    
    // 动画：位置
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;

    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
    CGFloat btnPoint_y = _likeBtn.frame.origin.y;
    
    //增加三个水平方向的拐点
    CGPathAddLineToPoint(curvedPath, NULL, [self randomX], btnPoint_y - 150.f);
    CGPathAddLineToPoint(curvedPath, NULL, [self randomX], btnPoint_y - 300.f);
    CGPathAddLineToPoint(curvedPath, NULL, [self randomX], btnPoint_y - 450.f);
   
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:@[fadeOutAnimation, pathAnimation]];
    group.duration = 4.f;
    group.delegate = self;
    [group setValue:animationView forKey:@"imageViewBeingAnimated"];
    [animationView.layer addAnimation:group forKey:@"groupAnimation"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //动画结束后，将view从界面中清除
    [[anim valueForKey:@"imageViewBeingAnimated"] removeFromSuperview];
}

#pragma mark - Helpers
/**
 *  产生随机的X值
 *
 *  @return 随机值
 */
- (CGFloat)randomX{
    float r = (float) arc4random_uniform(60) - 30.f ; // -30 ~ +30
    CGPoint btnPoint = self.likeBtn.frame.origin;
    return btnPoint.x + r;
}

@end
