//
//  Contact.m
//  AddressBook
//
//  Created by Gabi on 18/06/15.
//  Copyright (c) 2015 gn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@implementation Contact

-(instancetype)initWithName:(NSString*)name surname:(NSString*)surname phoneNumber:(NSString*)phoneNumber emailAddress:(NSString*)emailAddress UID:(unsigned int)UID
{
    self = [super init];
    
    if(!self)
        return nil;
    
    _name = name;
    _surname = surname;
    _phoneNumber = phoneNumber;
    _emailAddress = emailAddress;
    _UID =  UID;
    
    return self;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@ %@ - %@ - %@", _name, _surname, _phoneNumber, _emailAddress];
}

@end