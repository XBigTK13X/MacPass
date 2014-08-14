//
//  MPKeePassHttpModelAdapter.h
//  MacPass
//
//  Created by Tim Kretschmer on 5/24/14.
//  Copyright (c) 2014 HicknHack Software GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPKGroup.h"
#import "KPHPwGroup.h"
#import "KPKEntry.h"
#import "KPHPwEntry.h"
#import "MPDocument.h"
#import "KPHKeePassClient.h"
#import "KPHUtil.h"

@interface MPKeePassHttpModelAdapter : NSObject
+ (void) savePwEntry:(KPHPwEntry*)pwEntry document:(MPDocument *)document;
+ (void) savePwGroup:(KPHPwGroup*)pwGroup document:(MPDocument *)document;
+ (KPHPwEntry*) entryToPwEntry:(KPKEntry*)entry;
+ (KPHPwGroup*) groupToPwGroup:(KPKGroup*)group;
@end
