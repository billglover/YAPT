//
//  YAPTTimer.m
//  YAPT
//
//  Created by Bill Glover on 28/09/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import "YAPTTimer.h"

#define TIMER_TICK_MINOR 0.1
#define TIMER_TICK_MAJOR 1.0

@interface YAPTTimer()

@property (nonatomic, readwrite) YAPTPomodoro* pomodoro;
@property (nonatomic, strong, readwrite) NSTimer* timer;

@end

@implementation YAPTTimer

- (void)startTimerForPomodoro:(YAPTPomodoro *)pomodoro {
    
    if (pomodoro) {
        
        // hang on to this pomodoro
        self.pomodoro = pomodoro;
        
        // start the pomodoro
        [self.pomodoro startPomodoro];
        NSLog(@"Starting pomodoro at: %@", self.pomodoro.startTime);
        
        // set the interface update timer
        self.timer = [NSTimer timerWithTimeInterval:TIMER_TICK_MINOR
                                             target:self
                                           selector:@selector(timerTickMinor:)
                                           userInfo:nil
                                            repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        // set the notification
        [self scheduleLocalNotification];
        
    } else {
        NSLog(@"Unable to start YAPTTimer without valid pomodoro");
    }

}

- (void)suspendTimer {
    NSLog(@"Suspending pomodoro at: %@", [NSDate date]);
    
    // void the interface update timer
    [self.timer invalidate];
    self.timer = nil;
}

- (void)resumeTimer {
    NSLog(@"Resuming pomodoro at: %@", [NSDate date]);
    
    // set the interface update timer
    self.timer = [NSTimer timerWithTimeInterval:TIMER_TICK_MINOR
                                         target:self
                                       selector:@selector(timerTickMinor:)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)abortTimer {
    
    // mark the pomodoro as void
    [self.pomodoro voidPomodoro];
    NSLog(@"Voiding pomodoro at: %@", [NSDate date]);
    
    // void the interface update timer
    [self.timer invalidate];
    self.timer = nil;
    
    // fire the timerComplete event
    [self timerComplete];
    
    
}

- (void)scheduleLocalNotification {
    NSDate *fireDate = [NSDate dateWithTimeInterval:self.pomodoro.pomodoroDuration sinceDate:self.pomodoro.startTime];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = @"Pomodoro complete";
    localNotification.soundName = @"gong.aif";
    localNotification.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - Timer Events

- (void)timerTickMinor:(NSTimer *)timer {

    if (self.pomodoro.remainingTime <= 0.0) {
        [self timerComplete];
    }
    
    // for now, fire the major tick on each minor tick
    [self timerTickMajor];
}

- (void)timerTickMajor {
    // let the delegate know the timer has fired a tick event
    if ([self.delegate respondsToSelector:@selector(handleTimerTickEvent)]) {
        [self.delegate handleTimerTickEvent];
    }
}

- (void)timerComplete {
    // suspend the timer
    [self suspendTimer];
    
    // set the pomodoro state as complete
    [self.pomodoro completePomodoro];
    NSLog(@"Completing pomodoro at: %@", [NSDate date]);
    
    // let the delegate know the timer is complete
    if ([self.delegate respondsToSelector:@selector(handleTimerComplete:)]) {
        [self.delegate handleTimerComplete:TRUE];
    }
}

@end
