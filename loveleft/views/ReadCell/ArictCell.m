//
//  ArictCell.m
//  loveleft
//
//  Created by qianfeng on 15/12/30.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "ArictCell.h"

@implementation ArictCell

#pragma mark -- 重写方法
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
#pragma mark -- 创建UI
-(void)createUI{

    _imageView = [FactoryUI createImageViewWithFrame:CGRectMake(10, 10, 120, 90) imageName:nil];
    [self.contentView addSubview:_imageView];
    
    _timeLabel = [FactoryUI createLabelWithFrame:CGRectMake(10, _imageView.frame.size.height+_imageView.frame.origin.y+10, 120, 20) text:nil textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:12]];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_timeLabel];
    
    _authorLabel = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W-120, _timeLabel.frame.origin.y, 110, 20) text:nil textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_authorLabel];
    
    _titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(_imageView.frame.origin.x+_imageView.frame.size.width+10, 30, 100, 40) text:nil textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:12]];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_titleLabel];
    

}
#pragma mark -- 赋值
-(void)refreshUI:(ReadModel *)model{


    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@""]];
    _titleLabel.text = model.title;
    _authorLabel.text = model.author;
    _timeLabel.text = model.createtime;


}
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
