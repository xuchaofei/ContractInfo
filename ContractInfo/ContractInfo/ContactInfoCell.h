//
//  ContactInfoCell.h
//  ContractInfo
//
//  Created by csm on 2018/2/6.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"

@interface ContactInfoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)PersonModel * model;

@end
