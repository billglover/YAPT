//
//  YAPTPomodoroTestCase.m
//  YAPT
//
//  Created by Bill Glover on 27/09/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "YAPTPomodoro.h"

@interface YAPTPomodoroTestCase : XCTestCase

@end

@implementation YAPTPomodoroTestCase

#pragma mark - Setup

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

#pragma mark - Test Cases

- (void)testInitialisationSetsNewState {
    YAPTPomodoro *pomodoro = [[YAPTPomodoro alloc] init];
    XCTAssertEqual(pomodoro.state, pomodoroNewState);
}

- (void)testInitialisationDoesNotSetStartTime {
    YAPTPomodoro *pomodoro = [[YAPTPomodoro alloc] init];
    XCTAssertNil(pomodoro.startTime);
}

- (void)testStartingPomodoroSetsStartTime {
    YAPTPomodoro *pomodoro = [[YAPTPomodoro alloc] init];
    [pomodoro startPomodoro];

    // assert that the start time was in the past
    XCTAssertLessThanOrEqual([pomodoro.startTime timeIntervalSinceNow], 0.0f);
}

- (void)testRemainingTimeForNewCalculation {
    YAPTPomodoro *pomodoro = [[YAPTPomodoro alloc] init];
    XCTAssertEqual(pomodoro.pomodoroDuration, pomodoro.remainingTime);
}

- (void)testRemainingTimeForActiveCalculation {
    YAPTPomodoro *pomodoro = [[YAPTPomodoro alloc] init];
    [pomodoro startPomodoro];
    
    XCTestExpectation *timerDelay = [self expectationWithDescription:@"timer delay"];
    
    NSTimeInterval delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        // we should be within 12.5% over 2 seconds
        // actual acuracy should be better but we have no guarantee on test set-up times
        NSTimeInterval timeElapsed = pomodoro.pomodoroDuration - pomodoro.remainingTime;
        XCTAssertEqualWithAccuracy(timeElapsed, delayInSeconds, 0.25f);
        
        [timerDelay fulfill];
    });
    
    // if we aren't done within three seconds, something went wrong
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {}];
}

- (void)testVoidState {
    YAPTPomodoro *pomodoro = [[YAPTPomodoro alloc] init];
    [pomodoro voidPomodoro];
    XCTAssertEqual(pomodoro.state, pomodoroVoidState);
}

#pragma mark - Tear Down

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
