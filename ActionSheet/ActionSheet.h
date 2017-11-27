//
//  ActionSheet.h
//  TestActionSheet
//
//  Created by Frank's Mac on 2017/11/27.
//  Copyright © 2017年 sierra01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ActionSheetBlock)(NSInteger index);

@interface ActionSheet : NSObject

// 初始化弹窗
+ (instancetype)ActionSheetView;

// 显示弹窗
- (void)showActionSheetWithArray:(NSArray *)titles selectedIndexBlock:(ActionSheetBlock)block;

@end
