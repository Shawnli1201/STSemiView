STSemiView使用说明:
   当前在开发iOS App时，经常会有弹出半屏视图窗口，该窗口可下拉拖动隐藏，或者点击其他区域隐藏。系统自带的presentViewController，可定制化的元素太少。使用STSemiView可以轻松解决这个问题，同时支持
动画时长，圆角，视图显示等级，其他区域的透明度设置。

使用步骤如下：

1.通过cocoapos引入，pod 'STSemiView', 或者拷贝UIViewController+STSemiView.h/UIViewController+STSemiView.m文件到你的工程中。

2.在需要弹出半屏视图的ViewController中import "UIViewController+STSemiView.h", 创建你要展示的View，设置相应的高度，随后通过-(void)presentSemiView:(UIView*)view withOptions:(NSDictionary*)options 

completion:(STTransitionCompletionBlock)completion函数，使得你的视图弹出。

3.如果你的视图中某个按钮需要触发隐藏视图功能，请调用- (void)removeSemiViewWithAnimation:(BOOL)animation;

4.具体使用示例，请参考Demo。
