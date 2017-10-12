//
//  VideoViewController.m
//  IVPlayer
//
//  Created by nbd on 2017/10/11.
//  Copyright © 2017年 IV. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FileManager.h"



@interface VideoViewController (){
    NSInteger _videoDuration;
    BOOL _isFullScreen;
}

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoViewHeight;


@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initPlayer];
    
    _videoViewWidth.constant = SCREEN_WIDTH;
    _videoViewHeight.constant = SCREEN_WIDTH / 2;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}          

- (NSString *)secondToMS:(CMTime) time {
    NSInteger duration = CMTimeGetSeconds(time);
    return [self ms:duration];
}

- (NSString *)ms:(NSInteger) duration {
    NSInteger min = duration / 60;
    NSInteger sec = duration % 60;
    return [NSString stringWithFormat:@"%ld:%ld", min, sec];
}

#pragma mark - initPlayer
- (void)initPlayer {
    if (!_fileName) {
        return;
    }
    
    if (!self.player) {
        NSString *path = [[[FileManager shareInstance] fileDirPath] stringByAppendingString:_fileName];
        NSURL *url = [NSURL fileURLWithPath:path];
        __block AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        _player= [AVPlayer playerWithPlayerItem:playerItem];
        self.videoTimeLabel.text = [self secondToMS:playerItem.asset.duration];
        _videoDuration = CMTimeGetSeconds(playerItem.asset.duration);
        
        CMTime interval = CMTimeMake(1, 1);
        __weak VideoViewController *weakSelf = self;
        [_player addPeriodicTimeObserverForInterval:interval
                                              queue:dispatch_get_current_queue()
                                         usingBlock:^(CMTime time) {
                                             float durationTime = CMTimeGetSeconds(playerItem.duration);
                                             float currentTime = CMTimeGetSeconds(playerItem.currentTime);
                                             float rate = currentTime / durationTime;
                                             weakSelf.progressSlider.value = rate;
                                             weakSelf.currentTimeLabel.text = [weakSelf secondToMS:playerItem.currentTime];
                                         }];
    }
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    _playerLayer.frame = self.videoView.bounds;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.videoView.layer addSublayer:_playerLayer];
    [self.videoView bringSubviewToFront:self.backButton];
    
    [_player play];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    if (_videoDuration == 0) {
        return;
    }
    
    float rate = sender.value;
    NSInteger currentTime = rate * _videoDuration;
    self.currentTimeLabel.text = [self ms:currentTime];
    
    CMTime time = CMTimeMake(currentTime, 1);
    [_player seekToTime:time];
}

- (IBAction)fullScreen:(id)sender {
    [self fullScreenWithDirection];
    self.backButton.hidden = NO;
    
}

- (IBAction)backAction:(UIButton *)sender {
    self.backButton.hidden = YES;
//    [self.videoView removeFromSuperview];
    
    self.videoView.transform = CGAffineTransformIdentity;
//    self.videoView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH/2);
//    self.playerLayer.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH/2);;
    [self.view addSubview:self.videoView];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - 全屏按钮响应事件
- (void)maxAction:(UIButton *)button
{
    if (_isFullScreen == NO)
    {
        [self fullScreenWithDirection];
    }
    else
    {
//        [self originalscreen];
    }
}
#pragma mark - 全屏
- (void)fullScreenWithDirection
{
    //记录播放器父类
//    _fatherView = self.superview;
    
    _isFullScreen = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //添加到Window上
    [self.videoView.window addSubview:self.videoView];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.videoView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }];
    
    self.videoViewWidth.constant = SCREEN_WIDTH;
    self.videoViewHeight.constant = SCREEN_HEIGHT;
    _playerLayer.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
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
