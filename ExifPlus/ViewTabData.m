//
//  ViewTabData.m
//  ExifPlus
//
//  Created by 前川 幸広 on 2014/04/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewTabData.h"

static ViewTabData* sharedParth = nil;

@implementation ViewTabData

+ (ViewTabData *)sharedManager{
    if (!sharedParth) {
        sharedParth = [ViewTabData new];
    }
    return sharedParth;
}

- (id)init
{
    self = [super init];
    if (self) {
        //Initialization
    }
    return self;
}

@end