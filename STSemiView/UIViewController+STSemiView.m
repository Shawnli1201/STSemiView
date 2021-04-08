//
//  UIViewController+STSemiView.m
//
//  Created by Shawn on 2021/1/26.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation NSObject (STSemiRegister)

static char const * const STSemiRegisterOption = "STSemiRegisterOption";
static char const * const STSemiDefaultOption = "STSemiDefaultOption";

- (void)stSemi_registerOptions:(NSDictionary *)options
                  defaults:(NSDictionary *)defaults {
    objc_setAssociatedObject(self, STSemiRegisterOption, options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, STSemiDefaultOption, defaults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)stSemi_optionOrDefaultForKey:(NSString*)optionKey {
    NSDictionary *options = objc_getAssociatedObject(self, STSemiRegisterOption);
    NSDictionary *defaults = objc_getAssociatedObject(self, STSemiDefaultOption);
    return options[optionKey] ?: defaults[optionKey];
}
@end



#import "UIViewController+STSemiView.h"

const struct STSemiViewOptionKeys STSemiViewOptionKeys = {
    .animationDuration       = @"STSemiViewOptionAnimationDuration",
    .parentAlpha             = @"STSemiViewOptionParentAlpha",
    .cornerRadius            = @"STSemiViewOptionCornerRadius",
    .isWindowAlert           = @"STSemiViewOptionisWindowAlert"
};

#define kSemiViewOverlayTag      20001
#define kSemiViewTag             20002

@implementation UIViewController (STSemiView)

static const void *originValueKey = &originValueKey;

- (float)originY {
    return [objc_getAssociatedObject(self, originValueKey) floatValue];
}

- (void)setOriginY:(float)originY {
    NSNumber *number = [NSNumber numberWithFloat:originY];
    objc_setAssociatedObject(self, originValueKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Options Setting

- (void)stsemi_registerDefaultsAndOptions:(NSDictionary*)options {
    [self stSemi_registerOptions:options defaults:@{
        STSemiViewOptionKeys.animationDuration:@(0.3),
        STSemiViewOptionKeys.parentAlpha:@(0.3),
        STSemiViewOptionKeys.cornerRadius:@(10),
        STSemiViewOptionKeys.isWindowAlert:@(YES)
    }];
}

#pragma mark - Public Methods

-(void)presentSemiView:(UIView*)view
           withOptions:(NSDictionary*)options
            completion:(STTransitionCompletionBlock)completion {
    [self stsemi_registerDefaultsAndOptions:options];
    UIView * target = [self stsemi_parentTarget];
    
    if (![target.subviews containsObject:view]) {
        CGFloat semiViewHeight = view.frame.size.height;
        CGRect semiViewFrame = CGRectMake(0, target.bounds.size.height-semiViewHeight, target.bounds.size.width, semiViewHeight);
        
        UIView *overlay = [[UIView alloc] initWithFrame:target.bounds];
        overlay.backgroundColor = [UIColor blackColor];
        overlay.userInteractionEnabled = YES;
        overlay.alpha = [[self stSemi_optionOrDefaultForKey:STSemiViewOptionKeys.parentAlpha] doubleValue];
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlay.tag = kSemiViewOverlayTag;
        [target addSubview:overlay];
        
        UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [dismissButton addTarget:self action:@selector(didClickOnDismissButton:) forControlEvents:UIControlEventTouchUpInside];
        dismissButton.backgroundColor = [UIColor clearColor];
        dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        dismissButton.frame = CGRectMake(0, 0, target.bounds.size.width, target.bounds.size.height);
        [overlay addSubview:dismissButton];
    
        NSTimeInterval duration = [[self stSemi_optionOrDefaultForKey:STSemiViewOptionKeys.animationDuration] doubleValue];

        view.frame = CGRectOffset(semiViewFrame, 0, +semiViewHeight);
        view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        view.tag = kSemiViewTag;
        [target addSubview:view];
        
        UIPanGestureRecognizer *panToCloseGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(responsePanToClose:)];
        panToCloseGesture.delegate = self;
        [view addGestureRecognizer:panToCloseGesture];
        
        double cornerRadius = [[self stSemi_optionOrDefaultForKey:STSemiViewOptionKeys.cornerRadius] doubleValue];
        UIBezierPath *maskPath = [UIBezierPath
            bezierPathWithRoundedRect:view.bounds
            byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
            cornerRadii:CGSizeMake(cornerRadius, cornerRadius)
        ];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        
        [UIView animateWithDuration:duration animations:^{
            view.frame = semiViewFrame;
        } completion:^(BOOL finished) {
            if (!finished) return;
            if (completion) {
                completion();
            }
        }];
    }
}

- (void)removeSemiViewWithAnimation:(BOOL)animation {
    UIView *target = [self stsemi_parentTarget];
    UIView *overlay = [target viewWithTag:kSemiViewOverlayTag];
    UIView *semiView = [target viewWithTag:kSemiViewTag];
    NSTimeInterval duration = 0;
    if (animation) {
        duration = [[self stSemi_optionOrDefaultForKey:STSemiViewOptionKeys.animationDuration] doubleValue];
    }
    [UIView animateWithDuration:duration animations:^{
        semiView.frame = CGRectMake(0, target.bounds.size.height, semiView.frame.size.width, semiView.frame.size.height);
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        [semiView removeFromSuperview];
    }];
}

#pragma mark - Private Method

- (UIView *)stsemi_parentTarget {
    UIViewController * targetVC = self;
    if ([[self stSemi_optionOrDefaultForKey:STSemiViewOptionKeys.isWindowAlert] boolValue]) {
        while (targetVC.parentViewController != nil) {
            targetVC = targetVC.parentViewController;
        }
    }
    return targetVC.view;
}

- (void)didClickOnDismissButton:(id)sender {
    [self removeSemiViewWithAnimation:YES];
}

#pragma mark - Response for PanGesture

- (void)responsePanToClose:(UIPanGestureRecognizer *)recognizer {
    UIView *target = [self stsemi_parentTarget];
    UIView *semiView = [target viewWithTag:kSemiViewTag];
    CGPoint point = [recognizer translationInView:semiView];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.originY = recognizer.view.center.y;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (recognizer.view.center.y >= self.originY) {
            CGFloat tmp = recognizer.view.center.y + point.y;
            if (tmp >= self.originY) {
                recognizer.view.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + point.y);
                [recognizer setTranslation:CGPointMake(0, 0) inView:semiView];
            }
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:semiView].y > semiView.frame.size.height) {
            [self removeSemiViewWithAnimation:YES];
        } else {
            recognizer.view.center = CGPointMake(recognizer.view.center.x, self.originY);
            [recognizer setTranslation:CGPointMake(0, 0) inView:semiView];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]] ) {
        UITableView *tbview = (UITableView *)otherGestureRecognizer.view;
        if (tbview.contentOffset.y == 0) {
            tbview.bounces = NO;
            return YES;
        } else {
            tbview.bounces = YES;
            return NO;
        }
    }
    return NO;
}

@end

