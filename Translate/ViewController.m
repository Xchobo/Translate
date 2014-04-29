//
//  ViewController.m
//  Translate
//
//  Created by Xchobo on 2014/4/28.
//  Copyright (c) 2014年 Xchobo. All rights reserved.
//

#import "ViewController.h"
#import "MSTranslateAccessTokenRequester.h"
#import "MSTranslateVendor.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()

@property (strong, nonatomic) MSTranslateVendor *vendor;
//翻譯
@property (strong, nonatomic) IBOutlet UITextField *translateFrom;
@property (strong, nonatomic) IBOutlet UILabel *translateTO;
//判斷語系
@property (strong, nonatomic) IBOutlet UITextField *detectText;
@property (strong, nonatomic) IBOutlet UILabel *detectTextLabel;
//語音
@property (strong, nonatomic) IBOutlet UITextField *speakingText;
@property (strong, nonatomic) AVAudioPlayer *player;
//字數查詢
@property (strong, nonatomic) IBOutlet UITextView *breakSentences;

- (IBAction)requestTranslate:(id)sender;//翻譯
- (IBAction)requestDetectTextLanguage:(id)sender;//判斷語系
- (IBAction)requestSpeakingText:(id)sender;//語音
- (IBAction)requestBreakSentences:(id)sender;//字數查詢
- (IBAction)requestTranslateArray:(id)sender;//大量文字翻譯

- (IBAction)disableKeyboard:(id)sender; //取消鍵盤



@end

@implementation ViewController

#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [[MSTranslateAccessTokenRequester sharedRequester] requestSynchronousAccessToken:CLIENT_ID clientSecret:CLIENT_SECRET];
    _vendor = [[MSTranslateVendor alloc] init];
}

//翻譯
- (IBAction)requestTranslate:(id)sender {
    NSLog(@"requestTranslate=%@", _vendor);
    
    [_vendor requestTranslate:[_translateFrom text] from:@"zh-CHT" to:@"en" blockWithSuccess:^(NSString *translatedText)
     {
         NSLog(@"requestTranslate1");
         NSLog(@"translatedText: %@", translatedText);
         [_translateTO setText:translatedText];
     }
                     failure:^(NSError *error)
     {
         NSLog(@"requestTranslate2");
         NSLog(@"error_translate: %@", error);
     }];
}

//判斷語系
- (IBAction)requestDetectTextLanguage:(id)sender {
    NSLog(@"requestDetectTextLanguage");
    [_vendor requestDetectTextLanguage:[_detectText text] blockWithSuccess:^(NSString *language)
     {
         NSLog(@"language:%@", language);
         [_detectTextLabel setText:language];
     }
                              failure:
     ^(NSError *error)
     {
         NSLog(@"error_language: %@", error);
     }];
}

//語音
- (IBAction)requestSpeakingText:(id)sender {
    NSLog(@"requestSpeakingText");
    [_vendor requestSpeakingText:[_speakingText text] language:@"en" blockWithSuccess:^(NSData *streamData)
     {
         NSError *error;
         self.player = [[AVAudioPlayer alloc] initWithData:streamData error:&error];
         [_player play];
     }
                        failure:
     ^(NSError *error)
     {
         NSLog(@"error_speak: %@", error);
     }];
}

//字數查詢
- (IBAction)requestBreakSentences:(id)sender {
    NSLog(@"requestBreakSentences");
    [_vendor requestBreakSentences:[_breakSentences text]
                          language:@"en" blockWithSuccess:^(NSDictionary *sentencesDict)
     {
         NSLog(@"sentences_dict:%@", sentencesDict);
     }
                           failure:^(NSError *error)
     {
         
     }];
}

//大量文字翻譯
- (IBAction)requestTranslateArray:(id)sender {
    NSLog(@"requestTranslateArray");
    [_vendor requestTranslateArray:@[@"飛機", @"汽車", @"腳踏車"] from: @"zh-CHT" to:@"en" blockWithSuccess:^(NSArray *translatedTextArray)
     {
         
         NSLog(@"translatedTextArray:%@", translatedTextArray);
     } failure:^(NSError *error) {
         
     }];
}

- (IBAction)disableKeyboard:(id)sender {
}
@end
