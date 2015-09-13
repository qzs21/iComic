//
//  ICHeartView.m
//  iComic
//
//  Created by Steven on 15/9/13.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ICHeartView.h"

@import ReactiveCocoa;

@implementation ICHeartView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        _fillColor = self.backgroundColor;
        _lineColor = [UIColor redColor];
        _lineWidth = 1.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    CGPoint start = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
    CGPoint center = CGPointMake(0, self.frame.size.height * 0.3);
    CGPoint control = CGPointMake(0, 0);
    CGPoint end   = CGPointMake(self.frame.size.width / 2, 0);
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
    [path moveToPoint:start];
    [path addLineToPoint:center];
    [path addQuadCurveToPoint:end controlPoint:control];
    [path addLineToPoint:start];
    path.lineWidth = _lineWidth;
    
    [_fillColor setFill];
    [_lineColor setStroke];
    [path fill];
    [path stroke];
    
    
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    // CGContextTranslateCTM(context, 50, 50);
    
    // Adjust the drawing options as needed.
    // aPath.lineWidth = 5;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    // [aPath fill];
    // [aPath stroke];

}


@end
