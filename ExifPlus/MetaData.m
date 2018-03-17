//
//  MetaData.m
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/05/01.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "MetaData.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import "Utility.h"

@implementation MetaData


- (id)initWithALAsset :(ALAsset *) asset
{
    if (self = [super init])
    {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSDictionary *metadata = [[NSMutableDictionary alloc] init];
        metadata = [representation metadata];
        
        _dictExif = [metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary];
        _dictTiff = [metadata objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
        _dictGps  = [metadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
    }
    return self;
}

- (NSString *) getExifShutter{
    NSString *retValue;

    if(   [_dictExif objectForKey:(NSString *)kCGImagePropertyExifShutterSpeedValue] == nil
       || [_dictExif objectForKey:(NSString *)kCGImagePropertyExifExposureTime] == nil
       ){
        return @"";
    }
    
    retValue = [NSString stringWithFormat:@"%@(%.5f)"
                ,[Utility getExifShutterSpeed :
                  round([[_dictExif objectForKey:(NSString *)kCGImagePropertyExifShutterSpeedValue] doubleValue])]
                ,[[_dictExif objectForKey:(NSString *)kCGImagePropertyExifExposureTime] doubleValue]
               ];
    return retValue;
}

- (NSString *) getExifISOSpeedRatings{
    NSString *retValue;
    NSArray *arrValue = [[NSMutableArray alloc] init];
    arrValue = [_dictExif objectForKey:(NSString *)kCGImagePropertyExifISOSpeedRatings];

    if(arrValue == nil){return @"";}
    retValue = [NSString stringWithFormat:@"%@" ,[arrValue objectAtIndex:0]];
    return retValue;
}

- (NSString *) getExifFNumber{
    NSString *retValue;
    
    retValue = [_dictExif objectForKey:(NSString *)kCGImagePropertyExifFNumber];

    if(retValue == nil){return @"";}
    retValue = [NSString stringWithFormat:@"F%@",retValue];
    
    return retValue;
}

- (NSString *) getExifPixelDimension{
    NSString *retValue;
    
    if ([_dictExif objectForKey:(NSString *)kCGImagePropertyExifPixelXDimension] == nil
     || [_dictExif objectForKey:(NSString *)kCGImagePropertyExifPixelYDimension] == nil
        ) {
        return @"";
    }
    
    retValue = [NSString stringWithFormat:@"%@ × %@"
               ,[_dictExif objectForKey:(NSString *)kCGImagePropertyExifPixelXDimension]
               ,[_dictExif objectForKey:(NSString *)kCGImagePropertyExifPixelYDimension]
                ];
    return retValue;
}

- (NSString *) getExifPixelXDimension{
    NSString *retValue;

    retValue = [_dictExif objectForKey:(NSString *)kCGImagePropertyExifPixelXDimension];
    if(retValue == nil){return @"";}
    return retValue;
}

- (NSString *) getExifPixelYDimension{
    NSString *retValue;
    
    retValue = [_dictExif objectForKey:(NSString *)kCGImagePropertyExifPixelYDimension];
    if(retValue == nil){return @"";}
    return retValue;
}

- (NSString *) getExifDateTimeOriginal{
    NSString *retValue;
    
    retValue = [_dictExif objectForKey:(NSString *)kCGImagePropertyExifDateTimeOriginal];
    if(retValue == nil){return @"";}
    return retValue;
}

- (NSString *) getExifSensingMethod{
    NSString *retValue;
    
    if([_dictExif objectForKey:(NSString *)kCGImagePropertyExifSensingMethod] == nil){
        return @"";
    }
    retValue = [Utility getExifSensingMethod:[[_dictExif objectForKey:(NSString *)kCGImagePropertyExifSensingMethod] intValue]];
    return retValue;
}

- (NSString *) getExifExposureProgram{
    NSString *retValue;
    
    if([_dictExif objectForKey:(NSString *)kCGImagePropertyExifExposureProgram] == nil){
        return @"";
    }
    retValue = [Utility getExifExposureProgram:[[_dictExif objectForKey:(NSString *)kCGImagePropertyExifExposureProgram] intValue]];
    return retValue;
}

- (NSString *) getExifMeteringMode{
    NSString *retValue;
    
    if([_dictExif objectForKey:(NSString *)kCGImagePropertyExifMeteringMode] == nil){
        return @"";
    }
    retValue = [Utility getExifMeteringMode:[[_dictExif objectForKey:(NSString *)kCGImagePropertyExifMeteringMode] intValue]];
    return retValue;
}

- (NSString *) getExifBrightnessValue{
    NSString *retValue;
    
    if([_dictExif objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] == nil){
        return @"";
    }
    retValue = [NSString stringWithFormat:@"%.5f"
                 ,[[_dictExif objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] doubleValue]
                 ];
    return retValue;
}

- (NSString *) getExifFocalLenIn35mmFilm{
    NSString *retValue;
    
    if([_dictExif objectForKey:(NSString *)kCGImagePropertyExifFocalLenIn35mmFilm] == nil){
        return @"";
    }
    retValue = [NSString stringWithFormat:@"%@mm"
                 ,[_dictExif objectForKey:(NSString *)kCGImagePropertyExifFocalLenIn35mmFilm]
                 ];
    return retValue;
}

- (NSString *) getExifFocalLength{
    NSString *retValue;
    
    if([_dictExif objectForKey:(NSString *)kCGImagePropertyExifFocalLength] == nil){
        return @"";
    }
    retValue = [NSString stringWithFormat:@"%@mm"
                 ,[_dictExif objectForKey:(NSString *)kCGImagePropertyExifFocalLength]
                 ];
    return retValue;
}



- (NSString *) getTIFFMake{
    NSString *retValue;
    
    retValue = [_dictTiff objectForKey:(NSString *)kCGImagePropertyTIFFMake];
    if(retValue == nil){return @"";}
    return retValue;
}

- (NSString *) getTIFFModel{
    NSString *retValue;
    
    retValue = [_dictTiff objectForKey:(NSString *)kCGImagePropertyTIFFModel];
    if(retValue == nil){return @"";}
    return retValue;
}

- (NSString *) getTIFFSoftware{
    NSString *retValue;
    
    retValue = [_dictTiff objectForKey:(NSString *)kCGImagePropertyTIFFSoftware];
    if(retValue == nil){return @"";}
    return retValue;
}

- (NSString *) getGPSLatitudeValue{
    NSString *retValue;

    if(   [_dictGps objectForKey:(NSString *)kCGImagePropertyGPSLatitudeRef] == nil
       || [_dictGps objectForKey:(NSString *)kCGImagePropertyGPSLatitude] == nil
       ){
        return @"";
    }
    
    retValue = [NSString stringWithFormat:@"%@ %.6f"
              ,[_dictGps objectForKey:(NSString *)kCGImagePropertyGPSLatitudeRef]
              ,[[_dictGps objectForKey:(NSString *)kCGImagePropertyGPSLatitude] doubleValue]
                ];
    
    return retValue;
}

- (NSString *) getGPSLongitudeValue{
    NSString *retValue;
    
    if(   [_dictGps objectForKey:(NSString *)kCGImagePropertyGPSLongitudeRef] == nil
       || [_dictGps objectForKey:(NSString *)kCGImagePropertyGPSLongitude] == nil
       ){
        return @"";
    }
    
    retValue = [NSString stringWithFormat:@"%@ %.6f"
                ,[_dictGps objectForKey:(NSString *)kCGImagePropertyGPSLongitudeRef]
                ,[[_dictGps objectForKey:(NSString *)kCGImagePropertyGPSLongitude] doubleValue]
                ];
    
    return retValue;
}

@end
