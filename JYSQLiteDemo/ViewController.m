//
//  ViewController.m
//  JYSQLiteDemo
//
//  Created by Jolie_Yang on 2017/4/5.
//  Copyright © 2017年 China Industrial Bank. All rights reserved.
//

#import "ViewController.h"
#import "FMDBViewController.h"
#import "GYDataCenterViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self jumpToGYDataCenterAction:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)jumpToFMDBAction:(id)sender {
    FMDBViewController *vc = [[FMDBViewController alloc] initWithNibName:NSStringFromClass([FMDBViewController class]) bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)jumpToGYDataCenterAction:(id)sender {
    GYDataCenterViewController *vc = [[GYDataCenterViewController alloc] initWithNibName:NSStringFromClass([GYDataCenterViewController class]) bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
