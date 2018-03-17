//
//  ViewControllerExif.m
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/04/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerExif.h"
#import <ImageIO/ImageIO.h>
#import "Utility.h"
#import "MetaData.h"

@interface ViewControllerExif ()

@end

@implementation ViewControllerExif

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

    self.tableView.delegate   = self;
    self.tableView.dataSource = self;

    [self tableView];
    
    [self createTableData];
}

// テーブルデータ作成
- (void) createTableData{
    _tableKey      = [[NSMutableArray alloc] init];
    _tableVal      = [[NSMutableArray alloc] init];
    
    _tempData = [ViewTabData sharedManager];
    //URLからALAssetを取得
    _library = [[ALAssetsLibrary alloc]init];
    _asset = [[ALAsset alloc] init];
    
    [_library assetForURL:_tempData.assetURL resultBlock:^(ALAsset *asset)
     {
         _asset = asset;
         //画像があればYES、無ければNOを返す
         if(_asset)
         {
             
             MetaData *myMetaData = [[MetaData alloc]initWithALAsset:_asset];

             /*
             [_tableKey addObject:@"ファイル名"];
             [_tableVal addObject:@"xxx.jpg"];
             
             [_tableKey addObject:@"画像種類"];
             [_tableVal addObject:@"xxx.jpg"];
             */
             [_tableKey addObject:@"撮影日時"];
             [_tableVal addObject:[myMetaData getExifDateTimeOriginal]];
             
             [_tableKey addObject:@"経度"];
             [_tableVal addObject:[myMetaData getGPSLatitudeValue]];

             [_tableKey addObject:@"緯度"];
             [_tableVal addObject:[myMetaData getGPSLongitudeValue]];
             
             [_tableKey addObject:@"サイズ"];
             [_tableVal addObject:[myMetaData getExifPixelDimension]];
             
             [_tableKey addObject:@"メーカー"];
             [_tableVal addObject:[myMetaData getTIFFMake]];
             
             [_tableKey addObject:@"モデル"];
             [_tableVal addObject:[myMetaData getTIFFModel]];

             [_tableKey addObject:@"ソフトウェア"];
             [_tableVal addObject:[myMetaData getTIFFSoftware]];

             [_tableKey addObject:@"画像センサー"];
             [_tableVal addObject:[myMetaData getExifSensingMethod]];

             [_tableKey addObject:@"露出プログラム"];
             [_tableVal addObject:[myMetaData getExifExposureProgram]];

             [_tableKey addObject:@"シャッタースピード"];
             [_tableVal addObject:[myMetaData getExifISOSpeedRatings]];

             [_tableKey addObject:@"F値"];
             [_tableVal addObject:[myMetaData getExifFNumber]];

             [_tableKey addObject:@"ISO感度"];
             [_tableVal addObject:[myMetaData getExifISOSpeedRatings]];

             [_tableKey addObject:@"測光方式"];
             [_tableVal addObject:[myMetaData getExifMeteringMode]];
             
             [_tableKey addObject:@"輝度"];
             [_tableVal addObject:[myMetaData getExifBrightnessValue]];

             [_tableKey addObject:@"換算焦点距離"];
             [_tableVal addObject:[myMetaData getExifFocalLenIn35mmFilm]];

             [_tableKey addObject:@"焦点距離"];
             [_tableVal addObject:[myMetaData getExifFocalLength]];

             [self.tableView reloadData];
         }
     } failureBlock: nil];
}

// テーブルデータ作成
/**
 * テーブルのセルの数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableKey count];
}

/* テーブル高さ*/
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
*/
/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel     *labelCell1;
    UILabel     *labelCell2;

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
    UIFont *uiFont = [UIFont systemFontOfSize:12.0];
    labelCell1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 110, 45)];
    labelCell1.textAlignment = NSTextAlignmentLeft;
    labelCell1.backgroundColor = [UIColor clearColor];
    labelCell1.textColor = [UIColor blackColor];
    [labelCell1 setFont:uiFont];
    labelCell1.text = [_tableKey objectAtIndex:indexPath.row];
    [cell.contentView addSubview:labelCell1];

    labelCell2 = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 180, 45)];
    labelCell2.textAlignment = NSTextAlignmentLeft;
    labelCell2.backgroundColor = [UIColor clearColor];
    labelCell2.textColor = [UIColor blackColor];
    [labelCell2 setFont:uiFont];
    labelCell2.text = [_tableVal objectAtIndex:indexPath.row];
    [cell.contentView addSubview:labelCell2];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.title = @"Exif";
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
