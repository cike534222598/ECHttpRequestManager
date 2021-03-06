//
//  ECViewController.m
//  ECHttpRequestManager
//
//  Created by Jame on 09/18/2016.
//  Copyright (c) 2016 Jame. All rights reserved.
//

#import "ECViewController.h"
#import "ECHttpRequestManager.h"

@interface ECViewController ()

@property (weak, nonatomic) IBOutlet UITextView *networkData;
@property (weak, nonatomic) IBOutlet UITextView *cacheData;
@property (weak, nonatomic) IBOutlet UILabel *cacheStatus;
@property (weak, nonatomic) IBOutlet UISwitch *cacheSwitch;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

/** 是否开启缓存*/
@property (nonatomic, assign, getter=isCache) BOOL cache;

/** 是否开始下载*/
@property (nonatomic, assign, getter=isDownload) BOOL download;

@property (nonatomic, copy) NSString *getUrl;
@property (nonatomic, copy) NSString *postUrl;
@property (nonatomic, copy) NSDictionary *postParam;
@property (nonatomic, copy) NSString *downloadUrl;

@end

@implementation ECViewController


- (NSString *)getUrl
{
    if (!_getUrl) {
        _getUrl = @"http://api.douban.com/v2/movie/top250?apikey=02d830457f4a8f6d088890d07ddfae47";
    }
    return _getUrl;
}


- (NSString *)postUrl
{
    if (!_postUrl) {
        _postUrl = @"http://api.douban.com/v2/movie/top250";
    }
    return _postUrl;
}

- (NSDictionary *)postParam
{
    if (!_postParam) {
        _postParam = @{
                       @"apikey":@"02d830457f4a8f6d088890d07ddfae47"
                       };
    }
    return _postParam;
}

- (NSString *)downloadUrl
{
    if (!_downloadUrl) {
        _downloadUrl = @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4";
    }
    return _downloadUrl;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [ECHttpRequestManager networkStatusWithBlock:^(ECHttpRequestStatus status) {
        switch (status) {
            case ECHttpRequestStatusUnknown:
            case ECHttpRequestStatusNotReachable: {
                self.networkData.text = @"没有网络";
                [self getData:YES url:self.getUrl];
                NSLog(@"无网络,加载缓存数据");
                break;
            }
            case ECHttpRequestStatusReachableViaWWAN:
            case ECHttpRequestStatusReachableViaWiFi: {
                [self getData:[[NSUserDefaults standardUserDefaults] boolForKey:@"isOn"] url:self.getUrl];
                NSLog(@"有网络,请求网络数据");
                break;
            }
        }
    }];

}


- (void)getData:(BOOL)isOn url:(NSString *)url
{
    
    NSString *str = @"123456";
    [str encode];
    //自动缓存
    if(isOn)
    {
        self.cacheStatus.text = @"缓存打开";
        self.cacheSwitch.on = YES;
        [ECHttpRequestManager GET:url parameters:nil responseCache:^(id responseCache) {
            
            NSLog(@"缓存 : %@",responseCache);
            self.cacheData.text = [self jsonToString:responseCache];
            
        } success:^(id responseObject) {
            
            self.networkData.text = [self jsonToString:responseObject];
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    //无缓存
    else
    {
        self.cacheStatus.text = @"缓存关闭";
        self.cacheSwitch.on = NO;
        self.cacheData.text = @"";
        
        [ECHttpRequestManager GET:url parameters:nil success:^(id responseObject) {
            
            self.networkData.text = [self jsonToString:responseObject];
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

#pragma mark - 下载

- (IBAction)download:(UIButton *)sender {
    
    static NSURLSessionTask *task = nil;
    //开始下载
    if(!self.isDownload)
    {
        self.download = YES;
        [self.downloadBtn setTitle:@"取消下载" forState:UIControlStateNormal];
        
        task = [ECHttpRequestManager downloadWithURL:self.downloadUrl fileDir:@"Download" progress:^(NSProgress *progress) {
            
            CGFloat stauts = 100.f * progress.completedUnitCount/progress.totalUnitCount;
            
            //在主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progress.progress = stauts/100.f;
            });
            
            NSLog(@"下载进度 :%.2f%%,,%@",stauts,[NSThread currentThread]);
        } success:^(NSString *filePath) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载完成!"
                                                                message:[NSString stringWithFormat:@"文件路径:%@",filePath]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            [self.downloadBtn setTitle:@"重新下载" forState:UIControlStateNormal];
            NSLog(@"filePath = %@",filePath);
            
        } failure:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            NSLog(@"error = %@",error);
        }];
        
    }
    //暂停下载
    else
    {
        self.download = NO;
        [task suspend];
        self.progress.progress = 0;
        [self.downloadBtn setTitle:@"开始下载" forState:UIControlStateNormal];
    }
    
}

#pragma mark - 缓存开关
- (IBAction)isCache:(UISwitch *)sender {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:sender.isOn forKey:@"isOn"];
    [userDefault synchronize];
    
    [self getData:sender.isOn url:self.getUrl];
}

/**
 *  json转字符串
 */
- (NSString *)jsonToString:(NSDictionary *)dic
{
    if(!dic){
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
