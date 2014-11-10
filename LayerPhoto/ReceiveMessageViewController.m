//
//  ReceiveMessageViewController.m
//  
//
//  Created by Kevin Coleman on 11/8/14.
//
//

#import "ReceiveMessageViewController.h"

@interface ReceiveMessageViewController ()

@property (nonatomic) NSOrderedSet *messages;

@end

@implementation ReceiveMessageViewController

static NSString *const MessageCellIdentifier = @"messageCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MessageCellIdentifier];
    
    self.messages = [self.layerClient messagesForConversation:self.conversation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier];
    LYRMessage *message = [self.messages objectAtIndex:indexPath.row];
    LYRMessagePart *messagePart = [message.parts lastObject];
    NSString *messageText = [[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding];
    cell.textLabel.text = messageText;
    return cell;
}



@end
