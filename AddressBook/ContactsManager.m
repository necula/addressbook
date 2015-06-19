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

#define DEFAULT_CSV_FILE @"contacts.csv"

@interface ContactsManager ()

@property (nonatomic, strong) NSMutableArray* contactsArray;

@property (nonatomic, strong) NSManagedObjectContext* context;
@property (nonatomic, strong) NSPersistentStoreCoordinator* psc;
@property (nonatomic, strong) NSManagedObjectModel* model;
@property (nonatomic, strong) NSEntityDescription* entityDescription;

-(instancetype)init;

@end

static ContactsManager* s_sharedInstance = nil;
static uint32_t s_lastUID = 0;

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

    if(![self loadStore])
    {
        // FIXME: proper error handling
        return nil;
    }
    
    if(![self loadContactsFromStore])
    {
        // FIXME: proper error handling
        return nil;
    }
    
    if([_contactsArray count] == 0)
        [self addContactsFromCSV:DEFAULT_CSV_FILE];
    
    return self;
}

-(BOOL)loadStore
{
    NSArray* documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = [documentsDirectories lastObject];
    NSString* storePath = [documentsDirectoryPath stringByAppendingPathComponent:@"contacts.store"];
    
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"ContactsDataModel" withExtension:@"momd"];
    _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    if(!_model)
        return NO;
    
    NSError* error;
    NSURL* storeURL = [NSURL fileURLWithPath:storePath];
    _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    if(![_psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        return NO;
    
    _context = [[NSManagedObjectContext alloc] init];
    if(!_context)
        return NO;
    _context.persistentStoreCoordinator = _psc;
    
    _entityDescription = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:_context];
    if(!_entityDescription)
        return NO;
    
    return YES;
}

-(BOOL)loadContactsFromStore
{
    if([_contactsArray count] > 0)
        return NO;
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = _entityDescription;
    NSError* error = nil;
    NSArray* result = [self.context executeFetchRequest:request error:&error];
    if(!request || error)
        return NO;
    
    [_contactsArray addObjectsFromArray:result];
    
    return YES;
}

-(void)save
{
    NSError* error;
    [_context save:&error];
}

-(NSArray*)getContacts
{
    return _contactsArray;
}

-(void)removeContactWithUID:(uint32_t)UID
{
    // FIXME: improve search time
    for(unsigned int i = 0; i < _contactsArray.count; i++)
    {
        if(UID == ((Contact*)_contactsArray[i]).uid)
        {
            [_context deleteObject:_contactsArray[i]];
            [_contactsArray removeObjectAtIndex:i];
            break;
        }
    }
}

-(void)addContactWithName:(NSString*)name surname:(NSString*)surname phoneNumber:(NSString*)phoneNumber emailAddress:(NSString*)emailAddress
{
    uint32_t uid = s_lastUID++;
    Contact* c = [[Contact alloc] initWithEntity:_entityDescription insertIntoManagedObjectContext:_context];
    c.name = name;
    c.surname = surname;
    c.phoneNumber = phoneNumber;
    c.emailAddress = emailAddress;
    c.uid = uid;
    [_contactsArray addObject:c];
}

-(void)addRandomContact
{
    NSArray* namesArray = @[ @"James", @"John", @"David", @"Larry", @"Susan", @"Lisa", @"Amy", @"Sarah"];
    NSArray* surnamesArray = @[ @"Smith", @"Williams", @"Jones", @"Miller", @"Jackson", @"Harris", @"Johnson", @"King"];
    NSString* name = namesArray[arc4random() % [namesArray count]];
    NSString* surname = surnamesArray[arc4random() % [surnamesArray count]];
    NSString* phoneNumber = [NSString stringWithFormat:@"%d", 1000000 + arc4random() % 8999999];
    NSString* emailAddress = [NSString stringWithFormat:@"%@.%c@mail.com", [name lowercaseString], [[surname lowercaseString] characterAtIndex:0]];
    [self addContactWithName:name surname:surname phoneNumber:phoneNumber emailAddress:emailAddress];
}

-(void)addContactsFromCSV:(NSString*)fileName
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
            [self addContactWithName:name surname:surname phoneNumber:phoneNumber emailAddress:emailAddress];
        }
    }
}

@end