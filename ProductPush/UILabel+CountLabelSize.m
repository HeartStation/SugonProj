//
//  UILabel+CountLabelSize.m
//  ProductPush
//
//  Created by 高振伟 on 15-6-27.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "UILabel+CountLabelSize.h"

@implementation UILabel (CountLabelSize)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize labelSize = [self.text boundingRectWithSize:size options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
    
    return labelSize;
}

@end
