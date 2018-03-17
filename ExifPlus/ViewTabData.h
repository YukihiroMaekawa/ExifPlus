//
//  ViewTabData.h
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/04/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface ViewTabData : NSObject{}
+ (ViewTabData *)sharedManager;

//@property (nonatomic) ALAssetsGroup *group;
@property (nonatomic) PHAssetCollection *collection;

@property (nonatomic) NSURL *assetURL;
@end
