//
//  MPKeePassHttpClient.h
//  MacPass
//
//  Created by Tim Kretschmer on 5/11/14.
//  Copyright (c) 2014 HicknHack Software GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPHKeePassClient.h"
#import "MPKeePassHttpModelAdapter.h"
#import "MPSettingsHelper.h"
#import "MPDocument.h"

@interface MPKeePassHttpClient : NSObject<KPHKeePassClient>

@property (nonatomic) MPDocument* document;

@end
