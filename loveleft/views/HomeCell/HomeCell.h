//
//  HomeCell.h
//  loveleft
//
//  Created by qianfeng on 15/12/29.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface HomeCell : UITableViewCell
{

    UIImageView * _imageView;
    
    UILabel * _titleLabel;

}

-(void)refreshUI:(HomeModel *)model;

@end
