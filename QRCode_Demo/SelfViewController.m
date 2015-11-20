//
//  SelfViewController.m
//  QRCode_Demo
//
//  Created by 沈红榜 on 15/11/17.
//  Copyright © 2015年 沈红榜. All rights reserved.
//

#import "SelfViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+QRCode.h"


@interface SelfViewController ()

@end

@implementation SelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
//    UIImage *image = [UIImage qrImageByContent:@"www.baidu.com"];
    CGFloat width = 200;
    
//    UIImage *image = [UIImage qrImageWithContent:@"www.baidu.com" size:width red:20 green:100 blue:100];

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgView.frame = CGRectMake(20, 70, width, width);
    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    imgView.layer.shadowOffset = CGSizeMake(1, 2);
    imgView.layer.shadowRadius = 1;
    imgView.layer.shadowOpacity = 0.5;
    [self.view addSubview:imgView];
    
    
    imgView.image = [UIImage qrImageWithContent:@"www.baidu.com" logo:[UIImage imageNamed:@"4"] size:width red:20 green:100 blue:100];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
