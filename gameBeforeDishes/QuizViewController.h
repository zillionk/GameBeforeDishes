//
//  QuizViewController.h
//  gameBeforeDishes
//
//  Created by bdong on 2016-03-06.
//  Copyright © 2016 bdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizViewController : UIViewController
@property BOOL GoodTimeToPressButton;
@property float Time;
@property NSTimer* Timer;
@property IBOutlet UILabel* QuestionUp;
@property IBOutlet UILabel* QuestionDown;
@property IBOutlet UILabel* AnswerUp;
@property IBOutlet UILabel* AnswerDown;

@property IBOutlet UIProgressView* threadProgressView1;
@property IBOutlet UIProgressView* threadProgressView2;

- (void)setQuestion:(NSString*)theQuestion;
- (void)setAnswer:(NSString*)theAnswer;
- (BOOL)isGoodTime;




@end
