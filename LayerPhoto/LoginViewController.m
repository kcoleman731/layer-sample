//
//  LoginViewController.m
//  LayerPhoto
//
//  Created by Kevin Coleman on 11/8/14.
//  Copyright (c) 2014 Layer. All rights reserved.
//

#import "LoginViewController.h"
#import "SendMessageViewController.h"

UIColor *LSGrayColor()
{
    return [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
}

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"layer"]];
    image.frame = CGRectMake(0, 0, 300, 300);
    [self.view addSubview:image];
    image.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
    
    UIButton *button1 = [[UIButton alloc] init];
    button1.frame = CGRectMake(0, 0, 260, 40);
    button1.layer.cornerRadius = 4;
    button1.backgroundColor = [UIColor blueColor];
    [button1 setTitle:@"Login - User 1" forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(loginUser1) forControlEvents:UIControlEventTouchUpInside];
    button1.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    
    UIButton *button2 = [[UIButton alloc] init];
    button2.frame = CGRectMake(0, 0, 260, 40);
    button2.layer.cornerRadius = 4;
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"Login - User 2" forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(loginUser2) forControlEvents:UIControlEventTouchUpInside];
    button2.center = self.view.center;
    
    UIButton *button3 = [[UIButton alloc] init];
    button3.frame = CGRectMake(0, 0, 260, 40);
    button3.layer.cornerRadius = 4;
    button3.backgroundColor = LSGrayColor();
    [button3 setTitle:@"Logout" forState:UIControlStateNormal];
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    button3.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
}

- (void)loginUser1
{
    [self.loginDelegate loginAsUser1];
}

- (void)loginUser2
{
    [self.loginDelegate loginAsUser2];
}

- (void)logout
{
    [self.loginDelegate logout];
}

@end
