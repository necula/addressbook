//
//  Contact.h
//  AddressBook
//
//  Created by Gabi on 18/06/15.
//  Copyright (c) 2015 gn. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* surname;
@property (nonatomic, copy) NSString* phoneNumber;
@property (nonatomic, copy) NSString* emailAddress;

-(instancetype)initWithName:(NSString*)name surname:(NSString*)surname phoneNumber:(NSString*)phoneNumber emailAddress:(NSString*)emailAddress;

@end