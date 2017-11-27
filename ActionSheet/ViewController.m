//
//  ViewController.m
//  ActionSheet
//
//  Created by Frank's Mac on 2017/11/27.
//  Copyright © 2017年 Frank's Mac. All rights reserved.
//

#import "ViewController.h"
#import "ActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 75, self.view.center.y - 22.5, 150, 45)];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor orangeColor].CGColor;
    btn.layer.cornerRadius = 5.0;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"ActionSheet" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickActionSheetButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - touch
- (void)clickActionSheetButton:(UIButton *)sender
{
    NSArray *titleArray = @[@"微信",@"支付宝",@"淘宝",@"网易新闻",@"微博"];
    [[ActionSheet ActionSheetView] showActionSheetWithArray:titleArray selectedIndexBlock:^(NSInteger index) {
        NSLog(@"点击了第: %ld",index);
    }];
}

@end
