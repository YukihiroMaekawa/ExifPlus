//
//  ViewControllerTablePhoto2.m
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/05/12.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerTablePhoto2.h"

@interface ViewControllerTablePhoto2 ()

@end

@implementation ViewControllerTablePhoto2

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
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)loadPicture{
    _library = [[ALAssetsLibrary alloc]init];
    _groupList = [[NSMutableArray alloc] init];
    _tableValue = [[NSMutableArray alloc] init];
    _tempData = [ViewTabData sharedManager];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [_tableValue count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(102, 102);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,1,0,1);  // top, left, bottom, right
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor greenColor];
    
    ALAsset *asset = [_tableValue objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = cell.contentView.bounds;
    imageView.image = [UIImage imageWithCGImage: [asset thumbnail]];
    
    [cell.contentView addSubview:imageView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
