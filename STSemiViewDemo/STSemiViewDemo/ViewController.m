//
//  ViewController.m
//  STSemiViewDemo
//
//  Created by Shawn on 2021/4/8.
//

#import "ViewController.h"
#import "UIViewController+STSemiView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
              action:@selector(showCommonSemiView)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"SemiView1" forState:UIControlStateNormal];
    button.backgroundColor = UIColor.blueColor;
    button.frame = CGRectMake(80.0, 100.0, 160.0, 40.0);
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 addTarget:self
              action:@selector(showCustomSemiView)
     forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"SemiView2" forState:UIControlStateNormal];
    button1.backgroundColor = UIColor.blueColor;
    button1.frame = CGRectMake(80.0, 150.0, 160.0, 40.0);
    [self.view addSubview:button1];
}

- (void)showCommonSemiView {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*3/4)];
    aView.backgroundColor = [UIColor greenColor];
    [self presentSemiView:aView withOptions:@{STSemiViewOptionKeys.animationDuration:@(0.3),
                                              STSemiViewOptionKeys.parentAlpha:@(0.3),
                                              STSemiViewOptionKeys.cornerRadius:@(10),
                                              STSemiViewOptionKeys.isWindowAlert:@(YES)
    } completion:^{
        ;
    }];
}

- (void)showCustomSemiView {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    aView.backgroundColor = [UIColor redColor];
    [self presentSemiView:aView withOptions:@{STSemiViewOptionKeys.animationDuration:@(1.0),
                                              STSemiViewOptionKeys.parentAlpha:@(0.5),
                                              STSemiViewOptionKeys.cornerRadius:@(40),
                                              STSemiViewOptionKeys.isWindowAlert:@(YES)
    } completion:^{
        ;
    }];
}

@end
