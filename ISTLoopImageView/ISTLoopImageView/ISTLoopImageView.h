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
- (void)loopImageView:(ISTLoopImageView *)loopImageView didSelectedAtIndex:(NSInteger)index;
@end

@interface ISTLoopImageView : UIView

@property (nonatomic, strong) NSArray *loopImages;                          //
@property (nonatomic, assign) NSTimeInterval loopInterval;                  // default is 2.0f.
@property (nonatomic, assign) NSInteger currentIndex;                       // current index of visible image, value pinned to 0..loopImages.count-1.
@property (nonatomic, getter=isLoop) BOOL loop;                             // default is NO.
@property (nonatomic, assign) ISTPageControlPosition pageControlPosition;   // default is on the right.

- (void)startLoop;
- (void)stopLoop;

@end
