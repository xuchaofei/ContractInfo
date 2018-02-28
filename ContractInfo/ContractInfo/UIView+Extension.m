//
//  UIView+Extension.m
//  ContractInfo
//
//  Created by csm on 2018/2/6.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(void)setMW_x:(CGFloat)MW_x{
    
    CGRect frame = self.frame;
    frame.origin.x = MW_x;
    self.frame = frame;
}

-(CGFloat)MW_x{
    return self.frame.origin.x;
}

-(void)setMW_y:(CGFloat)MW_y{
    
    CGRect frame = self.frame;
    frame.origin.y = MW_y;
    self.frame = frame;
    
}

-(CGFloat)MW_y{
    return self.frame.origin.y;
}

-(void)setMW_width:(CGFloat)MW_width{
    
    CGRect frame = self.frame;
    frame.size.width = MW_width;
    self.frame = frame;
}

-(CGFloat)MW_width{
    return self.frame.size.width;
}

-(void)setMW_height:(CGFloat)MW_height{
    
    CGRect frame = self.frame;
    frame.size.height = MW_height;
    self.frame = frame;
    
}

-(CGFloat)MW_height{
    return self.frame.size.height;
}
@end
