//
//  YAPTPomodoro.m
//  YAPT
//
//  Created by Bill Glover on 27/09/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import "YAPTPomodoro.h"

#define POMODORO_DURATION 25.0 * 60.0 // 25 minutes expressed as seconds

@interface YAPTPomodoro()
@property (nonatomic, strong, readwrite) NSDate *startTime;
@property (nonatomic, readwrite) NSTimeInterval pomodoroDuration;
@property (nonatomic, readwrite) PomodoroState state;
@end

@implementation YAPTPomodoro

#pragma mark - Initialisation
- (instancetype) init {

    // set the state to 'new' on initialisation
    if ((self = [super init])) {
        self.state = pomodoroNewState;
    }
    return self;
}

#pragma mark - Getters & Setters
- (NSTimeInterval) remainingTime {
    
    NSTimeInterval timeRemaining = 0.0f;
    
    // if we are active, return the time remaining
    if (self.state == pomodoroActiveState || self.state == pomodoroNewState) {
        
        // calculate the time since the pomodoro Started
        timeRemaining = self.pomodoroDuration + [self.startTime timeIntervalSinceNow];
        
        // time intervals below 0 are invalid
        if (timeRemaining < 0) {
            timeRemaining = 0.0f;
        }
        
    }
    
    return timeRemaining;
}

- (NSTimeInterval)pomodoroDuration {
    return POMODORO_DURATION;
}

#pragma mark - Behaviours
- (void)startPomodoro {
    
    // set the start time
    self.startTime = [NSDate date];
    
    // set the state
    self.state = pomodoroActiveState;
}

- (void)voidPomodoro {
    
    // set the state
    self.state = pomodoroVoidState;
}

#pragma mark - Serialisation

- (void) encodeWithCoder : (NSCoder *)encoder {
    [encoder encodeObject:self.startTime forKey:@"startTime"];
    [encoder encodeDouble:self.pomodoroDuration forKey:@"pomodoroDuration"];
    [encoder encodeInteger:self.state forKey:@"state"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if ( self != nil ) {
        //decode the properties
        self.startTime = [decoder decodeObjectForKey:@"startTime"];
        self.pomodoroDuration = [decoder decodeDoubleForKey:@"pomodoroDuration"];
        self.state = [decoder decodeIntegerForKey:@"state"];
    }
    return self;
}


@end
