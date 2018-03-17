//
//  ViewControllerMap.m
//  test_20140427
//
//  Created by 前川 幸広 on 2014/04/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerMap.h"
#import <ImageIO/ImageIO.h>
#import "MetaData.h"

@interface ViewControllerMap ()

@end

@implementation ViewControllerMap

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

    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor blackColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius = 5.0;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 0.8;
    sublayer.opacity = 0.55f;
    sublayer.masksToBounds = YES;
    sublayer.cornerRadius = 20.0f;
    sublayer.frame = CGRectMake(2, 67, 316, 100);
    [self.view.layer addSublayer:sublayer];
    
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
            // ALAssetから位置情報を取得
            CLLocation *location = [_asset valueForProperty:ALAssetPropertyLocation];
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
            {
                CLPlacemark *place = [placemarks lastObject];
                // 情報表示
                NSString *postalCode         = place.postalCode;
                NSString *administrativeArea = place.administrativeArea;
                NSString *locality           = place.locality;
                NSString *thoroughfare       = place.thoroughfare;
                NSString *subThoroughfare    = place.subThoroughfare;
                
                if(postalCode         == nil){postalCode         = @"";}
                if(administrativeArea == nil){administrativeArea = @"";}
                if(locality           == nil){locality           = @"";}
                if(thoroughfare       == nil){thoroughfare       = @"";}
                if(subThoroughfare    == nil){subThoroughfare    = @"";}
                
                NSString * addressData = [NSString stringWithFormat:@"%@\n%@%@\n%@%@"
                                           ,postalCode
                                           ,administrativeArea
                                           ,locality
                                           ,thoroughfare
                                           ,subThoroughfare
                                           ];
                
                ALAssetRepresentation *representation = [_asset defaultRepresentation];
                NSDictionary *metadata = [[NSMutableDictionary alloc] init];
                metadata = [representation metadata];
                MetaData *myMetaData = [[MetaData alloc]initWithALAsset:asset];
                NSDictionary *dictGps  = [metadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
                
                CATextLayer *text = [CATextLayer layer];
                text.ContentsScale = [[UIScreen mainScreen] scale];
                 
                NSString *dataValue;
                dataValue = [NSString stringWithFormat:@"%@\n%@\n%@\n%@"
                            ,[myMetaData getExifDateTimeOriginal]
                            ,[myMetaData getGPSLatitudeValue]
                            ,[myMetaData getGPSLongitudeValue]
                            ,addressData
                            ];
                 text.string = dataValue;
                 text.frame = CGRectMake(110, 5, 320, 85);
                 CGFontRef font = CGFontCreateWithFontName((CFStringRef)@"HiraKakuProN-W3");
                 text.font = font;
                 text.fontSize = 9.5;
                 text.foregroundColor = [UIColor whiteColor].CGColor;
                 [text display];
                 [sublayer addSublayer:text];
                 
                 UIImageView *imageView = [[UIImageView alloc] initWithImage:
                                           [UIImage imageWithCGImage:[representation fullScreenImage]]];
                 imageView.frame = CGRectMake(10, 70, 95, 95
                                              );
                 imageView.backgroundColor = [UIColor redColor];
                 imageView.contentMode= UIViewContentModeScaleAspectFill;
                 [imageView.layer setBorderWidth:1.0f]; //角丸枠の太さ
                 [imageView.layer setBorderColor:[[UIColor whiteColor] CGColor]]; //角丸枠の色
                 imageView.layer.cornerRadius = 10.0f; //角丸の範囲＝数が大きいほど丸く
                 imageView.clipsToBounds = true; //角丸に画像を切り抜く
                 [self.view addSubview:imageView];
                
                //マップの設定
                CLLocationCoordinate2D appleStoreGinzaCoord;
                appleStoreGinzaCoord.latitude  = [[dictGps objectForKey:@"Latitude"] doubleValue];  // 経度
                appleStoreGinzaCoord.longitude = [[dictGps objectForKey:@"Longitude"] doubleValue]; // 緯度
                [self.mapView setCenterCoordinate:appleStoreGinzaCoord animated:NO];
                
                // 縮尺
                MKCoordinateRegion mapScale = self.mapView.region;
                mapScale.center = appleStoreGinzaCoord;
                mapScale.span.latitudeDelta = mapScale.span.longitudeDelta = 0.003;
                [self.mapView setRegion:mapScale animated:NO];
                
                // annotation の追加
                NSArray *annotations = @[
                                         [[MyAnnotation alloc] initWithLocationCoordinate:appleStoreGinzaCoord
                                                                                    title:@""
                                                                                 subtitle:@""]
                                         ];
                [self.mapView addAnnotations:annotations];
            }];
        }
    } failureBlock: nil];
    
}

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id)annotation{
    
    static NSString *PinIdentifier = @"Pin";
    MKPinAnnotationView *pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
    if (pin == nil){
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinIdentifier];
        pin.animatesDrop = YES;  // アニメーションをする
        pin.pinColor = MKPinAnnotationColorPurple;  // ピンの色を紫にする
        pin.canShowCallout = YES;  // ピンをタップするとコールアウトを表示
    }
    return pin;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.title = @"Map";
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
