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
    KPHPwEntry* result = [KPHPwEntry new];
    result.Strings[@"UserName"] = entry.username;
    result.Strings[@"Password"] = entry.password;
    result.Strings[@"URL"] = entry.url;
    result.Strings[@"Title"] = entry.title;
    return result;
}
+ (KPHPwGroup*) groupToPwGroup:(KPKGroup*)group
{
    KPHPwGroup* result = [KPHPwGroup new];
    for(KPKEntry* childEntry in group.entries)
    {
        [result addEntry:[MPKeePassHttpModelAdapter entryToPwEntry:childEntry] takeOwnership:FALSE];
    }
    for(KPKGroup* childGroup in group.groups){
        [result.Children addObject:[MPKeePassHttpModelAdapter groupToPwGroup:childGroup]];
    }
    return result;
}
@end
