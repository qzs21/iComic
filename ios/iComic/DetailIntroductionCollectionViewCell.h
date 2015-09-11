//
//  DetailIntroductionCollectionViewCell.h
//  iComic
//
//  Created by 韦烽传 on 15/9/11.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailIntroductionCollectionViewCell : UICollectionViewCell

///封面
@property(nonatomic, weak) IBOutlet UIImageView * iconImageView;
///漫画名称
@property(nonatomic, weak) IBOutlet UILabel * nameLabel;
///更新集数
@property(nonatomic, weak) IBOutlet UILabel * updateNumLabel;
///简介
@property(nonatomic, weak) IBOutlet UILabel * introductionLabel;
///观看
@property(nonatomic, weak) IBOutlet UIButton * watchButton;


@end
