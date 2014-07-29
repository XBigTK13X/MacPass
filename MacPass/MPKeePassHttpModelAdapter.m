//
//  MPKeePassHttpModelAdapter.m
//  MacPass
//
//  Created by Tim Kretschmer on 5/24/14.
//  Copyright (c) 2014 HicknHack Software GmbH. All rights reserved.
//

#import "MPKeePassHttpModelAdapter.h"

@implementation MPKeePassHttpModelAdapter
+ (KPKEntry*) pwEntryToEntry:(KPHPwEntry*)pwEntry
{
    return nil;
}
+ (KPKGroup*) pwGroupToGroup:(KPHPwGroup*)pwGroup
{
    return nil;
}
+ (KPHPwEntry*) entryToPwEntry:(KPKEntry*)entry
{
    return nil;
}
+ (KPHPwGroup*) groupToPwGroup:(KPKGroup*)group
{
    KPHPwGroup* result = [KPHPwGroup new];
    
    return nil;
}
@end
