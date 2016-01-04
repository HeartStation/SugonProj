//
//  CollectionCellBackground.m
//  TaoXue
//
//  Created by 高振伟 on 14-7-21.
//  Copyright (c) 2014年 BIT. All rights reserved.
//

#import "CollectionCellBackground.h"

@implementation CollectionCellBackground

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(aRef);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    [bezierPath setLineWidth:5.0f];
    [[UIColor blackColor] setStroke];
    
    UIColor *fillColor = [UIColor colorWithRed:0.529 green:0.808 blue:0.922 alpha:1]; 
    [fillColor setFill];
    
    [bezierPath stroke];
    [bezierPath fill];
    CGContextRestoreGState(aRef);
}

@end
