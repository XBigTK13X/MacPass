//
//  MPKeePassHttpClient.m
//  MacPass
//
//  Created by Tim Kretschmer on 5/11/14.
//  Copyright (c) 2014 HicknHack Software GmbH. All rights reserved.
//

#import "MPKeePassHttpClient.h"
#import "KPHUtil.h"

@implementation MPKeePassHttpClient
- (id) init
{
    self = [super init];
    if(self){
        self.document = [[NSDocumentController sharedDocumentController] currentDocument];
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

- (void) createOrUpdateEntry:(KPHPwEntry *)entry
{
    [MPKeePassHttpModelAdapter savePwEntry:entry document:self.document];
    [self.document saveDocument:self];
}

- (void) createOrUpdateGroup:(KPHPwGroup *)group
{
    [MPKeePassHttpModelAdapter savePwGroup:group document:self.document];
}

- (KPHPwGroup *)findGroup:(NSString *)name
{
    return nil;
}

- (int) countMatchingEntries:(NSString*) url submitHost:(NSString*)submitHost realm:(NSString*)realm
{
    return 0;
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
    return true;
}
//Return nil if user declines
- (NSString*) promptUserForKeyName: (NSString*)keyMessage
{
    return [NSString stringWithFormat:@"MacPass - %@",[[NSUUID UUID] UUIDString]];
}
- (KPHGetLoginsUserResponse*) promptUserForAccess:(NSString*) message title:(NSString*)title host:(NSString*)host submithost:(NSString*)submithost entries:(NSArray*)entries
{
    KPHGetLoginsUserResponse* response = [KPHGetLoginsUserResponse new];
    response.Accept = true;
    response.Remember = false;
    return response;
}
- (BOOL) promptUserForEntryUpdate:(NSString*)message title:(NSString*)title
{
    return true;
}
- (void) showNotification:(NSString*)message
{
    NSLog(@"KPH Notification - %@",message);
}
- (void) refreshUI
{
    
}
@end
