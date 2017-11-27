# ActionSheet
仿微信弹窗效果Demo
效果:
![image](https://github.com/ChaoYug/ActionSheet/blob/master/demo.gif)

调用方法:

将ActionSheet拖入工程
导入头文件#import "ActionSheet.h"
[[ActionSheet actionSheetView] showActionSheetWithArray:titleArray selectedIndexBlock:^(NSInteger index) {
NSLog(@"点击了第: %ld",(long)index);
}];

实现和用法都很简单,欢迎多多反馈.


