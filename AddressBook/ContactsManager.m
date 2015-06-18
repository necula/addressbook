//
//  ContactsManager.m
//  AddressBook
//
//  Created by Gabi on 18/06/15.
//  Copyright (c) 2015 gn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactsManager.h"
#import "Contact.h"

@interface ContactsManager ()

@property (nonatomic, strong) NSMutableArray* contactsArray;

-(instancetype)init;

@end

static ContactsManager* s_sharedInstance = nil;
static unsigned int s_lastUID = 0;

@implementation ContactsManager

+(instancetype)sharedInstance
{
    if(!s_sharedInstance)
    {
        s_sharedInstance = [[ContactsManager alloc] init];
    }
    return s_sharedInstance;
}

-(instancetype)init
{
    self = [super init];
    if(!self)
        return nil;
    
    _contactsArray = [[NSMutableArray alloc] init];

    // FIXME: check for CoreData stuff or load data from CSV
    for(int i = 0; i < 10; i++)
        [self addRandomContact];
    
    return self;
}

-(NSArray*)getContacts
{
    return _contactsArray;
}

-(void)removeContactWithUID:(unsigned int)UID
{
    // FIXME: remove this
    for(unsigned int i = 0; i < _contactsArray.count; i++)
    {
        if(UID == ((Contact*)_contactsArray[i]).UID)
        {
            [_contactsArray removeObjectAtIndex:i];
            break;
        }
    }
}

-(void)addRandomContact
{
    NSString* name = [NSString stringWithFormat:@"Name%d", arc4random() % 2048];
    NSString* surname = [NSString stringWithFormat:@"Surname%d", arc4random() % 2048];
    NSString* phoneNumber = @"01234";
    NSString* emailAddress = @"email@server.com";
    unsigned int UID = s_lastUID++;
    
    Contact* c = [[Contact alloc] initWithName:name surname:surname phoneNumber:phoneNumber emailAddress:emailAddress UID:UID];
    [_contactsArray addObject:c];
}

@end