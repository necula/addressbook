//
//  ContactsManager.m
//  AddressBook
//
//  Created by Gabi on 18/06/15.
//  Copyright (c) 2015 gn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactsManager.h"

@interface ContactsManager ()

@property (nonatomic, strong) NSMutableArray* contactsArray;

-(instancetype)init;

@end

static ContactsManager* s_sharedInstance = nil;

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
    
    return self;
}

@end