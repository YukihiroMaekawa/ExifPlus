//
//  ViewControllerTablePhoto.h
//  test_20140427
//
//  Created by 前川 幸広 on 2014/04/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewTabData.h"

@interface ViewControllerTablePhoto : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    ViewTabData * _tempData;
    ALAssetsLibrary *_library;
    NSMutableArray *_groupList;
    NSMutableArray *_tableValue;
    NSURL *_assetURL;
    
    dispatch_queue_t _main_queue;
    dispatch_queue_t _sub_queue;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSString *navigationBarTitle;
@property (nonatomic) ALAssetsGroup *group;
@end
