//
//  MPFixAutotypeWindowController.m
//  MacPass
//
//  Created by Michael Starke on 26/03/14.
//  Copyright (c) 2014 HicknHack Software GmbH. All rights reserved.
//

#import "MPFixAutotypeWindowController.h"
#import "MPDocument.h"
#import "KPKNode.h"
#import "KPKEntry.h"
#import "KPKGroup.h"
#import "KPKAutotype.h"
#import "KPKWindowAssociation.h"

#import "MPIconHelper.h"

NSString *const kMPAutotypeCell = @"AutotypeCell";
NSString *const kMPTitleCell = @"TitleCell";
NSString *const kMPIsDefaultCell = @"IsDefaultCell";
NSString *const kMPIconCell = @"IconCell";

/* Helper Categries */

@implementation KPKGroup (MPFixAutotypeWindowControllerBreadCrumb)

- (NSString *)breadcrumb {
  if(self.parent) {
    return [[self.parent breadcrumb] stringByAppendingFormat:@" > %@", self.name];
  }
  return self.name;
}

@end

@implementation KPKWindowAssociation (MPFixAutotypeWindowControllerQualifedName)

- (NSString *)qualifedName {
  return [[NSString alloc] initWithFormat:@"%@ (%@)", self.windowTitle, self.autotype.entry.title ];
}

@end

@interface MPFixAutotypeWindowController () {
  NSMutableArray *_elements;
  BOOL _didRegisterForUndoRedo;
}
@end


@implementation MPFixAutotypeWindowController

- (NSString *)windowNibName {
  return @"FixAutotypeWindow";
}

- (void)windowDidLoad {
  [super windowDidLoad];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self.window orderOut:self];
}


#pragma mark -
#pragma mark Properties

- (void)setWorkingDocument:(MPDocument *)workingDocument {
  if(_workingDocument != workingDocument) {
    _workingDocument = workingDocument;
  }
  if(!_didRegisterForUndoRedo) {
    NSUndoManager *manager = [_workingDocument undoManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didChangeDocument:) name:NSUndoManagerDidRedoChangeNotification object:manager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didChangeDocument:) name:NSUndoManagerDidUndoChangeNotification object:manager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didChangeDocument:) name:NSUndoManagerDidCloseUndoGroupNotification object:manager];
  }
  _elements = nil;
  [self.tableView reloadData];
}

#pragma mark -
#pragma mark Actions

- (void)clearAutotype:(id)sender {
  [[self.workingDocument undoManager] beginUndoGrouping];
  NSIndexSet *indexes = [self.tableView selectedRowIndexes];
  MPFixAutotypeWindowController __weak *weakSelf = self;
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    id item = [weakSelf entriesAndGroups][idx];
    if([item isKindOfClass:[KPKEntry class]]){
      [item autotype].defaultKeystrokeSequence = nil;
    }
    else if([item isKindOfClass:[KPKGroup class]]) {
      [item setDefaultAutoTypeSequence:nil];
    }
    else {
      [item setKeystrokeSequence:nil];
    }
  }];
  [[self.workingDocument undoManager] endUndoGrouping];
  [[self.workingDocument undoManager] setActionName:@"Clear Autotype"];
  [self.tableView reloadDataForRowIndexes:indexes columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
}

#pragma mark -
#pragma mark NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [[self entriesAndGroups] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  id item = [self entriesAndGroups][row];
  KPKGroup *group;
  KPKEntry *entry;
  KPKWindowAssociation *association;
  if([item isKindOfClass:[KPKEntry class]]) {
    entry = item;
  }
  else if([item isKindOfClass:[KPKGroup class]]) {
    group = item;
  }
  else if([item isKindOfClass:[KPKWindowAssociation class]]) {
    association = item;
  }
  
  if([[tableColumn identifier] isEqualToString:kMPTitleCell]) {
    if(entry) {
      return entry.title;
    }
    if(group) {
      return [group breadcrumb];
    }
    return [association qualifedName];
  }
  else if ([[tableColumn identifier] isEqualToString:kMPAutotypeCell]) {
    if(entry) {
      return entry.autotype.defaultKeystrokeSequence;
    }
    if(group) {
      return group.defaultAutoTypeSequence;
    }
    return association.keystrokeSequence;
  }
  else {
    BOOL isDefault = NO;
    NSString *keystrokeSequence;
    if(entry) {
      isDefault = entry.autotype.hasDefaultKeystrokeSequence;
      keystrokeSequence = entry.autotype.defaultKeystrokeSequence;
    }
    else if( group ) {
      isDefault = group.hasDefaultAutotypeSequence;
      keystrokeSequence = group.defaultAutoTypeSequence;
    }
    else {
      isDefault = association.hasDefaultKeystrokeSequence;
      keystrokeSequence = association.keystrokeSequence;
    }
    if([[tableColumn identifier] isEqualToString:kMPIsDefaultCell]) {
      return isDefault ? @"Yes" : @"No";
    }
    else if( [[tableColumn identifier] isEqualToString:kMPIconCell]) {
      BOOL isWrongFormat = (NSOrderedSame == [@"{TAB}{USERNAME}{TAB}{PASSWORD}{ENTER}" compare:keystrokeSequence options:NSCaseInsensitiveSearch]);
      return (isWrongFormat && !isDefault) ? [MPIconHelper icon:MPIconWarning] : nil;
    }
  }
  return nil;
}


- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  id item = [self entriesAndGroups][row];
  
  if([item isKindOfClass:[KPKEntry class]]) {
    [[item autotype] setDefaultKeystrokeSequence:object];
  }
  else if([item isKindOfClass:[KPKGroup class]]) {
    [item setDefaultAutoTypeSequence:object];
  }
  else if([item isKindOfClass:[KPKWindowAssociation class]]) {
    [item setKeystrokeSequence:object];
  }
}

#pragma mark -
#pragma mark NSTableViewDelegate

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return [[tableColumn identifier] isEqualToString:kMPAutotypeCell];
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
  id item = [self entriesAndGroups][row];
  return [item isKindOfClass:[KPKGroup class]];
}

#pragma mark -
#pragma mark MenuItem Validation

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
  if(!([menuItem action] == @selector(clearAutotype:))) {
    return NO;
  }
  return ([[self.tableView selectedRowIndexes] count] > 0);
}

#pragma mark -
#pragma mark Data accessors

- (NSArray *)entriesAndGroups {
  if(nil == _elements) {
    _elements = [[NSMutableArray alloc] init];
    [self flattenGroup:self.workingDocument.root toArray:_elements];
  }
  return _elements;
}


- (void)flattenGroup:(KPKGroup *)group toArray:(NSMutableArray *)array {
  [array addObject:group];
  for(KPKEntry *entry in group.entries) {
    [array addObject:entry];
    [array addObjectsFromArray:entry.autotype.associations];
  }
  for(KPKGroup *childGroup in group.groups) {
    [self flattenGroup:childGroup toArray:array];
  }
}

#pragma mark NSUndoManagerNotifications
- (void)_didChangeDocument:(NSNotification *)notification {
  [self.tableView reloadData];
}

@end
