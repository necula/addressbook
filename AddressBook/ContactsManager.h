//
//  ContactsManager.h
//  AddressBook
//
//  Created by Gabi on 18/06/15.
//  Copyright (c) 2015 gn. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

@interface ContactsManager : NSObject

+(instancetype)sharedInstance;

-(NSArray*)getContacts;
-(void)removeContactWithUID:(unsigned int)UID;
-(void)addRandomContact;

@end
