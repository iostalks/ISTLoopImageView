//
//  ISTCollectionImageView.h
//  ISTLoopImageView
//
//  Created by Jone on 15/8/16.
//  Copyright (c) 2015年 HangZhou DeLan Technology Co. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ISTCollectionImageView : UIView

@property (nonatomic, strong) NSArray *collectionImages;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;  // default is UICollectionViewScrollDirectionHorizontal.

@end
