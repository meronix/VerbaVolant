//
//  SecondViewController.m
//  Mastro Pietro
//
//  Created by meronix on 02/04/2020.
//  Copyright © 2020 meronix. All rights reserved.
//

#import "MainGameVC.h"

#import <AVKit/AVKit.h>
#import "MoviesAndWords.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@interface MainGameVC ()

@property (nonatomic, strong) AVPlayerViewController* playerController;

@property (strong, nonatomic) IBOutlet UIView *quizView;

@property (strong, nonatomic) IBOutlet UIButton *b_answer_1;
@property (strong, nonatomic) IBOutlet UIButton *b_answer_2;
@property (strong, nonatomic) IBOutlet UIButton *b_answer_3;
@property (strong, nonatomic) IBOutlet UIButton *b_answer_4;
@property (strong, nonatomic) IBOutlet UIButton *continuaButton;
@property (strong, nonatomic) IBOutlet UIButton *esciButton;


@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutlet UIView *boxQuestionButtons;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UIView *boxContinueButtons;
@property (strong, nonatomic) IBOutlet UIView *boxMessage;

@property (nonatomic, strong) MoviesAndWords * myMoviesAndWords;
@property (nonatomic, strong) NSMutableArray * toBePlayedMovies;

@property (nonatomic) int answers_correct;
@property (nonatomic) int answers_total;

@property (nonatomic, strong) NSString * currentWord;


@end

@implementation MainGameVC

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.quizView.alpha = 0;
    [self loadJsonData];
    
    CGFloat cornerRad = 6;
    NSArray* tempArray = @[_boxMessage, _b_answer_1, _b_answer_2, _b_answer_3, _b_answer_4, _continuaButton, _esciButton];
    for (UIView* aView in tempArray) {
        aView.layer.cornerRadius = cornerRad;
        aView.layer.borderWidth = 1;
        aView.clipsToBounds = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.quizView.hidden = true;
    AppDelegate* appD = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appD.restrictRotation = UIInterfaceOrientationMaskLandscape;

}


-(IBAction)startToPlay:(id)sender {
    self.continuaButton.hidden = NO;
    self.scoreLabel.hidden = YES;

    self.boxQuestionButtons.hidden = YES;
//    self.continuaButton.hidden = YES;
    self.boxContinueButtons.hidden = YES;
    self.continuaButton.tag = 2;

    self.answers_correct = 0;
    self.answers_total = 0;
    [self updateScoreLabel];
    if (!_playerController) {
        self.playerController = [AVPlayerViewController new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:)
            name:AVPlayerItemDidPlayToEndTimeNotification object:[_playerController.player currentItem]];
    }

    NSString* nextWord = [self getNextMovieNameInList:self.myMoviesAndWords.listaMovie andRemove:NO];
    
    [self addPlayer:_playerController withFile:nextWord];
    [self nextLevel_playAnswer:NO withCorrectAnswer:NO];
    self.playerController.modalPresentationStyle = UIModalPresentationPopover;
    self.quizView.alpha = 0;
    self.quizView.hidden = YES;
    _playerController.modalPresentationStyle = UIModalPresentationFullScreen;
    _playerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController* myNav = self.navigationController;
    
    [myNav pushViewController:_playerController animated:YES];
    myNav.delegate = self;
  //  [self presentViewController:_playerController animated:YES completion:^() {
//        AVPlayer* player = self.playerController.player;
//        player.automaticallyWaitsToMinimizeStalling = NO;
//        [player playImmediatelyAtRate:1];
//        [player play];
//        //   [player performSelector:@selector(play) withObject:nil afterDelay:8];
//        [player performSelector:@selector(play) withObject:nil afterDelay:2.5];
//        [player performSelector:@selector(play) withObject:nil afterDelay:1.5];
//        [player performSelector:@selector(play) withObject:nil afterDelay:1];
//        [self.playerController.view addSubview:self.quizView];
//        self.quizView.alpha = 0;
//        self.quizView.hidden = YES;
//        AppDelegate* appD = (AppDelegate*) [[UIApplication sharedApplication] delegate];
//        appD.restrictRotation = UIInterfaceOrientationMaskLandscape;

 //   } ];
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self.playerController) {
        AVPlayer* player = self.playerController.player;
        if ([player respondsToSelector:@selector(setAutomaticallyWaitsToMinimizeStalling:)]) {
//            player.automaticallyWaitsToMinimizeStalling = NO;
//            [player playImmediatelyAtRate:1];
        }
        [player play];
        //   [player performSelector:@selector(play) withObject:nil afterDelay:8];
        [player performSelector:@selector(play) withObject:nil afterDelay:2.5];
        [player performSelector:@selector(play) withObject:nil afterDelay:1.5];
        [player performSelector:@selector(play) withObject:nil afterDelay:1];
        [self.playerController.view addSubview:self.quizView];
        self.quizView.alpha = 0;
        self.quizView.hidden = YES;
        AppDelegate* appD = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        appD.restrictRotation = UIInterfaceOrientationMaskLandscape;
    }
}

-(void)addPlayer:(AVPlayerViewController*)aPlayerVC withFile:(NSString*)aMovieFile{
    NSURL*  url = [NSURL URLWithString:@"https://meronix.altervista.org/mastroPietro/asinello.mp4"];
    url = [[NSBundle mainBundle] URLForResource: aMovieFile withExtension:@"mp4"];
    
    AVPlayer*  player = [AVPlayer playerWithURL:url];
    aPlayerVC.player = player;
    //    AVPlayer* player = aPlayerVC.player;
    //    AVPlayerItem* aNewTestItem = [[AVPlayerItem alloc] initWithURL:url];
    //  [self.playerController.player replaceCurrentItemWithPlayerItem:aNewTestItem];
    
    aPlayerVC.showsPlaybackControls = false;
    //    NSLog(@"Text: %@", self.navigationController);
}

-(void) playerItemDidReachEnd:(NSNotification*)notification {
    //Dismiss AVPlayerViewController
    NSLog(@"Text: %@", notification);
    NSLog(@"Text: %@", notification.class);
    
    if (_currentWord) {
        // step 0, do someting
        [UIView animateWithDuration:0.3f delay:0.f options: UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            // step 1, do someting
        }completion:^(BOOL finished) {
            // step 2, do someting
            self.boxQuestionButtons.hidden = NO;
            if (self.toBePlayedMovies.count == 0) {
                self.continuaButton.hidden = YES;
            }

        }];
    }
    
    _quizView.hidden = false;
    self.quizView.alpha = 1;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    AVPlayerViewController * playerVC = (AVPlayerViewController*) segue.destinationViewController;
//    self.playerController = playerVC;
//    [self addPlayer:playerVC];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:)
//        name:AVPlayerItemDidPlayToEndTimeNotification object:[_playerController.player currentItem]];
//
//    NSLog(@"playerVC: %@", playerVC);
//    NSLog(@"playerVC: %@", playerVC);
//
//}
-(void)updateScoreLabel{
    self.message.text = @"Che cosa ho detto?";
    self.scoreLabel.text = [NSString stringWithFormat:@"risposte esatte: %i / %i", _answers_correct, _answers_total];
}

- (IBAction)answerButton:(UIButton *)sender {
    NSLog(@"sender: %@", sender);
    BOOL playAnswer = YES;
    BOOL correctAnswer = YES;
    
    NSArray* tempArray = @[_b_answer_1, _b_answer_2, _b_answer_3, _b_answer_4];
    for (UIButton* aButt in tempArray) {
        aButt.userInteractionEnabled = NO;
        if (aButt.tag != 1) {
             aButt.alpha = .2;
        }
    }
    
    sender.alpha = 1;
    
    if (sender.tag == 1) {
        //        sender.backgroundColor = [UIColor greenColor];
        self.answers_total ++;
        self.answers_correct ++;
        //        [self performSelector:@selector(hideDelayedForAnswer:) withObject:sender afterDelay:.3];
        [self hideDelayedForAnswer:sender];
    } else if (sender.tag == 0){
        //        sender.backgroundColor = [UIColor redColor];
        correctAnswer = NO;
        self.answers_total ++;
        //    [self performSelector:@selector(hideDelayedForAnswer:) withObject:sender afterDelay:.3];
        [self hideDelayedForAnswer:sender];
    } else if (sender.tag == 2){
        playAnswer = NO;
        self.boxQuestionButtons.hidden = NO;
        self.boxContinueButtons.hidden = YES;
    }
    self.scoreLabel.hidden = NO;

    [self updateScoreLabel];
    [self nextLevel_playAnswer:playAnswer withCorrectAnswer:correctAnswer];
    //    [self performSelector:@selector(nextLevel) withObject:nil afterDelay:1];
}

-(void)hideDelayedForAnswer:(UIButton*)sender {
    // step 0, do someting
    [UIView animateWithDuration:.6f delay:.0f options: UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        // step 1, do someting
        if (sender.tag == 0){
            sender.backgroundColor = [UIColor redColor];
        }
        
        NSArray* tempArray = @[self.b_answer_1, self.b_answer_2, self.b_answer_3, self.b_answer_4];
        for (UIButton* aButt in tempArray) {
            aButt.userInteractionEnabled = NO;
            if (aButt.tag == 1) {
                 aButt.backgroundColor = [UIColor greenColor];
            }
        }

        
    }completion:^(BOOL finished) {
        // step 2, do someting
        // step 0, do someting
        [UIView animateWithDuration:.6f delay:2.2f options: UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            // step 1, do someting
            self.boxQuestionButtons.alpha = 0;
            self.boxContinueButtons.alpha = 0;

        }completion:^(BOOL finished) {
            // step 2, do someting
            self.boxQuestionButtons.hidden = YES;
            self.boxContinueButtons.hidden = NO;
            self.boxQuestionButtons.alpha = 1;
            self.boxContinueButtons.alpha = 1;
        }];

    }];
}

- (IBAction)exitButton:(UIButton *)sender {
    self.toBePlayedMovies = nil;
    [self.view addSubview:self.quizView];
    self.quizView.alpha = 0;
    self.quizView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
//    [self.playerController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)replayButton:(UIButton *)sender {
    self.quizView.alpha = 0;
    self.quizView.hidden = YES;
    self.playerController.showsPlaybackControls = false;

    AVPlayer* player = self.playerController.player;
    AVPlayerItem* videoItem = player.currentItem;
    [videoItem seekToTime:kCMTimeZero completionHandler:nil];
    if ([player respondsToSelector:@selector(setAutomaticallyWaitsToMinimizeStalling:)]) {
        player.automaticallyWaitsToMinimizeStalling = NO;
        [player playImmediatelyAtRate:1];
    }
    [player play];
}

-(void)nextLevel_playAnswer:(BOOL)showAnswer withCorrectAnswer:(BOOL)correctAnswer{
    if (!_toBePlayedMovies) {
        self.toBePlayedMovies = [self.myMoviesAndWords.listaMovie mutableCopy];
    }
    
    NSString* nextWord = nil;
    if (showAnswer) {
        if (correctAnswer) {
            nextWord = [self getNextMovieNameInList:self.myMoviesAndWords.listaRisposteOK andRemove:NO];
        } else {
            nextWord = [self getNextMovieNameInList:self.myMoviesAndWords.listaRisposteKO andRemove:NO];
        }
        self.message.text = [NSString stringWithFormat:@"%@", nextWord];
        self.currentWord = nil;
    } else {
        if (_toBePlayedMovies.count == 0) {
            [self exitButton:nil];
            return;
        }
        nextWord = [self getNextMovieNameInList:_toBePlayedMovies andRemove:YES];
        self.quizView.alpha = 0;
        self.quizView.hidden = YES;
        self.currentWord = nextWord;
        [self loadQuestionButtons];
    }
    
    [self addPlayer:_playerController withFile:nextWord];
    AVPlayer* player = self.playerController.player;
    
    if ([player respondsToSelector:@selector(setAutomaticallyWaitsToMinimizeStalling:)]) {
        player.automaticallyWaitsToMinimizeStalling = NO;
        [player playImmediatelyAtRate:1];
    }
    self.playerController.showsPlaybackControls = false;
    [player play];
    
}

-(void)loadQuestionButtons {
    //  if (_currentWord) {
    NSArray* tempArray = @[_b_answer_1, _b_answer_2, _b_answer_3, _b_answer_4];
    for (UIButton* aButt in tempArray) {
        aButt.tag = 0;
        aButt.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.4 alpha:.7];
        aButt.userInteractionEnabled = YES;
        aButt.alpha = 1;
    }
    int indexOk = arc4random() % tempArray.count;
    UIButton * tempButon = tempArray[indexOk];
    tempButon.tag = 1;
    [tempButon setTitle:_currentWord forState:UIControlStateNormal];
    
    NSMutableArray * tempArrayWords = [self.myMoviesAndWords.wrongWords mutableCopy];
    for (UIButton* aButt in tempArray) {
        if ( aButt.tag == 0) {
            [aButt setTitle:[self getNextMovieNameInList:tempArrayWords  andRemove:YES] forState:UIControlStateNormal];
        }
    }
    
    
    
    //   }
}

-(NSString*) getNextMovieNameInList:(NSArray*)inStringArray andRemove:(BOOL)andRemove{
    NSString* nextWord = @"asinello";
    
    if (inStringArray.count) {
        int index = arc4random() % inStringArray.count;
        nextWord = inStringArray[index];
        if (andRemove) {
            if ([inStringArray.class isSubclassOfClass:NSMutableArray.class]) {
                NSMutableArray* aliasArrayMutable = (NSMutableArray*)inStringArray;
                [aliasArrayMutable removeObjectAtIndex:index];
            }
        }
    }
    return nextWord;
}

+(NSDictionary*)getDictionaryByData:(NSData*)data{
    NSError *e = nil;
    id returnedObj = [NSJSONSerialization JSONObjectWithData:data
                                                     options: 0
                                                       error: &e];
    if(e){
        NSLog(@"%s: ERROR:%@",__PRETTY_FUNCTION__,[e description]);
        return nil;
    }
    
    NSDictionary* returnedDictionary = (NSDictionary*)returnedObj;
    if ([returnedDictionary.class isSubclassOfClass:NSDictionary.class]) {
        return returnedDictionary;
    }
    return nil;
}


-(void)loadJsonData{
    NSString *fileLocation = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"listaMovie.json"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileLocation]){
        NSLog(@"%s %@ doesn't exist",__PRETTY_FUNCTION__,fileLocation);
        return;
    }
    NSMutableData * data = [NSMutableData dataWithContentsOfFile:fileLocation];
    
    if (data) {
        NSDictionary* returnedDictionary = [MainGameVC getDictionaryByData:data];
        if (returnedDictionary) {
            MoviesAndWords * retBean = [MoviesAndWords modelObjectWithDictionary:returnedDictionary];
            NSLog(@"retBean listaMovie: %@", retBean.listaMovie);
            NSLog(@"retBean wrongWords: %@", retBean.wrongWords);
            NSLog(@"retBean: %@", retBean);
            self.myMoviesAndWords = retBean;
        }
    }
}

@end
