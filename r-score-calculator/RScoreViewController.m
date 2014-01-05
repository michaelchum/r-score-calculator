//
//  RScoreViewController.m
//  r-score-calculator
//
//  Created by Michael Ho on 1/4/2014.
//  Copyright (c) 2014 Michael Ho. All rights reserved.
//

#import "RScoreViewController.h"

@interface RScoreViewController ()

@property (weak, nonatomic) IBOutlet UITextField *grade;
@property (weak, nonatomic) IBOutlet UITextField *average;
@property (weak, nonatomic) IBOutlet UITextField *deviation;
@property (weak, nonatomic) IBOutlet UITextField *highschool;
@property (weak, nonatomic) IBOutlet UILabel *rscoreLabel;
@property (strong, nonatomic) NSString *popupError;
@property (strong, nonatomic) NSString *rscore;

@end

@implementation RScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.rscore = @"";
    [self updateUI];
}

- (IBAction)calculate:(id)sender {
    self.rscore = @"";
    if ([self.grade.text length]>0 && [self.average.text length]>0 && [self.deviation.text length]>0 && [self.highschool.text length]>0) {
        float rscore = [self calculateRScore:[self.grade.text floatValue]
                                    average:[self.average.text floatValue]
                                  deviation:[self.deviation.text floatValue]
                                 highschool:[self.highschool.text floatValue]];
        self.rscore = [NSString stringWithFormat:@"%.2f", rscore];
    } else {
        [self errorUI];
    }
    [self updateUI];
}

// returns R-score
- (float)calculateRScore:(float)grade average:(float)average deviation:(float)deviation highschool:(float)highschool {
    return ([self calculateZScore:grade average:average deviation:deviation] + [self calculateStrength:highschool] + 5) * 5;
}

// returns Z-score
- (float)calculateZScore:(float)grade average:(float)average deviation:(float)deviation {
    return (grade - average)/deviation;
}

// returns group strength according to highschool average
- (float)calculateStrength:(float)highschool{
    return (highschool-75.0)/14.0;
}

// update the R-score in storyboard
- (void)updateUI{
    [self.rscoreLabel setText:[NSString stringWithFormat:@"%@", self.rscore]];
}

- (void)errorUI{
    NSString *message = [NSString stringWithFormat:@"Please fill up all the fields"];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:message
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

// dismiss keyboard on touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

@end
