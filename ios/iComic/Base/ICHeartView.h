//
//  ICHeartView.h
//  iComic
//
//  Created by Steven on 15/9/13.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ICHeartView : UIView

@property (nonatomic, strong) IBInspectable UIColor * fillColor;  ///< 填充色 (default: self.view.backgroundColor)

@property (nonatomic, assign) IBInspectable CGFloat lineWidth;    ///< 线条宽度 (default: 1.0)

@property (nonatomic, strong) IBInspectable UIColor * lineColor;  ///< 线条颜色 (default: [UIColor redColor])

@end
