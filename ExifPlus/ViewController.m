//
//  ViewController.m
//  test_20140427
//
//  Created by 前川 幸広 on 2014/04/27.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerTablePhoto.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [CLLocationManager new];
    _imageView = [[UIImageView alloc] init];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)loadAlbum{
    _groupList = [[NSMutableArray alloc] init];

    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                     subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                     options:nil];

    [result enumerateObjectsUsingBlock:^(PHAssetCollection *album, NSUInteger idx, BOOL *stop) {
        [_groupList addObject:album];
    }];
    
    PHFetchResult *result2 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                     subtype:PHAssetCollectionSubtypeAlbumCloudShared
                                                                     options:nil];
    
    [result2 enumerateObjectsUsingBlock:^(PHAssetCollection *album, NSUInteger idx, BOOL *stop) {
        [_groupList addObject:album];
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// テーブルデータ作成
/**
 * テーブルのセルの数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_groupList count];
}

/* テーブル高さ*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    
    PHAssetCollection *collection = [_groupList objectAtIndex:indexPath.row];
    NSString *albumName = collection.localizedTitle;
    
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    
    
    __block UIImage *image = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同期処理にする場合にはYES (デフォルトはNO)
    options.synchronous = YES;
    //options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

    [[PHImageManager defaultManager] requestImageForAsset:result.lastObject
                                               targetSize:CGSizeMake(130,130)
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                image = result;
                                            }
     ];
    
    //カンマフォーマット
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];

    
    //NSNumberに変換
    //NSNumber *alubumPhotCnt2 = [[NSNumber alloc] initWithInteger:albumPhotoCnt];

    NSString *valueData = [NSString stringWithFormat:@"%@"
                           ,albumName
                           ];
    
    /*
    NSString *valueData = [NSString stringWithFormat:@"%@\n%@"
                           ,albumName
                           ,[formatter stringFromNumber:alubumPhotCnt2]
                           ];
    */
    UIFont *uiFont = [UIFont systemFontOfSize:14];
    cell.textLabel.font = uiFont;
    
    [cell.imageView setFrame:CGRectMake(10,0,40,40)];
    cell.imageView.frame = CGRectMake(10,0,40,40);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;//ScaleAspectFit
    cell.imageView.image = image;

    [cell.imageView.layer setBorderWidth:1.0f]; //角丸枠の太さ
    [cell.imageView.layer setBorderColor:[[UIColor whiteColor] CGColor]]; //角丸枠の色
    cell.imageView.layer.cornerRadius = 10.0f; //角丸の範囲＝数が大きいほど丸く
    cell.imageView.clipsToBounds = true; //角丸に画像を切り抜く

    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = valueData;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _collection = [_groupList objectAtIndex:indexPath.row];
    _navigationBarTitle = @"album name";
    [self performSegueWithIdentifier:@"tablePhotoSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tablePhotoSegue"]) {
        
        _tempData = [ViewTabData sharedManager];
        _tempData.collection = _collection;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_locationManager startUpdatingLocation];

    [self loadAlbum];

    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
    // ハイライト解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_locationManager stopUpdatingLocation];
    
    [super viewWillDisappear:animated];
}

- (IBAction)btnCamera:(id)sender {
    if([UIImagePickerController
        isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

// select image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 位置情報
    CLLocation* location = _locationManager.location;
    NSMutableDictionary* gpsDict = [NSMutableDictionary new];
    
    // GPS日付（UTC）
    NSDateFormatter* dfGPSDate = [NSDateFormatter new];
    dfGPSDate.dateFormat = @"yyyy:MM:dd";
    dfGPSDate.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];;
    gpsDict[(NSString *)kCGImagePropertyGPSDateStamp] = [dfGPSDate stringFromDate:location.timestamp];
    
    // GPS時刻（UTC）
    NSDateFormatter* dfGPSTime = [NSDateFormatter new];
    dfGPSTime.dateFormat = @"HH:mm:ss.SSSSSS";
    dfGPSTime.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    gpsDict[(NSString *)kCGImagePropertyGPSTimeStamp] = [dfGPSTime stringFromDate:location.timestamp];
    
    // 緯度
    CGFloat latitude = location.coordinate.latitude;
    NSString *gpsLatitudeRef;
    if (latitude < 0) {
        latitude = -latitude;
        gpsLatitudeRef = @"S";
    } else {
        gpsLatitudeRef = @"N";
    }
    gpsDict[(NSString *)kCGImagePropertyGPSLatitudeRef] = gpsLatitudeRef;
    gpsDict[(NSString *)kCGImagePropertyGPSLatitude] = @(latitude);
    
    // 経度
    CGFloat longitude = location.coordinate.longitude;
    NSString *gpsLongitudeRef;
    if (longitude < 0) {
        longitude = -longitude;
        gpsLongitudeRef = @"W";
    } else {
        gpsLongitudeRef = @"E";
    }
    gpsDict[(NSString *)kCGImagePropertyGPSLongitudeRef] = gpsLongitudeRef;
    gpsDict[(NSString *)kCGImagePropertyGPSLongitude] = @(longitude);
    
    // 標高
    CGFloat altitude = location.altitude;
    if (!isnan(altitude)){
        NSString *gpsAltitudeRef;
        if (altitude < 0) {
            altitude = -altitude;
            gpsAltitudeRef = @"1";
        } else {
            gpsAltitudeRef = @"0";
        }
        gpsDict[(NSString *)kCGImagePropertyGPSAltitudeRef] = gpsAltitudeRef;
        gpsDict[(NSString *)kCGImagePropertyGPSAltitude] = @(altitude);
    }
    
    // Exif情報 にGPS情報を追加
    NSMutableDictionary* exifDict = info[UIImagePickerControllerMediaMetadata];
    exifDict[(NSString *)kCGImagePropertyGPSDictionary] = (NSDictionary*)gpsDict;
    
    // GPS情報を追加したExif情報と共に画像をカメラロールに保存
    ALAssetsLibrary* assetLibrary = [ALAssetsLibrary new];
    [assetLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:exifDict completionBlock:^(NSURL *assetURL, NSError *error) {
        if ( error ) {
            NSLog(@"Save image failed. \n%@", error);
        }
        
        //サムネイルを更新
        [self loadAlbum];

    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

