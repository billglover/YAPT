//
//  ViewController.m
//  YAPT
//
//  Created by Bill Glover on 20/09/2014.
//  Copyright (c) 2014 Bill Glover. All rights reserved.
//

#import "ViewController.h"
#import "RoundButton.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RoundButton *progressButton;
@property (weak, nonatomic) IBOutlet UISlider *demoSlider;
@property (nonatomic, strong, readwrite) YAPTPomodoro *currentPomodoro;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.progressButton.percent = self.demoSlider.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Interaction

- (IBAction)progressButtonPress:(RoundButton *)sender {
    
    if (self.currentPomodoro.state == pomodoroNewState) {
        NSLog(@"Starting a new pomodoro");
        [self.currentPomodoro startPomodoro];
        
        // update the button label
        [self.progressButton setTitle:@"Abort" forState:UIControlStateNormal];
    }
    
    else if (self.currentPomodoro.state == pomodoroActiveState) {
        NSLog(@"Voiding the current pomodoro");
        [self.currentPomodoro voidPomodoro];
        
        // discard the pomodoro for now
        self.currentPomodoro = nil;
        
        // update the button label
        [self.progressButton setTitle:@"Start" forState:UIControlStateNormal];

    }
    
}

- (IBAction)demoSliderChanged:(UISlider *)sender {
    self.progressButton.percent = self.demoSlider.value;
}

#pragma mark - Getters & Setters

- (YAPTPomodoro *)currentPomodoro {
    if (!_currentPomodoro) {
        _currentPomodoro = [[YAPTPomodoro alloc] init];
    }
    return _currentPomodoro;
}

@end
