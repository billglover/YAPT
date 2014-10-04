//
//  YAPTTimer.h
//  YAPT
//
//  Created by Bill Glover on 28/09/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YAPTPomodoro.h"

@protocol YAPTTImerDelegate <NSObject>

@optional

- (void)handleTimerTickEvent;
- (void)handleTimerComplete:(BOOL)withSound;

@end

@interface YAPTTimer : NSObject

@property (nonatomic, strong, readonly) YAPTPomodoro* pomodoro;
@property (nonatomic, weak, readwrite) id <YAPTTImerDelegate> delegate;

- (void)startTimerForPomodoro:(YAPTPomodoro *)pomodoro;
- (void)suspendTimer;
- (void)resumeTimer;
- (void)abortTimer;

@end
