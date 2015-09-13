//
//  ICBaseViewController.h
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

@import UIKit;
@import ReactiveCocoa;
@import NSObjectExtend;
@import BlocksKit;
@import SDWebImage;
@import SVProgressHUD;
@import Masonry;


#define ICTintColor             [UIColor colorWithHexCode:@"007AFF"]
#define ICBackgroundColor       [UIColor colorWithHexCode:@"F0F0F0"]
#define ICAPIDateFormat         @"yyyy-MM-dd HH:mm:ss"

#import "ICNetworkDataCenter.h"


@interface ICBaseViewController : UIViewController

@end
