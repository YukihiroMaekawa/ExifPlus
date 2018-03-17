//
//  ViewControllerPhoto.m
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/05/01.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerPhoto.h"

@interface ViewControllerPhoto ()

@end

@implementation ViewControllerPhoto

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *doubleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 3.0f;
    self.scrollView.delegate = self;
    
    _tempData = [ViewTabData sharedManager];
    //URLからALAssetを取得
    _library = [[ALAssetsLibrary alloc]init];
    _asset = [[ALAsset alloc] init];

    [_library assetForURL:_tempData.assetURL resultBlock:^(ALAsset *asset){
         _asset = asset;
         //画像があればYES、無ければNOを返す
         if(_asset)
         {
             ALAssetRepresentation *representation = [_asset defaultRepresentation];
             self.imageView.image = [UIImage imageWithCGImage:[representation fullScreenImage]];
             //self.imageView.contentMode= UIViewContentModeScaleAspectFill;
             self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
    } failureBlock: nil];
}

- (void)doubleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    CGRect zoomRect;
    if (self.scrollView.zoomScale > 1.0) {
        zoomRect = self.scrollView.bounds;
    } else {
        zoomRect = [self zoomRectForScrollView:self.scrollView
                                        withScale:2.0
                                    withCenter:location];
    }
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.title = @"写真";
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
