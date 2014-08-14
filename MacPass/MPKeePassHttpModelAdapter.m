//
//  MPKeePassHttpModelAdapter.m
//  MacPass
//
//  Created by Tim Kretschmer on 5/24/14.
//  Copyright (c) 2014 HicknHack Software GmbH. All rights reserved.
//

#import "MPKeePassHttpModelAdapter.h"

@implementation MPKeePassHttpModelAdapter
+ (void) savePwEntry:(KPHPwEntry*)pwEntry document:(MPDocument *)document
{
    KPKEntry* original = [document findEntry:pwEntry.Uuid];
    if(original == nil){
        original = [KPKEntry new];
    }
    
    original.username = pwEntry.Strings[[KPHUtil globalVars].PwDefs.UserNameField];
    original.password = pwEntry.Strings[[KPHUtil globalVars].PwDefs.PasswordField];
    original.url = pwEntry.Strings[[KPHUtil globalVars].PwDefs.UrlField];
    original.title = pwEntry.Strings[[KPHUtil globalVars].PwDefs.TitleField];
    
    //TODO Does this actually save the entry?
    [document saveDocument:original];
}
+ (void) savePwGroup:(KPHPwGroup*)pwGroup document:(MPDocument *)document
{
    KPKGroup* original = [document findGroup:pwGroup.Uuid];
    if(original == nil){
        original = [KPKGroup new];
    }
    
    //TODO Convert KPHGroup to KPKGroup
    
    //TODO Does this actually save the entry?
    [document saveDocument:original];
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
