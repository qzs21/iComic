//
//  ICStarView.h
//  iComic
//
//  Created by Steven on 15/9/13.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
/**
 *  绘制一个星星✨
 */
@interface ICStarView : UIControl

@property (nonatomic, assign) IBInspectable CGFloat lineWidth;    ///< 线条宽度 (default: 1.0)

@property (nonatomic, assign) IBInspectable CGFloat progress;       ///< 星星填充的进度 (default: 0.f)

@end
