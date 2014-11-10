//
//  LoginViewController.h
//  LayerPhoto
//
//  Created by Kevin Coleman on 11/8/14.
//  Copyright (c) 2014 Layer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginAsUser1;
- (void)loginAsUser2;
- (void)logout;

@end

@interface LoginViewController : UIViewController

@property (nonatomic) id<LoginViewControllerDelegate>loginDelegate;

@property (nonatomic) LYRClient *layerClient;

@end
