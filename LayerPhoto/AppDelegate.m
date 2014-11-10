//
//  AppDelegate.m
//  LayerPhoto
//
//  Created by Kevin Coleman on 11/8/14.
//  Copyright (c) 2014 Layer. All rights reserved.
//

#import "AppDelegate.h"
#import <LayerKit/LayerKit.h>
#import "SendMessageViewController.h"
#import "LoginViewController.h"

@interface AppDelegate () <LoginViewControllerDelegate, LYRClientDelegate>

@property (nonatomic) LYRClient *layerClient;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    NSString *layerAppID = @"a083203e-678f-11e4-9e50-1ded000000e6";
    
    NSUUID *appID = [[NSUUID alloc] initWithUUIDString:layerAppID];
    self.layerClient = [LYRClient clientWithAppID:appID];
    self.layerClient.delegate = self;
    
    [self.layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Layer Connected");
    }];
    
    LoginViewController *controller = [[LoginViewController alloc] init];
    controller.layerClient = self.layerClient;
    controller.loginDelegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)loginAsUser1
{
    NSString *user1 = @"0000000004";
    [self authenticateWithLayerWithUserId:user1 completion:^(BOOL success) {
        SendMessageViewController *sendMessageViewContorller = [[SendMessageViewController alloc] init];
        sendMessageViewContorller.layerClient = self.layerClient;
        
        UINavigationController *controller = (UINavigationController *)self.window.rootViewController;
        [controller pushViewController:sendMessageViewContorller animated:YES];
    }];

}

- (void)loginAsUser2
{
    NSString *user2 = @"0000000005";
    [self authenticateWithLayerWithUserId:user2 completion:^(BOOL success) {
        SendMessageViewController *sendMessageViewContorller = [[SendMessageViewController alloc] init];
        sendMessageViewContorller.layerClient = self.layerClient;
        
        UINavigationController *controller = (UINavigationController *)self.window.rootViewController;
        [controller pushViewController:sendMessageViewContorller animated:YES];
    }];
}

- (void)authenticateWithLayerWithUserId:(NSString *)userID completion:(void(^)(BOOL success))completion
{
    if (self.layerClient.authenticatedUserID) completion(YES);
    
    /*
     * 1. Request an authentication Nonce from Layer
     */
    [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        
        /*
         * 2. Acquire identity Token from Layer Identity Service
         */
        
        [self requestIdentityTokenForUserID:userID appID:[self.layerClient.appID UUIDString] nonce:nonce completion:^(NSString *identityToken, NSError *error) {
            
            /*
             * 3. Submit identity token to Layer for validation
             */
            
            [self.layerClient authenticateWithIdentityToken:identityToken completion:^(NSString *authenticatedUserID, NSError *error) {
                if (authenticatedUserID) {
                    completion(YES);
                    NSLog(@"Authenticated as User: %@", authenticatedUserID);
                }
            }];
        }];
    }];
}

- (void)requestIdentityTokenForUserID:(NSString *)userID appID:(NSString *)appID nonce:(NSString *)nonce completion:(void(^)(NSString *identityToken, NSError *error))completion
{
    NSURL *identityTokenURL = [NSURL URLWithString:@"https://layer-identity-provider.herokuapp.com/identity_tokens"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSDictionary *parameters = @{ @"app_id": appID, @"user_id": userID, @"nonce": nonce };
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    request.HTTPBody = requestBody;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // Deserialize the response
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *identityToken = responseObject[@"identity_token"];
        completion(identityToken, nil);
        
    }] resume];
}

- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID
{
      NSLog(@"Layer Client Did Auth");
}

- (void)layerClient:(LYRClient *)client didFinishSynchronizationWithChanges:(NSArray *)changes
{
    NSLog(@"Layer Client Sync'd");
}

- (void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce
{
    NSLog(@"Auth Challenge");
}

- (void)logout
{
    [self.layerClient deauthenticateWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Logged out");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Logout Success"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

@end
