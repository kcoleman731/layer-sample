//
//  ReceiveMessageViewController.h
//  
//
//  Created by Kevin Coleman on 11/8/14.
//
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>

@interface ReceiveMessageViewController : UITableViewController

@property (nonatomic) LYRClient *layerClient;
@property (nonatomic) LYRConversation *conversation;

@end
