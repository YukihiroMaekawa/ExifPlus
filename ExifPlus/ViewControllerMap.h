//
//  ViewControllerMap.h
//  test_20140427
//
//  Created by 前川 幸広 on 2014/04/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MapKit/MapKit.h>
#import "ViewTabData.h"
#import "MyAnnotation.h"

@interface ViewControllerMap : UIViewController
{
    ViewTabData * _tempData;
    ALAssetsLibrary *_library;
    ALAsset * _asset;
}
@property (nonatomic) NSURL *url;
@property (nonatomic) NSString * aaa;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end
