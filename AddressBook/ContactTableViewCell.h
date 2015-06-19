//
//  ContactTableViewCell.h
//  AddressBook
//
//  Created by Gabi on 19/06/15.
//  Copyright (c) 2015 gn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* fullName;
@property (nonatomic, strong) IBOutlet UILabel* phoneNumber;
@property (nonatomic, strong) IBOutlet UILabel* emailAddress;

@end
