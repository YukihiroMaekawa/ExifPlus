//
//  Utility.h
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/05/01.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
+ (NSString *) getExifSensingMethod :(int) value;
+ (NSString *) getExifExposureProgram :(int) value;
+ (NSString *) getExifShutterSpeed :(int) value;
+ (NSString *) getExifMeteringMode :(int) value;
@end
