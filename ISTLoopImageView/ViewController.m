//
//  ViewController.m
//  ISTLoopImageView
//
//  Created by Jone on 15/8/11.
//  Copyright (c) 2015年 HangZhou DeLan Technology Co. All rights reserved.
//

#import "ViewController.h"
#import "ISTLoopImageView.h"
#import "ISTCollectionImageView.h"
#import "ISTTwoLoopImageView.h"

@interface ViewController ()<UIGestureRecognizerDelegate, ISTLoopImageViewDelegate, ISTTwoLoopImageViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) ISTLoopImageView *loopImageView;
@property (nonatomic, strong) ISTCollectionImageView *collectionImageView;
@property (nonatomic, strong) ISTTwoLoopImageView *twoLoopImageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self creatLoopImageView];
}

#pragma mark - Initialize Mehtod

- (void)creatLoopImageView
{
    ISTLoopImageView *loopImageView = [[ISTLoopImageView alloc] initWithFrame:CGRectMake(16, 100, 288, 150)];
    loopImageView.center = self.view.center;
    loopImageView.loopImages = self.images;
    loopImageView.loopInterval = 3.0f;
    loopImageView.pageControlPosition = ISTPageControlPositionBottomRight;
    loopImageView.delegate = self;
    [self.view addSubview:loopImageView];
    self.loopImageView = loopImageView;
    
    [self.loopImageView startLoop];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGetureReponse)];
    [self.loopImageView addGestureRecognizer:tap];
}

- (void)creatCollectionImageView
{
    ISTCollectionImageView *collectionImageView = [[ISTCollectionImageView alloc] initWithFrame:CGRectMake(16, 100, 288, 150)];
    collectionImageView.center = self.view.center;
    collectionImageView.collectionImages = self.images;
    collectionImageView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:collectionImageView];
    self.collectionImageView = collectionImageView;
}

- (void)creatTwoImageView
{
    ISTTwoLoopImageView *twoImageView = [[ISTTwoLoopImageView alloc] initWithFrame:CGRectMake(16, 100, 288, 150)];
    twoImageView.center = self.view.center;
    twoImageView.images = self.images;
    twoImageView.delegate = self;
    [self.view addSubview:twoImageView];
    self.twoLoopImageView = twoImageView;
}

#pragma mark - Properies

- (NSArray *)images
{
    if (nil == _images) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index < 4; ++index) {
            NSString *imageName = [NSString stringWithFormat:@"image%ld",index];
            UIImage *image = [UIImage imageNamed:imageName];
            [array addObject:image];
        }
        _images = array;
    }
    return _images;
}

- (IBAction)segmentAction:(UISegmentedControl *)sender
{
    [_loopImageView stopLoop];
    switch (sender.selectedSegmentIndex) {
        case 0:
            if (_loopImageView) {
                [_loopImageView removeFromSuperview];
            }
            [self creatLoopImageView];
            break;
            
        case 1:
            if (_collectionImageView) {
                [_collectionImageView removeFromSuperview];
            }
            [self creatCollectionImageView];
            break;
            
        case 2:
            if (_twoLoopImageView) {
                [_twoLoopImageView removeFromSuperview];
            }
            [self creatTwoImageView];
            break;
        default:
            break;
    }
}

- (void)tapGetureReponse
{
    NSLog(@"tap at index: %ld",(long)_loopImageView.currentIndex);
}

#pragma mark - ISTLoopImageViewDelegate

- (void)loopImageView:(ISTLoopImageView *)loopImageView didShowImageAtIndex:(NSInteger)index
{
    NSLog(@"show index:%ld",(long)index);
}

#pragma mark - ISTTwoLoopImageViewDelegate

- (void)twoLoopImageView:(ISTTwoLoopImageView *)loopImageView didShowAtIndex:(NSUInteger)index
{
    NSLog(@"two show index:%ld",(long)index);
}

@end
