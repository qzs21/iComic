//
//  ComicReaderTableViewCell.m
//  iComic
//
//  Created by Steven on 15/9/12.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ComicReaderTableViewCell.h"

@import Masonry;
@import ReactiveCocoa;
@import NSObjectExtend;

@implementation ComicReaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexCode:@"F0F0F0"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 添加UIImageView
        _contentImg = [[UIImageView alloc] init];
        [self.contentView addSubview:_contentImg];
        @weakify(self);
        [_contentImg mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.edges.equalTo(self.contentView);
        }];
        
        // 添加UILabel
        _titleLab = [[UILabel alloc] init];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@4);
            make.top.equalTo(@4);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
