//
//  ContactsViewController.m
//  AddressBook
//
//  Created by Gabi on 18/06/15.
//  Copyright (c) 2015 gn. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsManager.h"
#import "ContactTableViewCell.h"
#import "Contact.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactTableViewCell"];
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = @"Contacts";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addContact
{
    [[ContactsManager sharedInstance] addRandomContact];
    
    unsigned int contactsCount = (unsigned int)[[ContactsManager sharedInstance] getContacts].count - 1;
    NSIndexPath* path = [NSIndexPath indexPathForRow:contactsCount inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [[ContactsManager sharedInstance] getContacts].count;
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTableViewCell" forIndexPath:indexPath];
    Contact* c = [[[ContactsManager sharedInstance] getContacts] objectAtIndex:indexPath.row];
    if(c)
    {
        cell.fullName.text = [NSString stringWithFormat:@"%@ %@", c.name, c.surname];
        cell.phoneNumber.text = c.phoneNumber;
        cell.emailAddress.text = c.emailAddress;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Contact* c = [[[ContactsManager sharedInstance] getContacts] objectAtIndex:indexPath.row];
        if(c)
        {
            [[ContactsManager sharedInstance] removeContactWithUID:c.UID];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

@end
