//
//  LocationManager.h
//  ZombieMapAttack
//
//  Created by K Y on 6/19/19.
//  Copyright © 2019 KY. All rights reserved.
//


/*
    Swift Singleton
    1. global, static, shared instance variable
    2. hid the initializer (can't do this in Objective-C)
    3. final class (can't do this in Objective-C)
 */

#import <Foundation/Foundation.h>
#import "LMDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject

+ (LocationManager *)sharedInstance;

@property id<LMDelegate> delegate;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
