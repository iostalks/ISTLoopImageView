//
//  ISTCollectionImageView.m
//  ISTLoopImageView
//
//  Created by Jone on 15/8/16.
//  Copyright (c) 2015年 HangZhou DeLan Technology Co. All rights reserved.
//

#import "ISTCollectionImageView.h"

@interface ISTCollectionImageView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ISTCollectionImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    [self setupUI];

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) { return nil; }
    [self setupUI];
    
    return self;
}

- (void)setupUI
{
    UICollectionView *collectionView = [[UICollectionView alloc] init];
    collectionView.minimumZoomScale = 0;
    collectionView.maximumZoomScale = 0;
}

#pragma mark - colloction view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



#pragma mark - collection view delegate
@end
