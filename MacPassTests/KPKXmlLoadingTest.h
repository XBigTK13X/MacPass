//
//  KPKXmlLoadingTest.h
//  MacPass
//
//  Created by Michael Starke on 23.07.13.
//  Copyright (c) 2013 HicknHack Software GmbH. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
@class KPKPassword;

@interface KPKXmlLoadingTest : SenTestCase {
@private
  NSData *_data;
  KPKPassword *_password;
}

@end
