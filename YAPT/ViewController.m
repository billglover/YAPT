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

- (IBAction)progressButtonPress:(RoundButton *)sender {
    NSLog(@"progressButtonPress");
}

- (IBAction)demoSliderChanged:(UISlider *)sender {
    self.progressButton.percent = self.demoSlider.value;
}
@end
