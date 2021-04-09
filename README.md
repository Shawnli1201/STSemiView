STEPS:

1. install using cocoapods, pod 'STSemiView' or copy the files(UIViewController+STSemiView.h/UIViewController+STSemiView.m) to your project.
2. importing "UIViewController+STSemiView.h",creating the view which you want to show, setting the size of your view. Finally, you can call the public method "-(void)presentSemiView:(UIView*)view withOptions:(NSDictionary*)options completion:(STTransitionCompletionBlock)completion" when the ViewController needs to present a semiView.
3. if you want to hide this semiView, just call the public method "-(void)removeSemiViewWithAnimation:(BOOL)animation;".
4. the detail example for using STSemiView, please download the Demo. 

If you have any questions, feel free to contact me (shawnli1201@gmail.com) or create pull requests.

使用步骤：

1. 通过cocoapos引入，pod 'STSemiView', 或者拷贝UIViewController+STSemiView.h/UIViewController+STSemiView.m文件到你的工程中。
2. 在需要弹出半屏视图的ViewController中import "UIViewController+STSemiView.h", 创建你要展示的View，设置相应的高度，随后通过-(void)presentSemiView:(UIView*)view withOptions:(NSDictionary*)options completion:(STTransitionCompletionBlock)completion函数，使得你的视图弹出。
3. 如果你的视图中某个按钮需要触发隐藏视图功能，请调用- (void)removeSemiViewWithAnimation:(BOOL)animation;
4. 具体使用示例，请参考Demo。

如果有任何问题，请联系我（shawnli1201@gmail.com）或者创建pull requests.
