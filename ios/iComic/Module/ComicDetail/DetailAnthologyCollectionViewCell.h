//
//  DetailAnthologyCollectionViewCell.h
//  iComic
//
//  Created by 韦烽传 on 15/9/11.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailAnthologyCollectionViewCell : UICollectionViewCell

///封面
@property(nonatomic, weak) IBOutlet UIImageView * iconImageView;
///选集名称
@property(nonatomic, weak) IBOutlet UILabel * nameLabel;
///更新时间
@property(nonatomic, weak) IBOutlet UILabel * updateLabel;


@end
