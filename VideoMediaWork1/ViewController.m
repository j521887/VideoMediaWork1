//
//  ViewController.m
//  VideoMediaWork1
//
//  Created by Des on 16/5/16.
//  Copyright © 2016年 WJC. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HIGHT [UIScreen mainScreen].bounds.size.height

static NSString *const URLS=@"http://wscdn.miaopai.com/splayer2.1.5.swf?scid=Fc2iFZClOjk79BMHTYXwfQ__&token=&autopause=false&fromweibo=false";
static NSString *const URLS2=@"http://dlhls.cdn.zhanqi.tv/zqlive/2766_OUCz5.m3u8";
static NSString *const URLS3=@"http://dlhls.cdn.zhanqi.tv/zqlive/76451_y0Orl.m3u8";

@interface ViewController ()
{
    BOOL isPlay;//是否播放
}
@property (strong,nonatomic) UIView   *playView;
@property (strong,nonatomic) AVPlayer *player;
@property (strong,nonatomic) AVPlayerLayer *playerLayer;
@property (strong,nonatomic) AVPlayerItem  *item;
@property (strong,nonatomic) UIToolbar *toobar;
@property (strong,nonatomic) UISlider  *silder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isPlay=NO;
    //实例化
    _playView=[[UIView alloc] initWithFrame:CGRectMake(0, 64,375, 380*9/16)];
    _playView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_playView];
    
    _item=[[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:URLS3]];
    _player=[[AVPlayer alloc] initWithPlayerItem:_item];
    
    
    _playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame=CGRectMake(0, 0, _playView.frame.size.width, _playView.frame.size.height);
    _playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
    [_playView.layer addSublayer:_playerLayer];

    //添加播放器下面的tool
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showToolView)];
    [self.playView addGestureRecognizer:tap];

    if(!_toobar)
    {
        _toobar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, _playView.frame.size.height-40, _playView.frame.size.width, 40)];
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        button.selected=NO;
        [button addTarget:self action:@selector(isPlayOrPause) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
        
        UIButton *button1=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button1 setImage:[UIImage imageNamed:@"spin"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(retainPlay) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barItem1=[[UIBarButtonItem alloc] initWithCustomView:button1];
        
        
        _toobar.items=@[barItem,barItem1];
        [_playView addSubview:_toobar];
    }
    _toobar.hidden=NO;
    _toobar.barStyle=UIBarStyleBlackOpaque;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    
}

-(void)timer
{
    

}

//屏幕方向
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
   if([UIDevice currentDevice].orientation==UIDeviceOrientationPortrait)
   {
       NSLog(@"竖直");
       
       _toobar.hidden=YES;
       _playView.frame=CGRectMake(0, 64, 375, 380*9/16);
       _toobar.frame=CGRectMake(0, _playView.frame.size.height-40, _playView.frame.size.width, 40);
       _playerLayer.frame=CGRectMake(0, 0, _playView.frame.size.width, _playView.frame.size.height);
   }else if ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft){
       NSLog(@"水平向左");
       
       _toobar.hidden=YES;
       _playView.frame=CGRectMake(0, 0, SCREEN_HIGHT, SCREEN_WIDTH);
       _toobar.frame=CGRectMake(0, _playView.frame.size.height-40, _playView.frame.size.width, 40);
       _playerLayer.frame=CGRectMake(0, 0, _playView.frame.size.width, _playView.frame.size.height);
       
   }else if ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight){
   
        NSLog(@"水平向右");
       _toobar.hidden=YES;
       _playView.frame=CGRectMake(0, 0,SCREEN_HIGHT, SCREEN_WIDTH);
       _toobar.frame=CGRectMake(0, _playView.frame.size.height-40, _playView.frame.size.width, 40);
       _playerLayer.frame=CGRectMake(0, 0, _playView.frame.size.width, _playView.frame.size.height);
       
   }

}


//显示工具栏
-(void)showToolView
{
    if (_toobar.hidden) {
        _toobar.hidden = NO;
    }else{
        _toobar.hidden = YES;
    }
}

//重新播放
-(void)retainPlay
{
    _item=nil;
    _player=nil;
    [_playerLayer removeFromSuperlayer];
    
    _item=[[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:URLS3]];
    _player=[[AVPlayer alloc] initWithPlayerItem:_item];
    _playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, _playView.frame.size.width, _playView.frame.size.height);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [_playView.layer addSublayer:_playerLayer];
    _playerLayer.zPosition=10;
    _toobar.layer.zPosition=11;
    [_player play];
}


//播放或暂停
-(void)isPlayOrPause
{
    isPlay=!isPlay;
    UIBarButtonItem *barItem=_toobar.items[0];
    UIButton *but=(UIButton *)barItem.customView;
    if(isPlay)
    {
        but.selected=YES;
        [_player play];
    }
    else{
        
        but.selected=NO;
        [_player pause];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
