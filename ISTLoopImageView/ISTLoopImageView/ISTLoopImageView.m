//
//  ISTLoopImageView.m
//  ISTLoopImageView
//
//  Created by Jone on 15/8/11.
//  Copyright (c) 2015年 HangZhou DeLan Technology Co. All rights reserved.
//

#import "ISTLoopImageView.h"

#define kPageControlHeight 37
#define kPageControlEachWidth 16
#define kDefaultDuration 2.0

@interface ISTLoopImageView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ISTLoopImageView

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
    if (!self) {  return nil; }
    [self setupUI];
    [self createImageView];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {  return nil; }
    [self setupUI];
    [self createImageView];
    
    return self;
}

#pragma mark - initializate Method

- (void)setupUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
     _scrollView = scrollView;
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.hidesForSinglePage = YES;
    [self addSubview:pageControl];
    _pageControl = pageControl;
  
    _loop = NO;
    _loopInterval = kDefaultDuration;
    _currentIndex = 0;
    _pageControlPosition = ISTPageControlPositionBottomRight;
    
}

- (void)createImageView
{
    UIImageView *leftImageView = [[UIImageView alloc] init];
    UIImageView *currentImageView = [[UIImageView alloc] init];
    UIImageView *rightImageView = [[UIImageView alloc] init];
    
    [self.scrollView addSubview:leftImageView];
    [self.scrollView addSubview:currentImageView];
    [self.scrollView addSubview:rightImageView];
    
    self.leftImageView = leftImageView;
    self.currentImageView = currentImageView;
    self.rightImageView = rightImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat imageViewWidth = CGRectGetWidth(self.bounds);
    CGFloat imageViewHeith = CGRectGetHeight(self.bounds);
    
    _leftImageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewHeith);
    _currentImageView.frame = CGRectMake(imageViewWidth, 0, imageViewWidth, imageViewHeith);
    _rightImageView.frame = CGRectMake(2 * imageViewWidth, 0, imageViewWidth, imageViewHeith);
    
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(3 * imageViewWidth, imageViewHeith);
    
    // start to set conten offset only fist time
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.scrollView setContentOffset:CGPointMake(imageViewWidth, 0)];
    });
    
    [self updateContent]; // update content image
    
}

#pragma mark - Public Method

- (void)startLoop
{
    [self stopTimer];
    
    _loop = YES;
    [self startTimer];
}

- (void)stopLoop
{
    _loop = NO;
    [self stopTimer];
}

#pragma mark - Private Method

- (void)startTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:_loopInterval target:self selector:@selector(timerActionToNextPage:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)timerActionToNextPage:(NSTimer *)timer
{
    // adjust offset after content has changed
    if (_scrollView.contentOffset.x != 0) {
        [_scrollView setContentOffset:CGPointMake(2 * CGRectGetWidth(self.bounds), 0) animated:YES];
    }
}

- (void)updateContent
{
    if (_loopImages.count == 0) {
        return;
    }else if (_loopImages.count == 1) {
        _scrollView.scrollEnabled = NO;
        [self stopLoop];
    }
    
    CGFloat scrollViewWidth = CGRectGetWidth(self.bounds);
    if (_scrollView.contentOffset.x > scrollViewWidth) {
        _leftImageView.tag = _currentImageView.tag;
        _currentImageView.tag = _rightImageView.tag;
        _rightImageView.tag = (_rightImageView.tag + 1) % _loopImages.count;
    }else if (_scrollView.contentOffset.x < scrollViewWidth) {
        _rightImageView.tag = _currentImageView.tag;
        _currentImageView.tag = _leftImageView.tag;
        _leftImageView.tag = (_leftImageView.tag - 1 + _loopImages.count) % _loopImages.count;
        
        
    }
    _leftImageView.image = _loopImages[_leftImageView.tag];
    _currentImageView.image = _loopImages[_currentImageView.tag];
    _rightImageView.image = _loopImages[_rightImageView.tag];
    
    // addjust offset secrectly with no animation
    [_scrollView setContentOffset:CGPointMake(scrollViewWidth, 0) animated:NO];
    
    _currentIndex = _currentImageView.tag;
    if ([_delegate respondsToSelector:@selector(loopImageView:didShowImageAtIndex:)]) {
        [_delegate loopImageView:self didShowImageAtIndex:_currentImageView.tag];
    }
}

#pragma mark - scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateContent];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateContent];
}

// stop the timer while scrolling
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isLoop) {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isLoop) {
        [self startTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // update pageControll page
    if (self.scrollView.contentOffset.x > self.scrollView.bounds.size.width * 1.5) {
        self.pageControl.currentPage = self.rightImageView.tag;
    } else if (self.scrollView.contentOffset.x < self.scrollView.bounds.size.width * 0.5) {
        self.pageControl.currentPage = self.leftImageView.tag;
    } else {
        self.pageControl.currentPage = self.currentImageView.tag;
    }
}

#pragma mark - Properties

- (void)setLoopImages:(NSArray *)loopImages
{
    if (loopImages.count < 1) {
        _leftImageView.image = nil;
        _currentImageView.image = nil;
        _rightImageView.image = nil;
    }else if (loopImages.count == 1) {
        _leftImageView.image = loopImages[0];
        _currentImageView.image = loopImages[0];
        _rightImageView.image = loopImages[0];
        _scrollView.scrollEnabled = NO;
    }else {
        _leftImageView.image = loopImages[loopImages.count - 1];
        _currentImageView.image = loopImages[0];
        _rightImageView.image = loopImages[1];
        
        _leftImageView.tag = loopImages.count - 1;
        _currentImageView.tag = 0;
        _rightImageView.tag = 1;
    }
    _loopImages = loopImages;
    _pageControl.numberOfPages = loopImages.count;
}

- (void)setPageControlPosition:(ISTPageControlPosition)pageControlPosition
{
    CGFloat pageControlCenterX;
    CGFloat pageControlCenterY;
    
    switch (pageControlPosition) {
        case ISTPageControlPositionBottomLeft: {
            pageControlCenterX = self.loopImages.count * kPageControlEachWidth / 2;
            break;
        }
        case ISTPageControlPositionBottomCenter: {
            pageControlCenterX = self.bounds.size.width / 2.0;
            break;
        }
        case ISTPageControlPositionBottomRight: {
            pageControlCenterX = self.bounds.size.width - self.loopImages.count * kPageControlEachWidth / 2.0;
            break;
        }
        default: {
            break;
        }
    }
    pageControlCenterY = self.bounds.size.height - kPageControlHeight / 2.0;
    _pageControl.center = CGPointMake(pageControlCenterX, pageControlCenterY);
    
    _pageControlPosition = pageControlPosition;
}

- (void)setLoopInterval:(NSTimeInterval)loopInterval
{
    _loopInterval = loopInterval > 0 ? loopInterval : kDefaultDuration;
    if (self.isLoop) {
         [self startLoop];
    }
}


@end
