//
//  CountDownGameViewController.m
//  gameBeforeDishes
//
//  Created by Kent Walters on 2016-03-20.
//  Copyright © 2016 bdong. All rights reserved.
//

#import "CountDownGameViewController.h"

@interface CountDownGameViewController ()

@end

NSTimer* timer;
float a;
NSTimer* fastTimer;
int iterations;

@implementation CountDownGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startGame];

    //[super.threadProgressView1 setTransform:CGAffineTransformMakeRotation(-M_PI)];
    UILabel* lab = [super QuestionDown];
    [lab setTransform:CGAffineTransformMakeRotation(-M_PI)];
    
}

-(void) startGame{
    super.GoodTimeToPressButton = NO;
    a = 1.00;
    _countdownNumber = 9;
    iterations = 0;
    
    super.QuestionUp.text = [NSMutableString stringWithFormat:@"%d", _countdownNumber];
    super.QuestionDown.text = [NSMutableString stringWithFormat:@"%d", _countdownNumber];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(tick)
                                           userInfo:nil
                                            repeats:YES];
}

-(void) callTimer{
    fastTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(alp)
                                               userInfo:nil
                                                repeats:YES];
}

- (void) tick{
    if (_countdownNumber <=0){
        [timer invalidate];
        super.GoodTimeToPressButton = YES;
    }
  
    super.QuestionUp.text = [NSMutableString stringWithFormat:@"%d", _countdownNumber];
    super.QuestionDown.text = [NSMutableString stringWithFormat:@"%d", _countdownNumber];
    _countdownNumber--;
    iterations ++;
    if (iterations == 2){
        [self callTimer];
    }

}

-(void) alp{
    a = a-0.018;
    super.QuestionUp.alpha = (a);
    super.QuestionDown.alpha = (a);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
