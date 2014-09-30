//
//  MMDeletePageSidebar.m
//  LooseLeaf
//
//  Created by Adam Wulf on 9/29/14.
//  Copyright (c) 2014 Milestone Made, LLC. All rights reserved.
//

#import "MMDeletePageSidebarController.h"

#define kBorderWidth 3
#define kBorderSpacing 2
#define kStripeHeight 40.0

@implementation MMDeletePageSidebarController{
    UIView* deleteSidebarBackground;
    UIView* deleteSidebarForeground;
}

@synthesize deleteSidebarBackground;
@synthesize deleteSidebarForeground;

-(id) initWithFrame:(CGRect)frame{
    if(self = [super init]){
        CGFloat centerY = frame.size.height / 2;
        CGFloat curveSize = 20.0;
        
        UIColor* borderColor = [[UIColor whiteColor] colorWithAlphaComponent:.9];
        
        deleteSidebarBackground = [[UIView alloc] initWithFrame:frame];
        deleteSidebarBackground.backgroundColor = [UIColor clearColor];
        deleteSidebarForeground = [[UIView alloc] initWithFrame:frame];
        deleteSidebarForeground.backgroundColor = [UIColor clearColor];
        [self showSidebarWithPercent:0];
        
        CGFloat thetaLarge = atan(centerY/curveSize);
        CGFloat thetaSmall = M_PI - 2*thetaLarge;
        CGFloat radius = centerY / tan(thetaSmall);

        // border path
        CGPoint center = CGPointMake(frame.size.width-radius, frame.size.height/2);
        UIBezierPath* borderPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius - kBorderWidth startAngle:0 endAngle:2*M_PI clockwise:YES];
        [borderPath appendPath:[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES]];
        // right border layer and mask
        CALayer* rightBorder = [self giveLayerDefaultProperties:[CALayer layer]];
        rightBorder.backgroundColor = borderColor.CGColor;
        CAShapeLayer* rightBorderMask = [CAShapeLayer layer];
        rightBorderMask.backgroundColor = [UIColor whiteColor].CGColor;
        rightBorderMask.path = borderPath.CGPath;
        rightBorderMask.fillRule = kCAFillRuleEvenOdd;
        rightBorder.mask = rightBorderMask;
        
        
        // default fill w/o stripes
        UIImageView* trashBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crumple.jpg"]];
        CGPoint center2 = CGPointMake(trashBackground.bounds.size.width-radius, frame.size.height/2);
        UIBezierPath* fillPath = [UIBezierPath bezierPathWithArcCenter:center2 radius:radius - kBorderSpacing - kBorderWidth startAngle:0 endAngle:2*M_PI clockwise:YES];
        trashBackground.alpha = 0.4;
        trashBackground.frame = CGRectMake(frame.size.width - trashBackground.bounds.size.width, 0, trashBackground.bounds.size.width, frame.size.height);
        CAShapeLayer* trashBackgroundMask = [CAShapeLayer layer];
        trashBackgroundMask.backgroundColor = [UIColor whiteColor].CGColor;
        trashBackgroundMask.path = fillPath.CGPath;
        trashBackground.layer.mask = trashBackgroundMask;
        deleteSidebarBackground.layer.backgroundColor = [UIColor clearColor].CGColor;
        [deleteSidebarBackground.layer addSublayer:rightBorder];
        [deleteSidebarBackground addSubview:trashBackground];
        
    }
    return self;
}

-(id) giveLayerDefaultProperties:(CALayer*)layer{
    layer.bounds = deleteSidebarBackground.bounds;
    layer.position = CGPointMake(deleteSidebarBackground.frame.size.width/2, deleteSidebarBackground.frame.size.height/2);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    return layer;
}

-(UIBezierPath*) pathForSidebarBackground:(CGFloat)radius withFrame:(CGRect)frame{
    CGPoint center = CGPointMake(frame.size.width-radius, 512);
    
    UIBezierPath* circle = [UIBezierPath bezierPathWithArcCenter:center radius:radius - 4 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [circle appendPath:[UIBezierPath bezierPathWithArcCenter:center radius:radius - 2 startAngle:0 endAngle:2*M_PI clockwise:YES]];
    [circle appendPath:[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES]];
    circle.usesEvenOddFillRule = YES;
    
    
    
    return circle;
}

-(void) showSidebarWithPercent:(CGFloat)percent{
    CGRect fr = CGRectMake(-deleteSidebarForeground.bounds.size.width + 200 * percent, 0, deleteSidebarForeground.bounds.size.width, deleteSidebarForeground.bounds.size.height);
    deleteSidebarBackground.frame = fr;
    deleteSidebarForeground.frame = fr;
    
//    fr = deleteSidebarBackground.bounds;
//    deleteSidebarBackground.frame = fr;
//    deleteSidebarForeground.frame = fr;
}


@end