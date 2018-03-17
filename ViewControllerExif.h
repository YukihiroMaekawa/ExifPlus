//
//  ViewControllerExif.h
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/04/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewTabData.h"

@interface ViewControllerExif : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    ViewTabData * _tempData;
    ALAssetsLibrary *_library;
    ALAsset * _asset;

    NSMutableArray *_tableKey;
    NSMutableArray *_tableVal;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
