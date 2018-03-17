//
//  MetaData.h
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/05/01.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MetaData : NSObject

{
    NSDictionary *_dictExif;
    NSDictionary *_dictTiff;
    NSDictionary *_dictGps;
}

- (id)initWithALAsset :(ALAsset *) asset;

- (NSString *) getExifShutter;
- (NSString *) getExifISOSpeedRatings;
- (NSString *) getExifFNumber;
- (NSString *) getExifPixelDimension;
- (NSString *) getExifPixelXDimension;
- (NSString *) getExifPixelYDimension;
- (NSString *) getExifDateTimeOriginal;
- (NSString *) getExifSensingMethod;
- (NSString *) getExifMeteringMode;
- (NSString *) getExifExposureProgram;
- (NSString *) getExifBrightnessValue;
- (NSString *) getExifFocalLenIn35mmFilm;
- (NSString *) getExifFocalLength;

- (NSString *) getTIFFMake;
- (NSString *) getTIFFModel;
- (NSString *) getTIFFSoftware;

- (NSString *) getGPSLatitudeValue;
- (NSString *) getGPSLongitudeValue;
@end
