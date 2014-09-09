//
//  MMCloudKeyIconView.m
//  LooseLeaf
//
//  Created by Adam Wulf on 9/8/14.
//  Copyright (c) 2014 Milestone Made, LLC. All rights reserved.
//

#import "MMCloudKeyIconView.h"

@implementation MMCloudKeyIconView


-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    CGRect frame = CGRectMake(0, 0, MIN(rect.size.width, rect.size.height), MIN(rect.size.width, rect.size.height));
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fullWhite = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.682];
    UIColor* halfWhite = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.503];
    UIColor* barelyWhite = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.244];
    UIColor* borderColor = [UIColor colorWithRed: 0.221 green: 0.221 blue: 0.219 alpha: 1];
    
    //// Gradient Declarations
    CGFloat gradient4Locations[] = {0, 0.23, 0.52, 1};
    CGGradientRef gradient4 = CGGradientCreateWithColors(colorSpace, (CFArrayRef)@[(id)fullWhite.CGColor, (id)[UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.592].CGColor, (id)halfWhite.CGColor, (id)barelyWhite.CGColor], gradient4Locations);
    
    //// Image Declarations
    UIImage* screenShot20140908At111818PM = [UIImage imageNamed: @"screenShot20140908At111818PM.png"];
    
    //// Screen Shot 2014-09-08 at 11.18.18 PM 2 Drawing
    UIBezierPath* screenShot20140908At111818PM2Path = [UIBezierPath bezierPathWithRect: CGRectMake(-17, -102, 329, 494)];
    CGContextSaveGState(context);
    [screenShot20140908At111818PM2Path addClip];
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawTiledImage(context, CGRectMake(-17, 102, screenShot20140908At111818PM.size.width, screenShot20140908At111818PM.size.height), screenShot20140908At111818PM.CGImage);
    CGContextRestoreGState(context);
    
    
    //// Key Drawing
    UIBezierPath* keyPath = UIBezierPath.bezierPath;
    [keyPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54736 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.09002 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.70127 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.25768 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.70425 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.09197 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.70127 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.25768 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.79499 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35856 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.70127 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.25768 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.79689 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.26596 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.71058 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45384 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.79308 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45115 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.71058 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45384 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45384 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.58499 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.56499 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.51501 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.56499 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.58999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61501 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.55999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65501 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.55999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.71001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.74001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.80001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.58499 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.83501 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.58499 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.85501 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.47999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96001 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.44999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.93001 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.47999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96001 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.46567 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.94570 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.44999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.43499 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.43499 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.91501 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.89001 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.42139 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.90141 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.89001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.36499 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47001 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.36499 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45384 * CGRectGetHeight(frame))];
    [keyPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.28167 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45384 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.19999 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34491 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.28167 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45384 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.19977 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.43805 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.27600 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.24710 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.20016 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.26837 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.27153 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.24829 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.34810 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.16915 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.27621 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.24705 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.27531 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.17140 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40011 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.18838 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.36630 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.16859 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40011 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.18838 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54736 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.09002 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40011 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.18838 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.44740 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08878 * CGRectGetHeight(frame))];
    [keyPath closePath];
    [keyPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.32172 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.21672 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.32172 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.27328 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.30609 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.23234 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.30609 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.25766 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37828 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.27328 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.33734 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.28891 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.36266 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.28891 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37828 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.21672 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39391 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.25766 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39391 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.23234 * CGRectGetHeight(frame))];
    [keyPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.32172 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.21672 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.36266 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.20109 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.33734 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.20109 * CGRectGetHeight(frame))];
    [keyPath closePath];
    CGContextSaveGState(context);
    [keyPath addClip];
    CGRect keyBounds = CGPathGetPathBoundingBox(keyPath.CGPath);
    CGContextDrawLinearGradient(context, gradient4,
                                CGPointMake(CGRectGetMidX(keyBounds) + 21.1 * CGRectGetWidth(keyBounds) / 119.01, CGRectGetMidY(keyBounds) + -177.39 * CGRectGetHeight(keyBounds) / 174),
                                CGPointMake(CGRectGetMidX(keyBounds) + 20.09 * CGRectGetWidth(keyBounds) / 119.01, CGRectGetMidY(keyBounds) + -4.66 * CGRectGetHeight(keyBounds) / 174),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    [borderColor setStroke];
    keyPath.lineWidth = 1;
    [keyPath stroke];
    
    
    //// Cleanup
    CGGradientRelease(gradient4);
    CGColorSpaceRelease(colorSpace);

}


@end
