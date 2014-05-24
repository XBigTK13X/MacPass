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

@interface MPKeePassHttpModelAdapter : NSObject
+ (KPKEntry*) pwEntryToEntry:(KPHPwEntry*)pwEntry;
+ (KPKGroup*) pwGroupToGroup:(KPHPwGroup*)pwGroup;
+ (KPHPwEntry*) entryToPwEntry:(KPKEntry*)entry;
+ (KPHPwGroup*) groupToPwGroup:(KPKGroup*)group;
@end
