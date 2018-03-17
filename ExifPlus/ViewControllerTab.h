//
//  ViewControllerTab.h
//  test_20140427
//
//  Created by 前川 幸広 on 2014/04/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewTabData.h"

@interface ViewControllerTab : UITabBarController
{
    ViewTabData * _tempData;
}
@property (nonatomic) NSURL *assetURL;
@end
