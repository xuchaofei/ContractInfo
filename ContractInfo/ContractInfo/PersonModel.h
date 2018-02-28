//
//  PersonModel.h
//  ContractInfo
//
//  Created by csm on 2018/1/18.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject


@property (nonatomic, copy) NSString * firstName;

@property (nonatomic, copy) NSString * lastName;

@property (nonatomic, copy) NSString * phonename;

@property (nonatomic, strong) NSArray * phoneNumberArray;

@property (nonatomic, retain) NSString *email;

@property(nonatomic, strong) NSData *icon;//图片

@property (nonatomic, copy) NSString * contactName;

@property (nonatomic, copy) NSString * contactNote;

@property (nonatomic, strong) NSArray * contactPhone;




@end
