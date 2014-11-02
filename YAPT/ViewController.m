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
#import "CounterCollectionViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RoundButton *progressButton;
@property (weak, nonatomic) IBOutlet UILabel *timerCountdownLabel;
@property (weak, nonatomic) IBOutlet UIView *chalkBoardContainerView;
@property (strong, nonatomic, readwrite) YAPTPomodoro *currentPomodoro;
@property (strong, nonatomic, readwrite) YAPTTimer *timer;
@property (nonatomic, readwrite) BOOL yaptGongSoundEnabled;
@property (nonatomic, readwrite) BOOL yaptTickSoundEnabled;
@property (nonatomic, readwrite) NSInteger pomodoroCounter;
@end

@implementation ViewController

#pragma mark - Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // subscribe to notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willResignActive)
                                                 name:@"willResignActive" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:@"didEnterBackground" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground)
                                                 name:@"willEnterForeground" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:@"didBecomeActive" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willTerminate)
                                                 name:@"willTerminate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLocalNotification:)
                                                 name:@"didReceiveLocalNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userShookTheDevice:)
                                                 name:@"userShookTheDevice" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willResignActive {
    NSLog(@"YAPT willResignActive");
    
    // if we have an active pomodoro pause the timer
    if (self.currentPomodoro.state == pomodoroActiveState) {
        [self.timer suspendTimer];
    }
}

- (void)didEnterBackground {
    NSLog(@"YAPT didEnterBackground");
    
    // save the current pomodoro
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.currentPomodoro];
    [prefs setObject:myEncodedObject forKey:@"currentPomodoro"];
}

- (void)willEnterForeground {
    NSLog(@"YAPT willEnterForeground");
    
    // resture the saved pomodoro
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [prefs objectForKey:@"currentPomodoro" ];
    [prefs removeObjectForKey:@"currentPomodoro" ];
    
    if (myEncodedObject) {
        YAPTPomodoro *obj = (YAPTPomodoro *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        self.currentPomodoro = obj;
    }
    
}

- (void)didBecomeActive {
    NSLog(@"YAPT didBecomeActive");
    
    // update the display
    [self resetDisplay];
    
    // if we have an active pomodoro resume the timer
    if (self.currentPomodoro.state == pomodoroActiveState) {
        
        // but only if the active pomodoro isn't already complete
        if (self.currentPomodoro.remainingTime <= 0.0) {
            [self handleTimerComplete:FALSE];
        } else {
            [self.timer resumeTimer];
        }
    }
    
    // re-load settings incase they have changed while we were in the background
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:@"yaptGongSoundEnabled"]) {
        self.yaptGongSoundEnabled = [prefs boolForKey:@"yaptGongSoundEnabled"];
    } else {
        [prefs setBool:YES forKey:@"yaptGongSoundEnabled"];
        self.yaptGongSoundEnabled = YES;
    }
    
    if ([prefs objectForKey:@"yaptTickSoundEnabled"]) {
        self.yaptTickSoundEnabled = [prefs boolForKey:@"yaptTickSoundEnabled"];
    } else {
        [prefs setBool:YES forKey:@"yaptTickSoundEnabled"];
        self.yaptTickSoundEnabled = YES;
    }
}

- (void)willTerminate {
    NSLog(@"YAPT willTerminate");
    
    // abort current pomodoro
    if (self.currentPomodoro.state == pomodoroActiveState) {
        [self.timer abortTimer];
    }
    
    // clear any saved pomodoros
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"currentPomodoro" ];
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"Local notification received");
    
    // clear all outstanding notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // complete the timer but don't play sound
    [self handleTimerComplete:FALSE];
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
    if (self.yaptGongSoundEnabled) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"gong" ofType:@"aif"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
        AudioServicesPlayAlertSound (soundID);
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

- (void)playTickSound {
    if (self.yaptTickSoundEnabled) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"tick" ofType:@"aif"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
}

- (void)updateChalkBoard {
    // update the chalk board
    CounterCollectionViewController *counterVC = (CounterCollectionViewController *)[self.childViewControllers firstObject];
    counterVC.count = self.pomodoroCounter;
    
    // reload data and ensure we scroll to the bottom
    [counterVC.collectionView reloadData];
    
    NSInteger numberOfSections = counterVC.collectionView.numberOfSections - 1;
    NSInteger numberOfItemsInLastSection = [counterVC.collectionView numberOfItemsInSection:numberOfSections];
    
    NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:(numberOfItemsInLastSection - 1)
                                                         inSection:numberOfSections];
    
    if (numberOfItemsInLastSection != 0) {
        [counterVC.collectionView scrollToItemAtIndexPath:lastItemIndexPath
                                         atScrollPosition:UICollectionViewScrollPositionBottom
                                                 animated:YES];
    }

}

- (void)resetPomodoroCounter {
    NSLog(@"Resetting the pomodoro counter");
    self.pomodoroCounter = 0;
    [self updateChalkBoard];
}

#pragma mark - Gestures

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        // User was shaking the device. Post a notification named "shake."
        NSLog(@"Stop shaking the device");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userShookTheDevice" object:event];
    }
}

- (void)userShookTheDevice:(UIEvent *)event {
    [self resetPomodoroCounter];
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
    
    // play tick
    [self playTickSound];
    
    // update display
    [self updateTimerDisplay];
}

- (void)handleTimerComplete:(BOOL)withSound {
    
    // play the gong if required
    if (withSound) {
        [self playGongSound];
    }
    
    // check to see if the pomodoro was active
    if (self.currentPomodoro.state == pomodoroCompleteState) {
        // mark the current pomodoro as complete
        [self.currentPomodoro completePomodoro];
        self.pomodoroCounter++;
        
        // update the chalk board
        [self updateChalkBoard];
        
        NSLog(@"Completed %d pomodoros", self.pomodoroCounter);
    }
    
    // discard the pomodoro
    self.timer = nil;
    self.currentPomodoro = nil;
    
    // reset the display for the next pomodoro
    [self resetDisplay];
}

@end
