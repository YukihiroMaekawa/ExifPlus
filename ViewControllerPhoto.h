//
//  ViewControllerPhoto.h
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/05/01.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewTabData.h"

@interface ViewControllerPhoto : UIViewController<UIScrollViewDelegate>
{
    ViewTabData * _tempData;
    ALAssetsLibrary *_library;
    ALAsset * _asset;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
