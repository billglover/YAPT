//
//  ViewController.m
//  YAPT
//
//  Created by Bill Glover on 20/09/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RoundButton.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RoundButton *progressButton;
@property (weak, nonatomic) IBOutlet UILabel *timerCountdownLabel;
@property (strong, nonatomic, readwrite) YAPTPomodoro *currentPomodoro;
@property (strong, nonatomic, readwrite) YAPTTimer *timer;
@end

@implementation ViewController

#pragma mark - Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Interaction

- (IBAction)progressButtonPress:(RoundButton *)sender {
    
    if (self.currentPomodoro.state == pomodoroNewState) {
        [self.currentPomodoro startPomodoro];
        
        // update the button label
        [self.progressButton setTitle:@"Abort" forState:UIControlStateNormal];
        
        // start the timer
        [self.timer startTimerForPomodoro:self.currentPomodoro];

    }
    
    else if (self.currentPomodoro.state == pomodoroActiveState) {
        [self.currentPomodoro voidPomodoro];
        
        // update the button label
        [self.progressButton setTitle:@"Start" forState:UIControlStateNormal];
        
        // end the timer
        [self.timer abortTimer];
        self.timer = nil;
        
        // discard the pomodoro for now
        self.currentPomodoro = nil;
    }
    
}

- (void)updateTimerDisplay {
    
    // Update the countdown clock
    // Stack Overflow: http://stackoverflow.com/questions/4933075/nstimeinterval-to-hhmmss
    NSInteger ti = (NSInteger)self.currentPomodoro.remainingTime;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    
    NSString *timeRemaining = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    self.timerCountdownLabel.text = timeRemaining;
    
    // Update the progress bar
    self.progressButton.percent = self.currentPomodoro.remainingTime / self.currentPomodoro.pomodoroDuration;
}

- (void)resetDisplay {
    if (self.currentPomodoro) {
        [self updateTimerDisplay];
    }
    
    [self.progressButton setTitle:@"Start" forState:UIControlStateNormal];
}

- (void)playGongSound {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"gong" ofType:@"aif"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlayAlertSound (soundID);
}

#pragma mark - Getters & Setters

- (YAPTPomodoro *)currentPomodoro {
    if (!_currentPomodoro) {
        _currentPomodoro = [[YAPTPomodoro alloc] init];
    }
    return _currentPomodoro;
}

- (YAPTTimer *)timer {
    if (!_timer) {
        _timer = [[YAPTTimer alloc] init];
        _timer.delegate = self;
    }
    return _timer;
}

#pragma mark - Timer Delegate

- (void)handleTimerTickEvent {
    [self updateTimerDisplay];
}

- (void)handleTimerComplete {
    NSLog(@"Timer complete event fired");
    
    // play the gong
    [self playGongSound];
    
    // discard the pomodoro
    self.timer = nil;
    self.currentPomodoro = nil;
    
    // reset the display for the next pomodoro
    [self resetDisplay];
}

@end
