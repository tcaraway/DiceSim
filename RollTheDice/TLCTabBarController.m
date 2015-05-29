//
//  TLCTabBarController.m
//  RollTheDice
//
//  Created by Thomas Caraway on 2/20/15.
//
//

#import "TLCTabBarController.h"

@interface TLCTabBarController ()

@end

@implementation TLCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [viewController viewDidAppear:YES];
}

@end
