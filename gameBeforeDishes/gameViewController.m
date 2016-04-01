//
//  gameViewController.m
//  gameBeforeDishes
//
//  Created by bdong on 2016-02-28.
//  Copyright © 2016 bdong. All rights reserved.
//

#import "gameViewController.h"
#import "gameConst.h"

UIColor* winColor;
UIColor* lostColor;
UIColor* normalColor;

gameConst* constString;
EmbedGameViewController* capitalAndCountry;
EmbedGameViewController* greenScreen;
EmbedGameViewController* CDGVC;
EmbedGameViewController* colourGame;
EmbedGameViewController* alphabetGame;
EmbedGameViewController* mathGame;
NSMutableArray* gameList;
NSMutableArray* unplayedGameList;
int currentGamePlayed;
int gameRoundsPerMiniGame;
int totalScoreLimit;
bool buttonLock;

@implementation gameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentGamePlayed = 0;
    gameRoundsPerMiniGame = [[NSUserDefaults standardUserDefaults] integerForKey:@"roundsPerMiniGame"];
    totalScoreLimit = [[NSUserDefaults standardUserDefaults] integerForKey:@"maxPoints"];
    buttonLock = false;
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view, typically from a nib.
    self.buttonList = [NSMutableArray arrayWithObjects:_button1,_button2,_button3,_button4, nil];
    self.scoreLabelList = [NSMutableArray arrayWithObjects:_ScoreLabel1,_ScoreLabel2,_ScoreLabel3,_ScoreLabel4, nil];
    self.scoreList = [NSMutableArray arrayWithCapacity:4];
    self.scoreList[0]=@0;
    self.scoreList[1]=@0;
    self.scoreList[2]=@0;
    self.scoreList[3]=@0;
    //setting up games.
    capitalAndCountry = [self.storyboard instantiateViewControllerWithIdentifier:@"capitalAndCountry"];
    greenScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"greenScreenGame"];
    CDGVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CDGVC"];
    colourGame = [self.storyboard instantiateViewControllerWithIdentifier:@"colourGame"];
    alphabetGame = [self.storyboard instantiateViewControllerWithIdentifier:@"alphabetGame"];
    mathGame = [self.storyboard instantiateViewControllerWithIdentifier:@"mathGame"];

    self.currentVC = capitalAndCountry;
    
//    [self addChildViewController:capitalAndCountry];
//    [self addChildViewController:greenScreen];
    gameList = [NSMutableArray arrayWithObjects:capitalAndCountry, mathGame, alphabetGame, colourGame, CDGVC, greenScreen, nil];
    unplayedGameList = [[NSMutableArray alloc] initWithArray:gameList];
    
    [self updateScoreLabels];
    
    winColor = [UIColor colorWithRed:0.38 green:1 blue:0.412 alpha:1];
    lostColor= [UIColor colorWithRed:1 green:0.412 blue:0.38 alpha:1];
    normalColor = [UIColor colorWithRed:0.992 green:0.992 blue:0.800 alpha:1.0];
    constString = [[gameConst alloc] init];
    _button1.transform = CGAffineTransformMakeRotation(M_PI);
    _ScoreLabel1.transform = CGAffineTransformMakeRotation(M_PI);
    _button3.hidden = true;
    _button4.hidden = true;
    [self showViewB];
    self.initialVC = self.childViewControllers.lastObject;
    self.substituteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CDGVC"];
    self.currentVC = self.initialVC;
    
    [self SwitchControllers];
    [self resetButtonStatus];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"quiz_embed"]) {
        _currentVC = (EmbedGameViewController *) [segue destinationViewController];
    }
}

-(IBAction)pressPlayerButton:(id)sender
{
    if (buttonLock == false) {
        buttonLock = true;
        [self setButtonsStatus:sender isItWin:[_currentVC isGoodTime]];
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(resetButtonStatus)
                                       userInfo:nil
                                        repeats:NO];
        [_currentVC pauseGame];
        [_currentVC showAnswer];
    }

}


-(void)SwitchControllers{
    if ([unplayedGameList count] == 0) {
        unplayedGameList = [[NSMutableArray alloc] initWithArray:gameList];
    }
    EmbedGameViewController* thisGame = unplayedGameList[0];
    
    [self addChildViewController:thisGame];
    thisGame.view.frame = self.containerViewB.bounds;
    [self moveToNewController:thisGame];
    [unplayedGameList removeObject: thisGame];
}

-(void)moveToNewController:(EmbedGameViewController *) newController {
    [self.currentVC willMoveToParentViewController:nil];
    [self transitionFromViewController:self.currentVC toViewController:newController duration:.6 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{}
                            completion:^(BOOL finished) {
                                [self.currentVC removeFromParentViewController];
                                [newController didMoveToParentViewController:self];
                                self.currentVC = newController;
                                for (UIButton *button  in _buttonList) {
                                    //TODO set back to button's name
                                    [button setTitle:[_currentVC getGameInstruction] forState:UIControlStateNormal];
                                    [button setBackgroundColor:normalColor];
                                }
                            }];
}


- (void)setButtonsStatus:(UIButton*)pressedButton isItWin:(BOOL)isGoodTimeToPress
{
    int arrayIndex = [_buttonList indexOfObject:pressedButton];
    if (isGoodTimeToPress) {
        [pressedButton setBackgroundColor:winColor];
        [pressedButton setTitle:[constString.PositiveWinText objectAtIndex:arc4random() % [constString.PositiveWinText count]] forState:UIControlStateNormal];
        int value = [_scoreList[arrayIndex] integerValue];
        [self.scoreList replaceObjectAtIndex:arrayIndex withObject:[NSNumber numberWithInt:value+1]];
        UILabel* thisLabel = self.scoreLabelList[arrayIndex];
        thisLabel.text = [NSString stringWithFormat: @"%@", _scoreList[arrayIndex]];
        for (UIButton *button  in _buttonList) {
            if (button != pressedButton) {
                [button setTitle:[constString.NegativeLostText objectAtIndex:arc4random() % [constString.NegativeLostText count]] forState:UIControlStateNormal];
                [button setBackgroundColor:lostColor];
            }
        }
    }else {
        [pressedButton setBackgroundColor:lostColor];
        [pressedButton setTitle:[constString.PositiveLostText objectAtIndex:arc4random() % [constString.PositiveLostText count]] forState:UIControlStateNormal];
        int value = [_scoreList[arrayIndex] integerValue];
        [self.scoreList replaceObjectAtIndex:arrayIndex withObject:[NSNumber numberWithInt:value-1]];
        [self updateScoreLabels];
        for (UIButton *button  in _buttonList) {
            if (button != pressedButton) {
                [button setTitle:[constString.NegativeWinText objectAtIndex:arc4random() % [constString.NegativeWinText count]] forState:UIControlStateNormal];
                [button setBackgroundColor:winColor];

            }
        }
    }
}

-(void)resetButtonStatus
{
    buttonLock = false;
    [_currentVC resetGame];
    [self UpdateGameStatus];
    for (UIButton *button  in _buttonList) {
            //TODO set back to button's name
            [button setTitle:[_currentVC getGameInstruction] forState:UIControlStateNormal];
            [button setBackgroundColor:normalColor];
    }

}

-(void)updateScoreLabels
{
    int index = 0;
    for (UILabel *label in _scoreLabelList)
    {
        label.text = [NSString stringWithFormat: @"%@", _scoreList[index]];
        index ++;
    }
}

-(void)showViewA
{
//    self.containerViewA.alpha = 1;
    self.containerViewA.hidden = false;
//    self.containerViewB.alpha = 0;
    self.containerViewB.hidden = true;

}

-(void)showViewB
{
//    self.containerViewA.alpha = 0;
    self.containerViewA.hidden = true;
    self.containerViewB.hidden = false;

//    self.containerViewB.alpha = 1;
}

- (IBAction)popBackMenu:(id)sender
{
    if (self.navigationController.navigationBar.hidden) {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBar.hidden = NO;
    }else{
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        self.navigationController.navigationBar.hidden = YES;
    }
}


- (void)UpdateGameStatus
{
    currentGamePlayed++;
    if (currentGamePlayed > gameRoundsPerMiniGame) {
        currentGamePlayed = 0;
        [self SwitchControllers];
    }

}
@end
