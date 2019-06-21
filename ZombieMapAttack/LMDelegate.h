//
//  LMDelegate.h
//  ZombieMapAttack
//
//  Created by K Y on 6/19/19.
//  Copyright © 2019 KY. All rights reserved.
//

#ifndef LMDelegate_h
#define LMDelegate_h

#import <CoreLocation/CoreLocation.h>

@protocol LMDelegate

- (void)didUpdateLocation:(CLLocation *)location;

@end

#endif /* LMDelegate_h */
