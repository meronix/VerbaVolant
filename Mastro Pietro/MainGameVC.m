//
//  SecondViewController.m
//  Mastro Pietro
//
//  Created by meronix on 02/04/2020.
//  Copyright © 2020 meronix. All rights reserved.
//

#import "MainGameVC.h"

#import <AVKit/AVKit.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define webIncluded @"-includi le video lezioni on-line: si"
#define webNotIncluded @"-includi le video lezioni on-line: no"


@implementation MoviesAndWords_MovieObj (utilities)

-(MovieSourceType)getType{
    if ([self.type isEqualToString:@"web"]) {
        return MovieSourceType_web;
    }
    return MovieSourceType_embedded;
}

@end

@interface MainGameVC ()

@property (nonatomic, strong) AVPlayerViewController* playerController;

@property (strong, nonatomic) IBOutlet UIView *quizView;

@property (strong, nonatomic) IBOutlet UIButton *b_answer_1;
@property (strong, nonatomic) IBOutlet UIButton *b_answer_2;
@property (strong, nonatomic) IBOutlet UIButton *b_answer_3;
@property (strong, nonatomic) IBOutlet UIButton *b_answer_4;
@property (strong, nonatomic) IBOutlet UIButton *continuaButton;
@property (strong, nonatomic) IBOutlet UIButton *esciButton;
@property (strong, nonatomic) IBOutlet UIButton *emergencyExit;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *labelButton_addWeb;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *initialMessageLabel;

@property (strong, nonatomic) IBOutlet UIView *boxQuestionButtons;
@property (strong, nonatomic) IBOutlet UIView *boxContinueButtons;
@property (strong, nonatomic) IBOutlet UIView *boxMessage;
@property (strong, nonatomic) IBOutlet UIView *boxView_addWeb;

@property (nonatomic, strong) MoviesAndWords_Main * myMoviesAndWords_local;
@property (nonatomic, strong) MoviesAndWords_Main * myMoviesAndWords_web_stored;
@property (nonatomic, strong) MoviesAndWords_Main * myMoviesAndWords_web;
@property (nonatomic, strong) NSMutableArray * toBePlayedMovies;

@property (nonatomic) int answers_correct;
@property (nonatomic) int answers_total;

@property (nonatomic, strong) NSString * currentWord;
@property (nonatomic, strong) UIColor * greenColor;

@end

@implementation MainGameVC

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareButton.hidden = YES;
    self.boxView_addWeb.tag = 0;
    self.labelButton_addWeb.text = webNotIncluded;
    UITapGestureRecognizer * myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSwitchOnLine:)];
    [self.boxView_addWeb addGestureRecognizer:myTap];
    self.boxView_addWeb.userInteractionEnabled = NO;
    self.boxView_addWeb.alpha = 0.5;

    self.greenColor = self.boxMessage.backgroundColor;
    self.quizView.alpha = 0;
    [self loadJsonData];
    
    CGFloat cornerRad = 6;
    NSArray* tempArray = @[_boxMessage, _b_answer_1, _b_answer_2, _b_answer_3, _b_answer_4, _continuaButton, _esciButton];
    for (UIView* aView in tempArray) {
        aView.layer.cornerRadius = cornerRad;
        aView.layer.borderWidth = 1;
        aView.clipsToBounds = YES;
    }
    [self tryToDownloadWebList];
    
//    _boxView_addWeb.backgroundColor = _greenColor;
//    _boxView_addWeb.layer.cornerRadius = cornerRad;
//    _boxView_addWeb.layer.borderWidth = 1;
//    _boxView_addWeb.clipsToBounds = YES;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.emergencyExit.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.quizView.hidden = true;
    AppDelegate* appD = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appD.restrictRotation = UIInterfaceOrientationMaskLandscape;

}

-(void)tapSwitchOnLine:(UITapGestureRecognizer*)aTapGesture{
    if (self.boxView_addWeb.tag == 0) {
        self.boxView_addWeb.tag = 1;
        self.labelButton_addWeb.text = webIncluded;
    } else {
        self.boxView_addWeb.tag = 0;
        self.labelButton_addWeb.text = webNotIncluded;
    }
}

-(IBAction)startToPlay:(id)sender {
    //  if (!_toBePlayedMovies) {
    self.myMoviesAndWords_web = nil;
    self.toBePlayedMovies = [self.myMoviesAndWords_local.listaMovie.movieObj mutableCopy];
    if (_boxView_addWeb.tag == 1 ) {
        self.myMoviesAndWords_web = _myMoviesAndWords_web_stored;
        if (_myMoviesAndWords_web.listaMovie.movieObj.count) {
            [self.toBePlayedMovies addObjectsFromArray:_myMoviesAndWords_web.listaMovie.movieObj];
            LOG(@"ADDED web list: self.toBePlayedMovies: count:%i,\n %@", self.toBePlayedMovies.count, self.toBePlayedMovies);
        }
    }
    //  }
    
    self.emergencyExit.hidden = YES;
    self.continuaButton.hidden = NO;
    self.scoreLabel.hidden = YES;
    self.boxMessage.backgroundColor = self.greenColor;
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
        
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEmergencyExitButton:)
        //                                                     name:AVPlayerItemFailedToPlayToEndTimeNotification object:[_playerController.player currentItem]];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEmergencyExitButton:)
        //                                                     name:AVPlayerItemPlaybackStalledNotification object:[_playerController.player currentItem]];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEmergencyExitButton:)
        //                                                     name:AVPlayerItemNewErrorLogEntryNotification object:[_playerController.player currentItem]];
        
        //        [self.playerController.player addObserver:self
        //        forKeyPath:@"status"
        //           options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
        //           context:nil];
        //        [self.playerController.player addObserver:self
        //        forKeyPath:@"error"
        //           options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
        //           context:nil];
        
    }
    
    MoviesAndWords_MovieObj* nextMovieObj = [self getNextMovieObjInList:_toBePlayedMovies andRemove:NO]; // serve solo a inizializzare player: non verrà usato questo movie
    
    [self addPlayer:_playerController withFile:nextMovieObj];
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

// Observe If AVPlayerItem.status Changed to Fail

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.playerController.player ) {
        if ([keyPath isEqualToString:@"status"]) {
            if (self.playerController.player.status == AVPlayerStatusReadyToPlay) {
                LOG(@"PLAYER NOTIFICATION: PLAYING");
                [self performSelector:@selector(showError) withObject:nil afterDelay:4];
            } else if (self.playerController.player.status == AVPlayerStatusFailed){
                LOG(@"PLAYER NOTIFICATION: ERROR");
                [self addEmergencyExitButton:nil];
            } else {
                LOG(@"PLAYER NOTIFICATION: 2.ERROR");
                [self addEmergencyExitButton:nil];
            }
        } else         if ([keyPath isEqualToString:@"error"]) {
            LOG(@"PLAYER NOTIFICATION: 3.ERROR: %@", self.playerController.player.error);
            [self addEmergencyExitButton:nil];
        }
    }
}

-(void)checkVideoOnLineAvailability:(NSString *)urlString {
    Data_Loader * aDataLoader = [Data_Loader new];
    aDataLoader.delegate = self;
    aDataLoader.actionName = @"reachURL_available";
    aDataLoader.currentUrl = urlString;
    aDataLoader.returnData = NO;
    aDataLoader.aTarget = self;
    aDataLoader.object = nil;
    aDataLoader.parameter = nil;
    aDataLoader.checkOnlyAvailableURL_then_exit = YES;
    
    NSMutableURLRequest *request = nil;
    NSTimeInterval tOut = 3.0;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:aDataLoader.currentUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:tOut];
    
    [aDataLoader loadAsyncRequest:request];
}

-(void)showError{
    LOG(@"PLAYER NOTIFICATION: 4.ERROR: %@", self.playerController.player.error);
    if (self.playerController.player.error) {
        [self addEmergencyExitButton:nil];
    }
    if (self.playerController.player.status == AVPlayerStatusReadyToPlay) {
        [self addEmergencyExitButton:nil];
    }
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
        [self.playerController.view addSubview:self.emergencyExit];
        self.emergencyExit.hidden = YES;
        
        self.quizView.alpha = 0;
        self.quizView.hidden = YES;
        AppDelegate* appD = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        appD.restrictRotation = UIInterfaceOrientationMaskLandscape;
    }
}

-(void)addPlayer:(AVPlayerViewController*)aPlayerVC withFile:(MoviesAndWords_MovieObj*)aMovieobj{
    NSString* aMovieFileName = aMovieobj.name;
    NSURL*  url = nil;
  //  BOOL useWeb = (self.webVideoIncluded.tag == 0);
    LOG(@"PLAY NEW FILE:::::: %@", aMovieobj);

    if ([aMovieobj getType] == MovieSourceType_web) {
        NSString* temp_fileName = [aMovieFileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        temp_fileName = [NSString stringWithFormat:@"https://meronix.altervista.org/mastroPietro/%@.mp4", temp_fileName];
        url = [NSURL URLWithString:temp_fileName];
        [self checkVideoOnLineAvailability:temp_fileName];
        LOG(@"PLAY NEW FILE URL :::::: %@", url);
    } else {
        url = [[NSBundle mainBundle] URLForResource:aMovieFileName withExtension:@"mp4"];
    }
 
    if (!url) {
        [self addEmergencyExitButton:nil];
        return;
    }
    
    AVPlayer*  player = [AVPlayer playerWithURL:url];
    aPlayerVC.player = player;
    //    AVPlayer* player = aPlayerVC.player;
    //    AVPlayerItem* aNewTestItem = [[AVPlayerItem alloc] initWithURL:url];
    //  [self.playerController.player replaceCurrentItemWithPlayerItem:aNewTestItem];
    
    aPlayerVC.showsPlaybackControls = false;
    self.emergencyExit.hidden = YES;
    
    //    NSLog(@"Text: %@", self.navigationController);
}

-(void) playerItemDidReachEnd:(NSNotification*)notification {
    //Dismiss AVPlayerViewController
    LOG(@"Text: %@", notification);
    LOG(@"Text: %@", notification.class);
    
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

-(void) addEmergencyExitButton:(NSNotification*)notification {
    //Dismiss AVPlayerViewController
    LOG(@"self.emergencyExit: %@", self.emergencyExit);
    LOG(@"self.emergencyExit super: %@", self.emergencyExit.superview);
    [self.playerController.view addSubview:self.emergencyExit];
    
    self.emergencyExit.hidden = NO;
    
//    _quizView.hidden = false;
//    self.quizView.alpha = 1;
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
    LOG(@"sender: %@", sender);
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
        self.boxMessage.backgroundColor = _greenColor;
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
                 aButt.backgroundColor = self.greenColor;
            }
        }
        self.boxMessage.backgroundColor = sender.backgroundColor;

        
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
    [self.playerController.player pause];
    self.toBePlayedMovies = nil;
    [self.view addSubview:self.quizView];
    [self.emergencyExit removeFromSuperview];
    
    if (_answers_total > 0) {
        CGFloat percent = (100.0 * _answers_correct) / _answers_total;
        if (percent >= 50) {
            self.initialMessageLabel.text = [NSString stringWithFormat:@"Complimenti, hai risposto al %.0f\%% delle domande!\nCondividi questo risultato.        \n", percent];
        } else {
            self.initialMessageLabel.text = [NSString stringWithFormat:@"Hai risposto al %.0f\%% delle domande!\nCondividi questo risultato.        \n", percent];
        }
        self.shareButton.hidden = NO;
        self.initialMessageLabel.hidden = NO;
    }
    self.quizView.alpha = 0;
    self.quizView.hidden = YES;
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)replayButton:(UIButton *)sender {
    self.quizView.alpha = 0;
    self.quizView.hidden = YES;
    self.playerController.showsPlaybackControls = false;

    AVPlayer* player = self.playerController.player;
    AVPlayerItem* videoItem = player.currentItem;
    [videoItem seekToTime:kCMTimeZero completionHandler:nil];
    if ([player respondsToSelector:@selector(setAutomaticallyWaitsToMinimizeStalling:)]) {
        //        player.automaticallyWaitsToMinimizeStalling = NO;
        //        [player playImmediatelyAtRate:1];
    }
    [player play];
}

-(void)nextLevel_playAnswer:(BOOL)showAnswer withCorrectAnswer:(BOOL)correctAnswer{
    MoviesAndWords_MovieObj* nextMovieObj = nil;
    if (showAnswer) {
        NSMutableArray* tempListaRisposte = nil;
        if (correctAnswer) {
            tempListaRisposte = [self.myMoviesAndWords_local.listaRisposteOK.movieObj mutableCopy];
            if (_myMoviesAndWords_web && _myMoviesAndWords_web.listaRisposteOK.movieObj.count) {
                [tempListaRisposte addObjectsFromArray:_myMoviesAndWords_web.listaRisposteOK.movieObj];
            }
        } else {
            tempListaRisposte = [self.myMoviesAndWords_local.listaRisposteKO.movieObj mutableCopy];
            if (_myMoviesAndWords_web && _myMoviesAndWords_web.listaRisposteKO.movieObj.count) {
                [tempListaRisposte addObjectsFromArray:_myMoviesAndWords_web.listaRisposteKO.movieObj];
            }
        }
        nextMovieObj = [self getNextMovieObjInList:tempListaRisposte andRemove:NO];
        
        self.message.text = [NSString stringWithFormat:@"%@", nextMovieObj.name];
        self.currentWord = nil;
    } else {
        if (_toBePlayedMovies.count == 0) {
            [self exitButton:nil];
            return;
        }
        nextMovieObj = [self getNextMovieObjInList:_toBePlayedMovies andRemove:YES];
        self.quizView.alpha = 0;
        self.quizView.hidden = YES;
        self.currentWord = nextMovieObj.name;
        [self loadQuestionButtons];
    }
    
    [self addPlayer:_playerController withFile:nextMovieObj];
    AVPlayer* player = self.playerController.player;
    
    if ([player respondsToSelector:@selector(setAutomaticallyWaitsToMinimizeStalling:)]) {
//                player.automaticallyWaitsToMinimizeStalling = NO;
//                [player playImmediatelyAtRate:1];
    }
    self.playerController.showsPlaybackControls = false;
    
//    [self.playerController.player addObserver:self
//    forKeyPath:@"status"
//       options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
//       context:nil];

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
    
    NSMutableArray * tempArrayWords = [self.myMoviesAndWords_local.wrongWords mutableCopy];
    if (_myMoviesAndWords_web && _myMoviesAndWords_web.wrongWords.count > 0) {
        [tempArrayWords addObjectsFromArray:_myMoviesAndWords_web.wrongWords];
    }
    for (UIButton* aButt in tempArray) {
        if ( aButt.tag == 0 ) {
            [aButt setTitle:[self getRandomNameInList:tempArrayWords andRemove:YES] forState:UIControlStateNormal];
        }
    }
    
    
    
    //   }
}

-(MoviesAndWords_MovieObj*) getNextMovieObjInList:(NSArray*)inputMovieObjArray andRemove:(BOOL)andRemove{
    MoviesAndWords_MovieObj* nextMovieObj = nil;
    
    if (inputMovieObjArray.count) {
        int index = arc4random() % inputMovieObjArray.count;
        nextMovieObj = inputMovieObjArray[index];
        LOG(@"nextWord: %@", nextMovieObj);

        if (andRemove) {
            if ([inputMovieObjArray.class isSubclassOfClass:NSMutableArray.class]) {
                NSMutableArray* aliasArrayMutable = (NSMutableArray*)inputMovieObjArray;
                [aliasArrayMutable removeObjectAtIndex:index];
            }
        }
    }
    return nextMovieObj;
}

-(NSString*) getRandomNameInList:(NSArray*)inStringArray andRemove:(BOOL)andRemove{
    NSString* nextWord = @"***";
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


-(void)loadJsonData{
    NSString *fileLocation = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"listaMovie.json"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileLocation]){
        LOG(@"%s %@ doesn't exist",__PRETTY_FUNCTION__,fileLocation);
        return;
    }
    NSMutableData * data = [NSMutableData dataWithContentsOfFile:fileLocation];
    
    if (data) {
        NSDictionary* returnedDictionary = [Data_Loader getDictionaryByData:data];
        if (returnedDictionary) {
            MoviesAndWords_Main * retBean = [MoviesAndWords_Main modelObjectWithDictionary:returnedDictionary];
            LOG(@"retBean listaMovie: %@", retBean.listaMovie);
            LOG(@"retBean wrongWords: %@", retBean.wrongWords);
            LOG(@"retBean: %@", retBean);
            self.myMoviesAndWords_local = retBean;
        }
    }
}

-(IBAction)cretitAlert:(id)sender {
    NSString * message = @"Additional sound effects from \nhttps://www.zapsplat.com";
    UIAlertController* aPopUp = [UIAlertController alertControllerWithTitle:@"Credits" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* anAction = [UIAlertAction actionWithTitle:@"chiudi" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [aPopUp dismissViewControllerAnimated:YES completion:nil];
    }];
    [aPopUp addAction:anAction];
    
    [self presentViewController:aPopUp animated:YES completion:nil];
    
//    let save = UIAlertAction(title: "SalvaButton".localized, style: .default) {
//        (alertAction) in
//            CoreDataManager.getSharedInstance().checkAndSaveConfiguration(withName: withName, askAndStopIfExists: false)
//     }
//
//    //Cancel action
//    let cancel = UIAlertAction(title: "AnnullaButton".localized, style: .cancel) { (alertAction) in }
//    alert.addAction(cancel)
//    alert.addAction(save)
//    self.present(alert, animated:true, completion: nil)

}

-(IBAction)shareAction:(id)sender {
    NSMutableArray *selDocs = [[NSMutableArray alloc] init];
    // add image
    UIImage * tempImage = [UIImage imageNamed:@"reload.png"];
    if (tempImage) {
        [selDocs addObject:tempImage];
    }
    
    // add string
    CGFloat percent = (100.0 * _answers_correct) / _answers_total;
    NSString * sharedMessage  = [NSString stringWithFormat:@"Ho appenna giocato con l'app 'Mastro Pietro' e ho risposto al %.0f \%% delle domande!\n\n https://www.apple.com \n", percent];
    [selDocs addObject:sharedMessage];
    // [selDocs addObject:@"\n COMPLIMENTI! \n"];
    
    // add link
    NSURL *fileUrl = [NSURL URLWithString:@"http://www.apple.com"];
    if (fileUrl) {
        // [selDocs addObject:fileUrl];
    }
    
    NSArray *postItems = [NSArray arrayWithArray:selDocs];
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    
    // add subject in case of email
    [avc setValue:@"Mastro Pietro: test eseguito da con successo" forKey:@"subject"];
    
    avc.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        NSLog(@"Activity Type selected: %@", activityType);
        if (completed) {
            NSLog(@"Selected activity was performed.");
        } else {
            if (activityType == NULL) {
                NSLog(@"User dismissed the view controller without making a selection.");
            } else {
                NSLog(@"Activity was not performed.");
            }
        }
    };
    avc.popoverPresentationController.sourceView = self.view;
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - dataLoader

// START
-(void)tryToDownloadWebList {
    //    Reachability *reach = [Reachability reachabilityWithHostName:@"meronix.altervista.org"];
    //    BOOL reachable = [reach isReachable];
    //    if (reachable) {
    NSString* webList = @"https://meronix.altervista.org/mastroPietro/listaMovie_web.json";
    NSURL *completeUrl = [NSURL URLWithString:webList];
    if (completeUrl) {
        Data_Loader * aDataLoader = [Data_Loader new];
        aDataLoader.delegate = self;
        aDataLoader.actionName = @"listaMovie_web";
        aDataLoader.currentUrl = webList;
        aDataLoader.object = nil;
        aDataLoader.parameter = nil;
        aDataLoader.timeOut = 8;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[completeUrl standardizedURL]];
        request.timeoutInterval = aDataLoader.timeOut;
        [request setHTTPMethod:@"GET"];
        [aDataLoader loadAsyncRequest:request];
    }
    //    }
}

// returned data management:
-(void)dataLoaderDidFinishToLoad:(Data_Loader *)aDataLoader{
    NSData *data = aDataLoader.responseData;
    NSString* actionName = aDataLoader.actionName;
    if (data) {
        NSDictionary* returnedDictionary = [Data_Loader getDictionaryByData:data];
        if (returnedDictionary) {
            if ([actionName isEqualToString:@"listaMovie_web"]) {
                LOG(@"%@",returnedDictionary);
                MoviesAndWords_Main *bean = [MoviesAndWords_Main modelObjectWithDictionary:returnedDictionary];
                if (bean) {
                    LOG(@"%@",bean);
                    self.myMoviesAndWords_web_stored = bean;
                    self.boxView_addWeb.userInteractionEnabled = YES;
                    self.boxView_addWeb.alpha = 1;
                    // self.toBePlayedMovies = [self.myMoviesAndWords_local.listaMovie mutableCopy];
                } else {
                    NSString *error = @"Bean Sbagliato, non parsato correttamente";
                    [self setErrorState:error withErrorCode:@"bho" forDataLoader:aDataLoader];
                }
            }
        } else {
            [self setErrorState:@"dictionary Sbagliato, non parsato correttamente" withErrorCode:nil forDataLoader:aDataLoader];
        }
        
    } else {
        [self setErrorState:nil withErrorCode:nil forDataLoader:aDataLoader];
    }
}

-(void)dataLoaderDidFailToLoad:(Data_Loader*)aDataLoader{
    if (aDataLoader.checkOnlyAvailableURL_then_exit) {
        // IN CASO DI CHECK per VIDEO RAGGIUNGIBILE: con errore
        [self addEmergencyExitButton:nil];
        [self performSelector:@selector(addEmergencyExitButton:) withObject:nil afterDelay:2];
        [self performSelector:@selector(addEmergencyExitButton:) withObject:nil afterDelay:4];
        return;
    }

    NSString* actionName = aDataLoader.actionName;
    NSError *error = aDataLoader.downloadError;
    LOG(@"dataLoaderDidFailToLoad : actionName %@", actionName);
    LOG(@"dataLoaderDidFailToLoad : ERROR %@", error);
    
    NSString* errorMessage = error.localizedDescription;
    NSString* errorCode = [NSString stringWithFormat:@"%ld", (long)error.code];
    [self setErrorState:errorMessage withErrorCode:errorCode forDataLoader:aDataLoader];
}

-(void)setErrorState:(NSString*)errorMessage withErrorCode:(NSString*)errorCode forDataLoader:(Data_Loader*)aDataLoader{
    LOG(@"retrieve an error for Rest Service: %@", errorMessage);
    if (!errorCode) {
        errorCode = @"GENERIC_ERROR";
    }
    aDataLoader.delegate = nil;
    [aDataLoader.connection cancel];
}


@end
