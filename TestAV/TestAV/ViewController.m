//
//  ViewController.m
//  TestAV
//
//  Created by xy on 2019/3/14.
//  Copyright © 2019年 xy. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
@property (nonatomic, strong)AVAudioRecorder *recorder;
@property (nonatomic, strong)AVAudioPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSString *directoryStr = [self getRecorderDirectoryPath];
//    NSLog(@"directoryStr = %@",directoryStr);
//    if (!directoryStr) {
//        return;
//    }
//    NSString *filePath = [directoryStr stringByAppendingPathComponent:@"d.caf"];
//
//    NSURL *recorderUrl = [NSURL fileURLWithPath:filePath];
//
//    NSError *audioError = nil;
//    NSDictionary *useDic = [self recordSetting];
//    AVAudioRecorder *recorder = [[AVAudioRecorder alloc]initWithURL:recorderUrl settings:useDic error:&audioError];
//    recorder.delegate = self;
//    [recorder prepareToRecord];
//
//    self.recorder = recorder;
//
    
//    NSError *playerError = nil;
//    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:recorderUrl error:&playerError];
//    player.delegate = self;
//    [player prepareToPlay];
//    self.player = player;
    
    
    
}
- (IBAction)recordBegin:(id)sender {
    
    NSLog(@"开始");
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance]recordPermission];
    
    switch (permission) {
        case AVAudioSessionRecordPermissionDenied:{
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication]openURL:settingUrl];
            break;
        }
        case AVAudioSessionRecordPermissionGranted:{
            [self.recorder record];
            break;
        }
        case AVAudioSessionRecordPermissionUndetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted == YES) {
                    [self.recorder record];
                }
            }];
            break;
        }
        default:
            break;
    }
    
}

- (IBAction)recordEnd:(id)sender {
    
    NSLog(@"结束");
    if ([self.recorder isRecording] == YES) {
        [self.recorder stop];
    }
    
}
- (IBAction)playerBegin:(id)sender {
    
    //[self.player play];
    
    NSString *directoryStr = [self getRecorderDirectoryPath];
    NSLog(@"directoryStr = %@",directoryStr);
    if (!directoryStr) {
        return;
    }
    NSString *filePath = [directoryStr stringByAppendingPathComponent:@"b.caf"];
    
    NSURL *recorderUrl = [NSURL fileURLWithPath:filePath];
    
    SystemSoundID useId = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)recorderUrl, &useId);
    
    AudioServicesPlaySystemSoundWithCompletion(useId, ^{
        NSLog(@"播放完成");
        AudioServicesDisposeSystemSoundID(useId);
    });
}

- (NSString *)getRecorderDirectoryPath {
    
    NSString *documentStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *useStr = [documentStr stringByAppendingPathComponent:@"UseRecord"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDirectory = YES;
    BOOL isDirectoryExist = [manager fileExistsAtPath:useStr isDirectory:&isDirectory];
    if (isDirectoryExist == YES) {
        return useStr;
    }
    
    NSError *createError = nil;
    [manager createDirectoryAtPath:useStr withIntermediateDirectories:YES attributes:nil error:&createError];
    if (!createError) {
        return useStr;
    }
    return @"";
}

- (NSDictionary *)recordSetting {
    NSMutableDictionary *recSetting = [[NSMutableDictionary alloc] init];
    recSetting[AVFormatIDKey] = @(kAudioFormatLinearPCM);
    recSetting[AVSampleRateKey] = @44100;//采样率 441000 48000
    recSetting[AVNumberOfChannelsKey] = @2;//声道数 1或者2
    recSetting[AVLinearPCMBitDepthKey] = @24;//比特率
    recSetting[AVLinearPCMIsBigEndianKey] = @YES;
    recSetting[AVLinearPCMIsFloatKey] = @YES;
    recSetting[AVEncoderAudioQualityKey] = @(AVAudioQualityMedium);//声音质量
    recSetting[AVEncoderBitRateKey] = @128000;//编码比特率
    return [recSetting copy];
}

#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    NSLog(@"flag = %d",flag);
    NSLog(@"currentTime = %f,deviceCurrentTime = %f",recorder.currentTime,recorder.deviceCurrentTime);
//    if (self.recorder ) {
//        <#statements#>
//    }
}

#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    NSLog(@"flag = %d",flag);
    
}
@end
