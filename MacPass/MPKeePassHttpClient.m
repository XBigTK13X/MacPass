//
//  MPKeePassHttpClient.m
//  MacPass
//
//  Created by Tim Kretschmer on 5/11/14.
//  Copyright (c) 2014 HicknHack Software GmbH. All rights reserved.
//

#import "MPKeePassHttpClient.h"

@implementation MPKeePassHttpClient
- (id) init
{
    self = [super init];
    if(self){
        self.document = [MPDocument new];
    }
    return self;
}

- (void) setConfigOptions:(KPHConfigOpt*)configOpt
{
    configOpt.ListenerPort = [[NSUserDefaults standardUserDefaults] integerForKey:kMPSettingsKeyHttpPort];
}

- (KPHPwGroup *) rootGroup
{    
    return [MPKeePassHttpModelAdapter groupToPwGroup:self.document.root];
}
- (KPHPwGroup *) recycleGroup
{
    return [MPKeePassHttpModelAdapter groupToPwGroup:self.document.trash];
}
- (void) saveEntry:(KPHPwEntry*)entry
{
    KPKEntry* kpkEntry = [MPKeePassHttpModelAdapter pwEntryToEntry:entry];
    //TODO Persist changes
}

- (int) countMatchingEntries:(NSString*) url submitHost:(NSString*)submitHost realm:(NSString*)realm
{
    self.document.root
    return [self.document ];
}
//Array of KPHPwEntry
- (NSMutableArray*) findMatchingEntries:(NSString*) host submithost:(NSString*)submithost
{
    return nil;
}
- (KPHPwEntry*) findEntryInAnyDatabase:(NSUUID*)uuid searchRecursive:(BOOL)searchRecursive
{
    return nil;
}
- (KPHGeneratedPassword*) generatePassword
{
    return nil;
}
- (NSArray*) getAllLogins
{
    return nil;
}

- (BOOL) promptUserForOverwrite: (NSString*)message title:(NSString*)title
{
    return false;
}
//Return nil if user declines
- (NSString*) promptUserForKeyName: (NSString*)keyMessage
{
    return nil;
}
- (KPHGetLoginsUserResponse*) promptUserForAccess:(NSString*) message title:(NSString*)title host:(NSString*)host submithost:(NSString*)submithost entries:(NSArray*)entries
{
    return nil;
}
- (BOOL) promptUserForEntryUpdate:(NSString*)message title:(NSString*)title
{
    return false;
}
- (void) showNotification:(NSString*)message
{
    
}
- (void) updateUI
{
    
}
@end
