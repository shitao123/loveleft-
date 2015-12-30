//
//  ArictCell.h
//  loveleft
//
//  Created by qianfeng on 15/12/30.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadModel.h"
@interface ArictCell : UITableViewCell
{

    //图片
    UIImageView * _imageView;
    //时间
    UILabel * _timeLabel;
    //作者
    UILabel * _authorLabel;
    
    UILabel * _titleLabel;


}
-(void)refreshUI:(ReadModel *)model;
@end
