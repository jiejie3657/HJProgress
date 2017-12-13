//
//  ViewController.m
//  HJProgress
//
//  Created by 何杰 on 2017/12/13.
//  Copyright © 2017年 kerrey. All rights reserved.
//

#import "ViewController.h"
#import "HJProgressView.h"
#import "HJProgressView2.h"

@interface ViewController ()
@property (strong, nonatomic) HJProgressView * progress;
@property (strong, nonatomic) HJProgressView2 * progressV;

@property (assign, nonatomic) double usedMoney;
@property (assign, nonatomic) double maxMoney;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.progress.hidden = NO;
    self.progressV.hidden = NO;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark getter
- (HJProgressView *)progress{
    if(!_progress){
        _progress = [[HJProgressView alloc] initWithFrame:CGRectMake(15,200, self.view.frame.size.width - 30, 34) maxNumber:5000.00 usedNumber:2000.00];
        [self.view addSubview:_progress];
    }
    [_progress updateProgressPercent:10000.00 usedNumber:5000.00];
    return _progress;
}

- (HJProgressView2 *)progressV{
    if(!_progressV){
        _progressV = [[HJProgressView2 alloc] initWithFrame:CGRectMake(15,400, self.view.frame.size.width - 30, 45) joinNumber:5000.00 voteCount:1000.00];
        [self.view addSubview:_progressV];
    }
    
    [_progressV setProgressPercent:5000.00 voteCount:1000.00];

    return _progressV;
}


@end
