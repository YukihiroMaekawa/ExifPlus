//
//  ViewControllerTablePhoto.m
//  test_20140427
//
//  Created by 前川 幸広 on 2014/04/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerTablePhoto.h"
#import "ViewControllerTab.h"
#import <ImageIO/ImageIO.h>
#import "Utility.h"
#import "MetaData.h"

@interface ViewControllerTablePhoto ()

@end

@implementation ViewControllerTablePhoto

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
    
    // メインスレッド用で処理を実行するキューを定義するする
    _main_queue = dispatch_get_main_queue();
    // サブスレッドで実行するキューを定義する
    _sub_queue = dispatch_queue_create("tableLoad", 0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)loadPicture{
    _groupList = [[NSMutableArray alloc] init];
    _tableValue = [[NSMutableArray alloc] init];
    _tempData = [ViewTabData sharedManager];
    PHAssetCollection *assetGroup = _tempData.collection;
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
    //return [_groupList count];
    return [_tableValue count];
}

/* テーブル高さ*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    
    // サブキュー実行
    dispatch_async(_sub_queue, ^{
        
        [cell.imageView.layer setBorderWidth:1.0f]; //角丸枠の太さ
        [cell.imageView.layer setBorderColor:[[UIColor whiteColor] CGColor]]; //角丸枠の色
        cell.imageView.layer.cornerRadius = 10.0f; //角丸の範囲＝数が大きいほど丸く
        cell.imageView.clipsToBounds = true; //角丸に画像を切り抜く
  
        // メインキュー実行
        dispatch_async(_main_queue, ^ {
            NSArray * dataValue = [self getMetaData :(int)indexPath.row];
            
            UIFont *uiFont = [UIFont systemFontOfSize:12];
            ALAsset *asset = [_tableValue objectAtIndex:indexPath.row];
            
            cell.imageView.image = [UIImage imageWithCGImage: [asset thumbnail]];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;

            UILabel     *labelCell1;
            labelCell1 = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 165, 15)];
            labelCell1.textAlignment = NSTextAlignmentLeft;
            labelCell1.backgroundColor = [UIColor clearColor];
            labelCell1.textColor = [UIColor blueColor];
            [labelCell1 setFont:uiFont];
            labelCell1.text = [dataValue objectAtIndex:0];
            [cell.contentView addSubview:labelCell1];

            UILabel     *labelCell2;
            labelCell2 = [[UILabel alloc] initWithFrame:CGRectMake(130, 15, 165, 80)];
            labelCell2.textAlignment = NSTextAlignmentLeft;
            labelCell2.backgroundColor = [UIColor clearColor];
            labelCell2.textColor = [UIColor blackColor];
            [labelCell2 setFont:uiFont];
            labelCell2.text = [dataValue objectAtIndex:1];
            labelCell2.numberOfLines = 0;
            [cell.contentView addSubview:labelCell2];
        });
    });
    return cell;
}

- (NSArray *) getMetaData :(int)index{
    //ALAsset *asset = [_groupList objectAtIndex:(int)index];
    ALAsset *asset = [_tableValue objectAtIndex:(int)index];
    MetaData *myMetaData = [[MetaData alloc]initWithALAsset:asset];
    
    NSString *valueData = [NSString stringWithFormat:@"%@\n%@\n%@\n%@   %@\n%@"
                           ,[myMetaData getTIFFMake]
                           ,[myMetaData getTIFFModel]
                           ,[myMetaData getExifShutter]
                           ,[myMetaData getExifFNumber]
                           ,[myMetaData getExifISOSpeedRatings]
                           ,[myMetaData getExifPixelDimension]
                           ];
    
    NSArray *retArray = [[NSArray alloc]initWithObjects:
                         [myMetaData getExifDateTimeOriginal]
                         ,valueData, nil];
    
    return retArray;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [_tableValue objectAtIndex:indexPath.row];
    _assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    
    [self performSegueWithIdentifier:@"photoSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"photoSegue"]) {
/*
    TabViewに送っても 子のイベントが先に発生するため送った値が取得できない
        ViewControllerTab * viewNext = [[ViewControllerTab alloc] init];
        viewNext = segue.destinationViewController;
        viewNext.assetURL = _assetURL;
*/
        _tempData = [ViewTabData sharedManager];
        _tempData.assetURL = _assetURL;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //  通知受信の設定
    NSNotificationCenter*   nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    [nc addObserver:self selector:@selector(applicationWillEnterForeground) name:@"applicationWillEnterForeground" object:nil];
    
    [self loadPicture];

    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
    // ハイライト解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //通知を終了
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//アプリが非アクティブになりバックグラウンド実行になった際に呼び出される
- (void)applicationDidEnterBackground
{
}

- (void)applicationWillEnterForeground
{
    [self loadPicture];
}


@end
