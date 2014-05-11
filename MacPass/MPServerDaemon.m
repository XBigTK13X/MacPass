//
//  MPServerDaemon.m
//  MacPass
//
//  Created by Michael Starke on 17.06.13.
//  Copyright (c) 2013 HicknHack Software GmbH. All rights reserved.
//

#import "MPServerDaemon.h"
#import "MPSettingsHelper.h"
#import "HTTPServer.h"
#import "MPIconHelper.h"
#import "MPServerRequestHandling.h"
#import "KPHServer.h"
#import "MPKeePassHttpClient.h"

@interface MPServerDaemon () {
@private
  KPHServer *server;
  NSStatusItem *statusItem;
}

@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) BOOL showStatusItem;

@end

@implementation MPServerDaemon

- (id)init {
  self = [super init];
  if (self) {
    NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
    NSString *enableServerKeyPath = [MPSettingsHelper defaultControllerPathForKey:kMPSettingsKeyEnableHttpServer];
    NSString *showItemKeyPath = [MPSettingsHelper defaultControllerPathForKey:kMPSettingsKeyShowMenuItem];
    [self bind:NSStringFromSelector(@selector(isEnabled)) toObject:defaultsController withKeyPath:enableServerKeyPath options:nil];
    [self bind:NSStringFromSelector(@selector(showStatusItem)) toObject:defaultsController withKeyPath:showItemKeyPath options:nil];
  }
  return self;
}


- (void)setIsEnabled:(BOOL)enabled {
  if(_isEnabled == enabled) {
    return; // NO changes
  }
  _isEnabled = enabled;
  if(enabled) {
    if(!server) {
      [self _setupServer];
    }
    // setup menu item
  }
  else {
    /* Do not let the resource linger around */
    server = nil;
  }
  [self _updateStatusItem];
}


- (void)setShowStatusItem:(BOOL)showStatusItem {
  if(_showStatusItem != showStatusItem) {
    _showStatusItem = showStatusItem;
    [self _updateStatusItem];
  }
}

- (void)_updateStatusItem {
  if(_isEnabled && _showStatusItem) {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setImage:[MPIconHelper icon:MPIconServer ]];
  }
  else if(statusItem) {
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
    statusItem = nil;
  }
}

- (void)_setupServer {
  NSAssert(server == nil, @"Server should be nil");
  server = [KPHServer new];
  [server startWithClient:[MPKeePassHttpClient new]];
}

@end
