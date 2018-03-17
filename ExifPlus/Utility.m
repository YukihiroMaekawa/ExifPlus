//
//  Utility.m
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/05/01.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "Utility.h"

@implementation Utility

//画像センサー(SensingMethod)
+ (NSString *) getExifSensingMethod :(int) value{
    NSString * retValue;

    switch (value) {
        case 1:
            retValue = @"未定義";
            break;
        case 2:
            retValue = @"単版カラーセンサー";
            break;
        case 3:
            retValue = @"2板カラーセンサー";
            break;
        case 4:
            retValue = @"3板カラーセンサー";
            break;
        case 5:
            retValue = @"色順次カラーセンサー";
            break;
        case 7:
            retValue = @"3線リニアセンサー";
            break;
        case 8:
            retValue = @"色順次リニアセンサー";
            break;
        default:
            retValue = @"";
            break;
    }

    return retValue;
}

//露出プログラム
+ (NSString *) getExifExposureProgram :(int) value{
    NSString * retValue;

    switch (value) {
        case 0:
            retValue = @"未定義";
            break;
        case 1:
            retValue = @"マニュアル";
            break;
        case 2:
            retValue = @"ノーマルプログラム";
            break;
        case 3:
            retValue = @"露出優先";
            break;
        case 4:
            retValue = @"シャッター優先";
            break;
        case 5:
            retValue = @"creativeプログラム";
            break;
        case 6:
            retValue = @"actionプログラム";
            break;
        case 7:
            retValue = @"ポートレイトモード";
            break;
        case 8:
            retValue = @"ランドスケープモード";
            break;
        default:
            retValue = @"その他";
            break;
    }

    return  retValue;
}

//シャッタースピード
+ (NSString *) getExifShutterSpeed :(int) value{
    NSString * retValue;
    
    switch (value) {
        case -5:
            retValue = @"30";
            break;
        case -4:
            retValue = @"15";
            break;
        case -3:
            retValue = @"8";
            break;
        case -2:
            retValue = @"4";
            break;
        case -1:
            retValue = @"2";
            break;
        case 0:
            retValue = @"1";
            break;
        case 1:
            retValue = @"1/2";
            break;
        case 2:
            retValue = @"1/4";
            break;
        case 3:
            retValue = @"1/8";
            break;
        case 4:
            retValue = @"1/15";
            break;
        case 5:
            retValue = @"1/30";
            break;
        case 6:
            retValue = @"1/60";
            break;
        case 7:
            retValue = @"1/125";
            break;
        case 8:
            retValue = @"1/250";
            break;
        case 9:
            retValue = @"1/500";
            break;
        case 10:
            retValue = @"1/1000";
            break;
        case 11:
            retValue = @"1/2000";
            break;
        default:
            retValue = @"";
            break;
    }
    
    retValue = [NSString stringWithFormat:@"%@秒",retValue];
    return retValue;
}

//測光方式 (MeteringMode)
+ (NSString *) getExifMeteringMode :(int) value{
    NSString * retValue;
    
    switch (value) {
        case 0:
            retValue = @"不明";
            break;
        case 1:
            retValue = @"平均";
            break;
        case 2:
            retValue = @"中央重点";
            break;
        case 3:
            retValue = @"スポット";
            break;
        case 4:
            retValue = @"マルチスポット";
            break;
        case 5:
            retValue = @"分割測光";
            break;
        case 6:
            retValue = @"部分測光";
            break;
        default:
            retValue = @"その他";
            break;
    }
    
    return retValue;
}

@end
