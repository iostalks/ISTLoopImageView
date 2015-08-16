//
//  ISTTwoLoopImageView.m
//  ISTLoopImageView
//
//  Created by Jone on 15/8/16.
//  Copyright (c) 2015年 HangZhou DeLan Technology Co. All rights reserved.
//

#import "ISTTwoLoopImageView.h"

@interface ISTTwoLoopImageView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *cacheImageView;

@end

@implementation ISTTwoLoopImageView

- (instancetype)init
{
    self = [super init];
    if (!self) { return nil; }
    [self setupUI];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    [self setupUI];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) { return nil; }
    [self setupUI];
    
    return self;
}

- (void)setupUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *currentImageView = [[UIImageView alloc] init];
    [_scrollView addSubview:currentImageView];
    self.currentImageView = currentImageView;
    
    UIImageView *cacheImageView = [[UIImageView alloc] init];
    [_scrollView addSubview:cacheImageView];
    self.cacheImageView = cacheImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat imageWidth = self.bounds.size.width;
    CGFloat imageHeight = self.bounds.size.height;
    
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(3 * imageWidth, imageHeight);
    
    _currentImageView.frame = CGRectMake(imageWidth, 0, imageWidth, imageHeight);
    _cacheImageView.frame = CGRectMake(2 * imageWidth, 0, imageWidth, imageHeight);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _scrollView.contentOffset = CGPointMake(imageWidth, 0);
    });
}

- (void)setImages:(NSArray *)images
{
    if (images.count == 0) {
        return;
    }else if(images.count == 1){
        _currentImageView.image = images[0];
        _cacheImageView.image = images[0];
        _scrollView.scrollEnabled = NO;
    }else {
        _currentImageView.image = images[0];
        _cacheImageView.image = images[1];
    }
    _images = images;
    
    _currentImageView.tag = 0;
    _cacheImageView.tag = 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat imageWidth = self.bounds.size.width;
    CGFloat imageHeight = self.bounds.size.height;
    
    if (offset < self.bounds.size.width) {
        _cacheImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
        _cacheImageView.tag = ((_currentImageView.tag - 1) + _images.count) % _images.count;
        _cacheImageView.image = _images[_cacheImageView.tag];
    }else if (offset > self.bounds.size.width) {
        _cacheImageView.frame = CGRectMake(imageWidth * 2, 0, imageWidth, imageHeight);
        _cacheImageView.tag = (_currentImageView.tag + 1) % _images.count;
        _cacheImageView.image = _images[_cacheImageView.tag];
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    if (offset > self.bounds.size.width * 0.5 && offset < self.bounds.size.width * 1.5) {
        return;
    }
    
    scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    _currentImageView.image = _cacheImageView.image;
    _currentImageView.tag = _cacheImageView.tag;
    if ([_delegate respondsToSelector:@selector(twoLoopImageView:didShowAtIndex:)]) {
        [_delegate twoLoopImageView:self didShowAtIndex:_currentImageView.tag];
    }
}
@end
