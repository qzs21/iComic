//
//  ComicMainListCell.h
//  iComic
//
//  Created by Steven on 15/9/12.
//  Copyright © 2015年 Neva. All rights reserved.
//

@import UIKit;

#import "HCSStarRatingView.h"

@interface ComicMainListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *scoreView;

@end
