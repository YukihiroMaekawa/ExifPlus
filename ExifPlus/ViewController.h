//
//  ViewController.h
//  test_20140427
//
//  Created by 前川 幸広 on 2014/04/27.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewTabData.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    PHAssetCollection * _collection;
    ViewTabData * _tempData;
    NSMutableArray *_groupList;
    NSString *_navigationBarTitle;
    
    //写真撮影
    UIImageView *_imageView;
    CLLocationManager* _locationManager;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnCamera:(id)sender;
@end
