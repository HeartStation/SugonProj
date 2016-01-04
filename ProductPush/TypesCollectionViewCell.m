//
//  TypesCollectionViewCell.m
//  ProductPush
//
//  Created by 高振伟 on 15-6-21.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "TypesCollectionViewCell.h"

#import "CollectionCellBackground.h"

@implementation TypesCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // change to our custom selected background view
//        CollectionCellBackground *backgroundView = [[CollectionCellBackground alloc] initWithFrame:CGRectZero];
//        self.selectedBackgroundView = backgroundView;
    }
    return self;
}

@end
