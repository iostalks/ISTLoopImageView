//
//  ISTLoopImageView.h
//  ISTLoopImageView
//
//  Created by Jone on 15/8/11.
//  Copyright (c) 2015年 HangZhou DeLan Technology Co. All rights reserved.
//
/**
 *  use there imageView to implement infinit loop image
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ISTPageControlPosition)
{
    ISTPageControlPositionBottomLeft,
    ISTPageControlPositionBottomCenter,
    ISTPageControlPositionBottomRight
};

@class ISTLoopImageView;
@protocol ISTLoopImageViewDelegate <NSObject>
- (void)loopImageView:(ISTLoopImageView *)loopImageView didShowImageAtIndex:(NSInteger)index;
@end

@interface ISTLoopImageView : UIView

@property (nonatomic, strong) NSArray *loopImages;                          //
@property (nonatomic, assign) NSTimeInterval loopInterval;                  // default is 2.0f.
@property (nonatomic, getter=isLoop) BOOL loop;                             // default is NO.
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) ISTPageControlPosition pageControlPosition;   // default is on the right.
@property (nonatomic, weak) id<ISTLoopImageViewDelegate>delegate;

- (void)startLoop;
- (void)stopLoop;

@end
