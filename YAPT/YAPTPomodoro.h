//
//  YAPTPomodoro.h
//  YAPT
//
//  Created by Bill Glover on 27/09/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAPTPomodoro : NSObject

typedef NS_ENUM(NSInteger, PomodoroState) {
    pomodoroNewState = 0,
    pomodoroActiveState = 1,
    pomodoroVoidState = 2,
    pomodoroCompleteState = 3
};

@property (nonatomic, strong, readonly) NSDate *startTime;
@property (nonatomic, readonly) NSTimeInterval remainingTime;
@property (nonatomic, readonly) NSTimeInterval pomodoroDuration;
@property (nonatomic, readonly) PomodoroState state;

- (void)startPomodoro;
- (void)voidPomodoro;

@end
