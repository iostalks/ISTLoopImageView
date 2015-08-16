//
//  ISTTwoLoopImageView.h
//  ISTLoopImageView
//
//  Created by Jone on 15/8/16.
//  Copyright (c) 2015年 HangZhou DeLan Technology Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ISTTwoLoopImageView;
@protocol ISTTwoLoopImageViewDelegate <NSObject>

- (void)twoLoopImageView:(ISTTwoLoopImageView *)loopImageView didShowAtIndex:(NSUInteger)index;

@end

@interface ISTTwoLoopImageView : UIView

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, weak) id<ISTTwoLoopImageViewDelegate> delegate;

@end
