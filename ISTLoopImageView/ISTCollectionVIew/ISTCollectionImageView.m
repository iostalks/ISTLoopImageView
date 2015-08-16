//
//  ISTCollectionImageView.m
//  ISTLoopImageView
//
//  Created by Jone on 15/8/16.
//  Copyright (c) 2015年 HangZhou DeLan Technology Co. All rights reserved.
//

#import "ISTCollectionImageView.h"

NSString * const ISTCollectionViewCellIdentifier = @"ISTCollectionViewCellIdentifier";

@interface ISTCollectionImageView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;

@end

@implementation ISTCollectionImageView

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) { return nil; }
    [self setupUI];
    
    return self;
}

- (void)setupUI
{
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewFlowLayout.minimumInteritemSpacing = 0.0f;
    collectionViewFlowLayout.minimumLineSpacing = 0.0f;
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewFlowLayout.scrollDirection = _scrollDirection;
    self.collectionFlowLayout = collectionViewFlowLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewFlowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ISTCollectionViewCellIdentifier];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _collectionFlowLayout.scrollDirection = _scrollDirection;
    _collectionFlowLayout.itemSize = self.bounds.size;
}

#pragma mark - colloction view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _collectionImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ISTCollectionViewCellIdentifier forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = self.bounds;
    if (_collectionImages.count > 0) { imageView.image = _collectionImages[indexPath.row];}
    cell.backgroundView = imageView;
    
    return cell;
}

#pragma mark - collection view delegate
@end
