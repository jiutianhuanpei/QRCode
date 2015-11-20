
//
//  ViewController.m
//  QRCode_Demo
//
//  Created by 沈红榜 on 15/11/17.
//  Copyright © 2015年 沈红榜. All rights reserved.
//

#import "ViewController.h"
#import "RootViewController.h"
#import "SelfViewController.h"
#import "TempViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MenuViewController.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)creatBtn:(NSString *)title frame:(CGRect)frame action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = frame;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"相册" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 100, 100, 30);
    [btn addTarget:self action:@selector(toQRCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"个人二维码" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(20, 150, 100, 30);
    [btn1 addTarget:self action:@selector(toSelfQRCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"扫描" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(20, 200, 100, 30);
    [btn2 addTarget:self action:@selector(toTempVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    [self creatBtn:@"菜单" frame:CGRectMake(20, 250, 100, 30) action:@selector(toMenu)];
    
}

- (void)toMenu {
    MenuViewController *menu = [[MenuViewController alloc] init];
    [self.navigationController pushViewController:menu animated:true];
}

- (void)toQRCode:(UIButton *)btn {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = true;
    [self presentViewController:picker animated:true completion:nil];
}

- (void)toSelfQRCode {
    SelfViewController *vc = [[SelfViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)toTempVC {
    TempViewController *temp = [[TempViewController alloc] init];
    [self.navigationController pushViewController:temp animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:true completion:^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        if (!image) {
            image = info[UIImagePickerControllerOriginalImage];
        }
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        // kCIContextUseSoftwareRenderer : 软件渲染 -- 可以消除 "BSXPCMessage received error for message: Connection interrupted" 警告
        // kCIContextPriorityRequestLow : 低优先级在 GPU 渲染-- 设置为false可以加快图片处理速度
        CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(true), kCIContextPriorityRequestLow : @(false)}];
        
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:nil];
        CIImage *ciImage = [CIImage imageWithData:imageData];
        
        NSArray *ar = [detector featuresInImage:ciImage];
        CIQRCodeFeature *feature = [ar firstObject];
        NSLog(@"detector: %@", detector);
        NSLog(@"context: %@", feature.messageString);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"扫描结果：%@", feature.messageString ?: @"空"] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
        
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
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
