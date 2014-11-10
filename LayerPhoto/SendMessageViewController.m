//
//  PhotoViewController.m
//  
//
//  Created by Kevin Coleman on 11/8/14.
//
//

#import "SendMessageViewController.h"
#import "ReceiveMessageViewController.h"

UIColor *LSBlueColor()
{
    return [UIColor colorWithRed:36.0f/255.0f green:166.0f/255.0f blue:225.0f/255.0f alpha:1.0];
}

@interface SendMessageViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UITextField *textField;

@end

@implementation SendMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *photoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"inbox"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(inboxButtonTapped)];
    self.navigationItem.rightBarButtonItem = photoItem;
    
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    self.textField.font = [UIFont systemFontOfSize:40];
    self.textField.placeholder = @"Enter Message";
    self.textField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textField];
    self.textField.center = CGPointMake(self.view.center.x, 200);
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 260, 40);
    button.layer.cornerRadius = 4;
    button.backgroundColor = LSBlueColor();
    [button setTitle:@"Send Message" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;
}


- (void)inboxButtonTapped
{
    ReceiveMessageViewController *receiveViewController = [[ReceiveMessageViewController alloc] init];
    receiveViewController.layerClient = self.layerClient;
    receiveViewController.conversation = self.conversation;
    [self.navigationController pushViewController:receiveViewController animated:TRUE];
}

- (void)sendMessage
{
    if (!self.conversation) {
        self.conversation = [self getLayerConversation];
    }
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:self.textField.text];
    LYRMessage *message = [LYRMessage messageWithConversation:self.conversation parts:@[messagePart]];
    
    NSError *error;
    [self.layerClient sendMessage:message error:&error];
    if (!error) {
        NSLog(@"Message Sent!");
        self.textField.text = @"";
        self.textField.placeholder = @"Message Sent!";
    } else {
        NSLog(@"Message Send Error!");
        self.textField.text = @"";
        self.textField.placeholder = @"Message Send Error!";
    }
}

#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            BOOL pickerSourceTypeAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
            if (pickerSourceTypeAvailable) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController presentViewController:picker animated:YES completion:nil];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark UIImagePickerController Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (LYRConversation *)getLayerConversation
{
    NSString *user1 = @"0000000004";
    NSString *user2 = @"0000000005";
    NSString *userID;
    
    if ([self.layerClient.authenticatedUserID isEqualToString:user1]) {
        userID = user2;
    } else {
        userID = user1;
    }
    
    if ([self.layerClient conversationsForParticipants:[NSSet setWithObject:userID]].count) {
        return [[[self.layerClient conversationsForParticipants:[NSSet setWithObject:userID]] allObjects] firstObject];
    } else {
        return [LYRConversation conversationWithParticipants:[NSSet setWithObject:userID]];
    }
}

@end
