//
//  Contact.h
//  AddressBook
//
//  Created by Gabi on 19/06/15.
//  Copyright (c) 2015 gn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic) int32_t uid;

@end
