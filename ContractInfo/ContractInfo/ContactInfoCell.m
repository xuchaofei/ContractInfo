//
//  ContactInfoCell.m
//  ContractInfo
//
//  Created by csm on 2018/2/6.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import "ContactInfoCell.h"
#import "UIView+Extension.h"

#define screenwidth [UIScreen mainScreen].bounds.size.width
#define screenheight [UIScreen mainScreen].bounds.size.height

@interface ContactInfoCell ()

@property (nonatomic, weak) UILabel * nameLabel;
@property (nonatomic, weak) UILabel * phoneLabel;
@property (nonatomic, weak) UILabel * noteLabel;
@end

@implementation ContactInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView * headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        UIImage * headImage = [UIImage imageNamed:@"schoolcoach"];
        headImage = [headImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        headImageView.image = headImage;
        [self.contentView addSubview:headImageView];
        
        CGFloat nameLabelX = CGRectGetMaxX(headImageView.frame) + 10;
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelX, 10, 50, 16)];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = [UIColor blackColor];

        [self.contentView addSubview:nameLabel];
        _nameLabel = nameLabel;
        
        CGFloat phoneLabelX = CGRectGetMaxX(nameLabel.frame) + 10;
        UILabel * phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(phoneLabelX, 10, 100, 16)];
        phoneLabel.font = [UIFont systemFontOfSize:16];
        phoneLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:phoneLabel];
        _phoneLabel = phoneLabel;
        
        CGFloat noteLabelY = CGRectGetMaxY(nameLabel.frame) + 10;
        CGFloat noteLabelWidth = screenwidth - nameLabelX - 10;
        UILabel * noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelX, noteLabelY, noteLabelWidth, 16)];
        noteLabel.font = [UIFont systemFontOfSize:16];
        noteLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:noteLabel];
        _noteLabel = noteLabel;
        
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString * contactId = @"ContactCell";
    ContactInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:contactId];
    
    if (!cell) {
        cell = [[ContactInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactId];
    }
    
    return cell;
}

-(void)setModel:(PersonModel *)model{
    _model = model;
    
    _nameLabel.text = model.contactName;
    
    _nameLabel.MW_width = [model.contactName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].width;
    
    NSString * phoneNumber = model.contactPhone[0];
    phoneNumber = [self trimingStringWith:phoneNumber];
    _phoneLabel.text = phoneNumber;
    _phoneLabel.MW_width = [phoneNumber sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].width;
    _phoneLabel.MW_x = screenwidth - 10 - _phoneLabel.MW_width;

    _noteLabel.text = model.contactNote;
}

-(NSString *)trimingStringWith:(NSString *)string{
    
    if (string == nil) {
        return nil;
    }
    
    NSMutableString * mutableStr = [[NSMutableString alloc] initWithString:string];
    NSRange range = [mutableStr rangeOfString:@"("];
    if (range.length > 0) {
        [mutableStr deleteCharactersInRange:range];
    }
    
    range = [mutableStr rangeOfString:@")"];
    if (range.length > 0) {
        [mutableStr deleteCharactersInRange:range];
    }
    
    range = [mutableStr rangeOfString:@"-"];
    if (range.length > 0) {
        [mutableStr deleteCharactersInRange:range];
    }
    
    return [NSString stringWithFormat:@"%@",mutableStr];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
