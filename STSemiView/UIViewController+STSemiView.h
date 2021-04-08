//
//  UIViewController+STSemiView.h
//
//  Created by Shawn on 2021/1/26.
//
@interface NSObject (STSemiRegister)
- (void)stSemi_registerOptions:(NSDictionary *)options
                  defaults:(NSDictionary *)defaults;
- (id)stSemi_optionOrDefaultForKey:(NSString *)optionKey;
@end


extern const struct STSemiViewOptionKeys {
    __unsafe_unretained NSString *animationDuration;
    __unsafe_unretained NSString *parentAlpha;
    __unsafe_unretained NSString *cornerRadius;
    __unsafe_unretained NSString *isWindowAlert;
} STSemiViewOptionKeys;

typedef void (^STTransitionCompletionBlock)(void);

@interface UIViewController (STSemiView)<UIGestureRecognizerDelegate>
@property (nonatomic, assign) float originY;
-(void)presentSemiView:(UIView*)view
           withOptions:(NSDictionary*)options
            completion:(STTransitionCompletionBlock)completion;
- (void)removeSemiViewWithAnimation:(BOOL)animation;
@end
