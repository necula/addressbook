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

#define DEFAULT_CONTACTS_FILE @"contacts.csv"

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
    [self loadContactsFromCSV:DEFAULT_CONTACTS_FILE];
    
    return self;
}

-(NSArray*)getContacts
{
    return _contactsArray;
}

-(void)removeContactWithUID:(unsigned int)UID
{
    // FIXME: improve search time
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
    NSString* phoneNumber = @"1234";
    NSString* emailAddress = @"name@server.com";
    unsigned int UID = s_lastUID++;
    
    Contact* c = [[Contact alloc] initWithName:name surname:surname phoneNumber:phoneNumber emailAddress:emailAddress UID:UID];
    [_contactsArray addObject:c];
}

-(void)loadContactsFromCSV:(NSString*)fileName
{
    NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    // Surely there must be a better way to do this :)
    NSError* error;
    NSString* csvString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if(!error)
    {
        NSArray* lines = [csvString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        for(NSString* line in lines)
        {
            NSArray* columns = [line componentsSeparatedByString:@";"];
            
            NSString* name = columns[0];
            NSString* surname = columns[1];
            NSString* phoneNumber = columns[2];
            NSString* emailAddress = columns[3];
            unsigned int UID = s_lastUID++;
            
            Contact* c = [[Contact alloc] initWithName:name surname:surname phoneNumber:phoneNumber emailAddress:emailAddress UID:UID];
            [_contactsArray addObject:c];
        }
    }
}

@end