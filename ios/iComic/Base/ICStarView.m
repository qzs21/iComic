//
//  ICStarView.m
//  iComic
//
//  Created by Steven on 15/9/13.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICStarView.h"


@implementation ICStarView

- (void)_commitInit
{
    _lineWidth = 1.f;
    _progress = 0.f;
}

- (void)awakeFromNib
{
    [self _commitInit];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self _commitInit];
    }
    return self;
}

- (instancetype)init
{
    if ([super init])
    {
        [self _commitInit];
    }
    return self;
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (UIColor *)backgroundColor
{
    if ([super backgroundColor])
    {
        return [super backgroundColor];
    }
    else
    {
        return self.isOpaque ? [UIColor whiteColor] : [UIColor clearColor];
    };
}

// Form HCSStarRatingView
- (void)_drawAccurateHalfStarShapeWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor lineWidth:(CGFloat)lineWidth progress:(CGFloat)progress
{
    UIBezierPath* starShapePath = UIBezierPath.bezierPath;
    [starShapePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62723 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02500 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37292 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.02500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39112 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.30504 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62908 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.20642 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.97500 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.78265 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.79358 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.97500 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.69501 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62908 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.97500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39112 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62723 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame))];
    [starShapePath closePath];
    starShapePath.miterLimit = 4;
    
    CGFloat frameWidth = frame.size.width;
    CGRect rightRectOfStar = CGRectMake(frame.origin.x + progress * frameWidth, frame.origin.y, frameWidth - progress * frameWidth, frame.size.height);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:CGRectInfinite];
    [clipPath appendPath:[UIBezierPath bezierPathWithRect:rightRectOfStar]];
    clipPath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    {
        [clipPath addClip];
        [tintColor setFill];
        [starShapePath fill];
    }
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
    
    [tintColor setStroke];
    starShapePath.lineWidth = lineWidth;
    [starShapePath stroke];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    NSLog(@"%@", self.tintColor);
    CGRect frame = CGRectMake(_lineWidth, _lineWidth, self.frame.size.width - _lineWidth * 2.f, self.frame.size.height - _lineWidth * 2.f);
    [self _drawAccurateHalfStarShapeWithFrame:frame tintColor:self.tintColor lineWidth:_lineWidth progress:_progress];
}

@end
