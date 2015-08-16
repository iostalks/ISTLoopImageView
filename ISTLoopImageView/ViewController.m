//
//  ViewController.m
//  ISTLoopImageView
//
//  Created by Jone on 15/8/11.
//  Copyright (c) 2015年 HangZhou DeLan Technology Co. All rights reserved.
//

#import "ViewController.h"
#import "ISTLoopImageView.h"

@interface ViewController ()<UIGestureRecognizerDelegate, ISTLoopImageViewDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) ISTLoopImageView *loopImageView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ISTLoopImageView *loopImageView = [[ISTLoopImageView alloc] initWithFrame:CGRectMake(16, 100, 288, 150)];
    loopImageView.center = self.view.center;
    loopImageView.loopImages = self.images;
    loopImageView.loopInterval = 3.0f;
    loopImageView.pageControlPosition = ISTPageControlPositionBottomRight;
    loopImageView.delegate = self;
    [self.view addSubview:loopImageView];
    self.loopImageView = loopImageView;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [_loopImageView startLoop];
}

- (NSArray *)images
{
    if (nil == _images) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index < 2; ++index) {
            NSString *imageName = [NSString stringWithFormat:@"image%ld",index];
            UIImage *image = [UIImage imageNamed:imageName];
            [array addObject:image];
        }
        _images = array;
    }
    return _images;
}

#pragma mark - ISTLoopImageViewDelegate

- (void)loopImageView:(ISTLoopImageView *)loopImageView didShowImageAtIndex:(NSInteger)index
{
    NSLog(@"show index:%ld",(long)index);
}
@end
