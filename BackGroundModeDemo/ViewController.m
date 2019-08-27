//
//  ViewController.m
//  BackGroundModeDemo
//
//  Created by BaoBaoDaRen on 2019/8/27.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self navUI];
    
    [self showUI];
    
    [self registBackgroundPlayMode];

}
- (void)registBackgroundPlayMode
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
}
- (void)showUI
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    btn.center = self.view.center;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btn.frame.size.height / 2;
    [btn setTitle:@"播放" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(playMusicBegin) forControlEvents:UIControlEventTouchUpInside];


}
- (void)playMusicBegin
{
    if (self.player.isPlaying) {
        
        [self.player pause];
    } else {
        
        [self.player prepareToPlay];
        [self.player play];
    }
}
- (AVAudioPlayer *)player
{
    if (!_player) {
        
        NSString *musicUrl = [[NSBundle mainBundle] pathForResource:@"windy" ofType:@"mp3"];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:musicUrl] error:nil];
        //设置循环次数，如果为负数，就是无限循环
        _player.numberOfLoops = -1;
//        _player.volume = 0;//静音播放...
    }
    return _player;
}
- (void)navUI
{
    self.title = @"开启无限后台模式";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterbackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
- (void)playerFinishedPlay:(NSNotification *)notify
{
    self.player.currentTime = 0;

    [self.player prepareToPlay];
    [self.player play];
}
// TODO: 前台...
- (void)willEnterForeground:(NSNotification *)notify
{
    
}
// TODO: 后台...
- (void)didEnterbackground:(NSNotification *)notify
{
    
}

@end
