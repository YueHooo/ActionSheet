//
//  ActionSheet.m
//  TestActionSheet
//
//  Created by Frank's Mac on 2017/11/27.
//  Copyright © 2017年 sierra01. All rights reserved.
//

#import "ActionSheet.h"

#define ActionSheetCellHeight 55
#define ActionSheetFooterHeight 5
#define ActionSheetHeight [UIScreen mainScreen].bounds.size.height
#define ActionSheetWidth [UIScreen mainScreen].bounds.size.width
// 适配iPhoneX (顶部)
#define SafeAreaTopHeight (ActionSheetHeight == 812.0 ? 88 : 64)
// 适配iPhoneX (低部)
#define SafeAreaBottomHeight (ActionSheetHeight == 812.0 ? 34 : 0)
static NSString *actionSheetCell = @"actionSheetCell";

@interface ActionSheet ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy) ActionSheetBlock actionSheetBlock;

@end

@implementation ActionSheet

// 初始化
static ActionSheet *actionSheetType = nil;

+ (instancetype)actionSheetView
{
    if (!actionSheetType)
    {
        actionSheetType = [[ActionSheet alloc] init];
    }
    return actionSheetType;
}

#pragma mark - 懒加载
- (UIView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ActionSheetWidth, ActionSheetHeight)];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissActionSheet:)];
        tag.delegate = self;
        [_bgView addGestureRecognizer:tag];
    }
    return _bgView;
}

- (UITableView *)listView
{
    if (!_listView)
    {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, ActionSheetHeight, ActionSheetWidth, ((self.titleArray.count + 1) * ActionSheetCellHeight) + ActionSheetFooterHeight + SafeAreaBottomHeight) style:UITableViewStylePlain];
//        NSLog(@"未加底部安全区域高度:%ld\n加了底部安全区域高度:%ld",((self.titleArray.count + 1) * ActionSheetCellHeight) + ActionSheetFooterHeight,((self.titleArray.count + 1) * ActionSheetCellHeight) + ActionSheetFooterHeight + SafeAreaBottomHeight);
        _listView.scrollEnabled = NO;
        _listView.rowHeight = ActionSheetCellHeight;
        if ([_listView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_listView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_listView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_listView setLayoutMargins:UIEdgeInsetsZero];
        }
        _listView.backgroundColor = [UIColor whiteColor];
        [_listView registerClass:[UITableViewCell class] forCellReuseIdentifier:actionSheetCell];
        _listView.delegate = self;
        _listView.dataSource = self;
    }
    return _listView;
}

#pragma mark - Show
- (void)showActionSheetWithArray:(NSArray *)titles selectedIndexBlock:(ActionSheetBlock)block
{
    self.actionSheetBlock = block;
    self.titleArray = titles;
    // 初始化控件
    [self.bgView addSubview:self.listView];
    // 显示动画
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        self.listView.frame = CGRectMake(0, ActionSheetHeight - (((self.titleArray.count + 1) * ActionSheetCellHeight) + ActionSheetFooterHeight + SafeAreaBottomHeight), ActionSheetWidth, (((self.titleArray.count + 1) * ActionSheetCellHeight) + ActionSheetFooterHeight + SafeAreaBottomHeight));
    }];
}

#pragma mark - touch
- (void)dismissActionSheet:(UIGestureRecognizer *)gesture
{
    // 隐藏动画
    [UIView animateWithDuration:0.2 animations:^{
        
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.listView.frame = CGRectMake(0, ActionSheetHeight, ActionSheetWidth, (((self.titleArray.count + 1) * ActionSheetCellHeight) + ActionSheetFooterHeight + SafeAreaBottomHeight));
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        actionSheetType = nil;
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *actionSheetView = touch.view;
    while ([actionSheetView.superview isKindOfClass:[UIView class]])
    {
        if ([actionSheetView isKindOfClass:[UITableViewCell class]])
        {
            [actionSheetView isKindOfClass:[UITableView class]];
            return NO;
        }
        actionSheetView = actionSheetView.superview;
    }
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.titleArray.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:actionSheetCell];
    // 自定义点击背景颜色
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    cell.selectedBackgroundView = selectedView;
    if (indexPath.section == 1)
    {
        [self setTableViewCell:cell title:@"取消"];
    }
    else
    {
        [self setTableViewCell:cell title:self.titleArray[indexPath.row]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ActionSheetWidth, ActionSheetCellHeight)];
        footer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return ActionSheetFooterHeight;
    }
    else
    {
        return 0.0001f;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_actionSheetBlock)
    {
        [self dismissActionSheet:nil];
        if (indexPath.section == 1)
        {
            _actionSheetBlock(self.titleArray.count);
        }
        else
        {
            _actionSheetBlock(indexPath.row);
        }
    }
}

// 设置Cell子控件
- (void)setTableViewCell:(UITableViewCell *)cell title:(NSString *)title
{
    cell.textLabel.text = title;
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.frame = CGRectMake(0, 0, ActionSheetWidth, ActionSheetCellHeight);
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@ 被注销",NSStringFromClass([self class]));
}

@end
