//
//  HJProgressView.m
//  FormaxCopyMaster
//
//  Created by 何杰 on 2017/3/16.
//  Copyright © 2017年 Formax. All rights reserved.
//

#import "HJProgressView2.h"

@interface HJProgressView2()
@property(strong,nonatomic) UIButton * againstPercentageBtn;
@property(strong,nonatomic) UIButton * supportPercentageBtn;
@property(strong,nonatomic) UILabel  * supportPercentageLab;
@property(strong,nonatomic) UILabel  * againstPercentageLab;
@property(strong,nonatomic) NSString * supportPercentageStr;
@property(strong,nonatomic) NSString * againstPercentageStr;

@property(strong,nonatomic) CAGradientLayer *lGradientLayer;
@property(strong,nonatomic) CAGradientLayer *rGradientLayer;
@property(strong,nonatomic) UIImageView     *progressImageV;

@property(nonatomic) float progressNum1;
@property(nonatomic) float progressNum2;
@property(nonatomic) int64_t joinNum;                //参与人数
@property(nonatomic) int64_t voteCount1;             //投票人数
@property(nonatomic) float progressBGVWidth;

@end

@implementation HJProgressView2



- (instancetype)initWithFrame:(CGRect)frame joinNumber:(int64_t)joinNumber voteCount:(int64_t)voteCount{
    self = [super initWithFrame:frame];
    if(self){
        [self initDataWithJoinNumber:joinNumber voteCount:voteCount];
        [self configUI:frame];
    }
    return self;
}

- (void)configUI:(CGRect)frame{
    self.backgroundColor = [UIColor whiteColor];
    [self initProgressViewWithFrame:frame];
}

/**
 *  设置初使数据
 */
- (void)initDataWithJoinNumber:(int64_t)joinNumber voteCount:(int64_t)voteCount{
    _joinNum = joinNumber;
    _voteCount1 = voteCount;
    float progressNum1 = 0;
    float progressNum2 = 0;
    if(joinNumber != 0){
        progressNum1 = voteCount*1.000/joinNumber;
        progressNum2 = 1 - progressNum1;
    }
    _progressNum1 = progressNum1;
    _progressNum2 = progressNum2;
    _supportPercentageStr = [[NSString stringWithFormat:@"%.0f",progressNum1*100] stringByAppendingString:@"%"];
    _againstPercentageStr = [[NSString stringWithFormat:@"%.0f",progressNum2*100] stringByAppendingString:@"%"];
}

/**
 *  暴露此方法  传入两个参数即可设置UI
 *
 *  @param joinNumber    总数
 *  @param voteCount     左方占比数
 */
-(void)setProgressPercent:(int64_t)joinNumber voteCount:(int64_t)voteCount{
    float progressNum1 = 0;
    float progressNum2 = 0;
    if(joinNumber != 0){
        progressNum1 = voteCount*1.000/joinNumber;
        progressNum2 = 1 - progressNum1;
    }
    _progressNum1 = progressNum1;
    _progressNum2 = progressNum2;
    _supportPercentageStr = [[NSString stringWithFormat:@"%.0f",progressNum1*100] stringByAppendingString:@"%"];
    _againstPercentageStr = [[NSString stringWithFormat:@"%.0f",progressNum2*100] stringByAppendingString:@"%"];
    [self updateProgressUI:progressNum1 progressNum2:progressNum2];
}

- (void)updateProgressUI:(float)progressNum1 progressNum2:(float)progressNum2{

    if(progressNum1 == 0 && progressNum2 == 0){
        progressNum1 = 0.50;
        progressNum2 = 0.50;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _supportPercentageLab.text = _supportPercentageStr;
        _againstPercentageLab.text = _againstPercentageStr;
        
        CGRect lgf = _lGradientLayer.frame;
        lgf.size.width = _progressBGVWidth*progressNum1;
        _lGradientLayer.frame = lgf;
        
        CGRect rgf = _rGradientLayer.frame;
        rgf.size.width = _progressBGVWidth - lgf.size.width;
        rgf.origin.x = lgf.size.width;
        _rGradientLayer.frame = rgf;
        
        CGRect pimgf = _progressImageV.frame;
        pimgf.origin.x = lgf.size.width - 4.5/2.0;
        _progressImageV.frame = pimgf;
    } completion:^(BOOL finished) {
    }];

    if(progressNum1 == 1 && progressNum2 ==0 )
        _progressImageV.hidden = YES;
    else if(progressNum1 == 0 && progressNum2 ==1 )
        _progressImageV.hidden = YES;
    else
        _progressImageV.hidden = NO;
}

-(UIView *)hjProgressView:(CGRect)frame{
    //背景长条
    UIView * progressBGV = [[UIView alloc ] initWithFrame:frame];
    progressBGV.backgroundColor =  [HJProgressView2 fmut_colorWithRGB:0xf3f3f3];
    
    CGFloat ProNum = _progressNum1;
    if(_progressNum1 == 0 && _progressNum2==0)
        ProNum = 0.5;//如果_progressNum=0 作50%显示
    
    CGFloat pheight  = 3.0;
    CGFloat porigny  = (frame.size.height-pheight)/2.0;
    CGFloat lwidth   = _progressBGVWidth * ProNum;
    CGFloat rwidth   = _progressBGVWidth - lwidth;
    
    CAGradientLayer *lGradientLayer = [CAGradientLayer layer];
    lGradientLayer.colors = @[(__bridge id) [HJProgressView2 fmut_colorWithRGB:0x50aaff].CGColor,
                              (__bridge id) [HJProgressView2 fmut_colorWithRGB:0x3299f9].CGColor];
    lGradientLayer.locations = @[@0, @1.0];
    lGradientLayer.startPoint = CGPointMake(0, 0);
    lGradientLayer.endPoint = CGPointMake(1.0, 0);
    lGradientLayer.frame = CGRectMake(0, porigny, lwidth, pheight);
    [progressBGV.layer addSublayer:lGradientLayer];
    _lGradientLayer = lGradientLayer;
    
    
    CAGradientLayer *rGradientLayer = [CAGradientLayer layer];
    rGradientLayer.colors = @[(__bridge id) [HJProgressView2 fmut_colorWithRGB:0xfd543d].CGColor,
                              (__bridge id) [HJProgressView2 fmut_colorWithRGB:0xff6e22].CGColor];
    rGradientLayer.locations = @[@0, @1.0];
    rGradientLayer.startPoint = CGPointMake(0, 0);
    rGradientLayer.endPoint = CGPointMake(1.0, 0);
    rGradientLayer.frame = CGRectMake(lwidth, porigny, rwidth, pheight);
    [progressBGV.layer addSublayer:rGradientLayer];
    _rGradientLayer = rGradientLayer;
    
    CGRect imgf =  CGRectMake(lwidth - 4.5/2.0, porigny, 4.5 , pheight);
    UIImageView * progressImageV = [[UIImageView alloc] initWithFrame:imgf];
    progressImageV.image = [UIImage imageNamed:@"progress_icon"];
    [progressBGV addSubview:progressImageV];
    _progressImageV = progressImageV;

    if(_progressNum1 == 1 && _progressNum2 ==0 )
        _progressImageV.hidden = YES;
    else if(_progressNum1 == 0 && _progressNum2 ==1 )
        _progressImageV.hidden = YES;
    else
        _progressImageV.hidden = NO;

    return progressBGV;
}


- (void) initProgressViewWithFrame:(CGRect)frame{
    CGFloat Width = frame.size.width;
    CGFloat CH = 45;
    CGFloat CW = 45+15;
    CGFloat separator = 20;
    HJProgressView2 * view = self;
    
    //@"71%";
    UILabel *supportPercentageLab = [[UILabel alloc] initWithFrame:CGRectMake(separator,0,CW,CH)];
    supportPercentageLab.textAlignment = NSTextAlignmentCenter;
    supportPercentageLab.text = _supportPercentageStr;
    supportPercentageLab.font = [UIFont boldSystemFontOfSize:18];
    supportPercentageLab.textColor =  [HJProgressView2 fmut_colorWithRGB:0x3299f9];
    [view addSubview:supportPercentageLab];
    _supportPercentageLab =supportPercentageLab;
    
    //;@"29%";
    UILabel *againstPercentageLab = [[UILabel alloc] initWithFrame:CGRectMake(Width-separator-CW,0,CW,CH)];
    againstPercentageLab.textAlignment = NSTextAlignmentCenter;
    againstPercentageLab.text = _againstPercentageStr;
    againstPercentageLab.font = [UIFont boldSystemFontOfSize:18];
    againstPercentageLab.textColor =  [HJProgressView2 fmut_colorWithRGB:0xfd543d];
    [view addSubview:againstPercentageLab];
    _againstPercentageLab = againstPercentageLab;
    
    //圆点+圆点背景
    UIImageView * LeftBGIMG = [[UIImageView alloc] initWithFrame:CGRectMake(separator+CW,15,15,15)];
    LeftBGIMG.backgroundColor =  [HJProgressView2 fmut_colorWithRGB:0xf3f3f3];
    LeftBGIMG.layer.cornerRadius = LeftBGIMG.frame.size.width/2.0;
    LeftBGIMG.layer.masksToBounds = YES;
    [view addSubview:LeftBGIMG];
    
    UIButton * supportPercentageBtn = [[UIButton alloc] initWithFrame:CGRectMake(2.5,2.5,10,10)];
    supportPercentageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    supportPercentageBtn.backgroundColor =   [HJProgressView2 fmut_colorWithRGB:0x50aaff];
    supportPercentageBtn.layer.cornerRadius = supportPercentageBtn.frame.size.width/2.0;
    supportPercentageBtn.layer.masksToBounds = YES;
    supportPercentageBtn.userInteractionEnabled = NO;
    [LeftBGIMG addSubview:supportPercentageBtn];
    
    UIImageView * rightBGIMG = [[UIImageView alloc] initWithFrame:CGRectMake(Width-separator-CW-15,15,15,15)];
    rightBGIMG.backgroundColor =  [HJProgressView2 fmut_colorWithRGB:0xf3f3f3];
    rightBGIMG.layer.cornerRadius = rightBGIMG.frame.size.width/2.0;
    rightBGIMG.layer.masksToBounds = YES;
    [view addSubview:rightBGIMG];
    
    UIButton * againstPercentageBtn = [[UIButton alloc] initWithFrame:CGRectMake(2.5,2.5,10,10)];
    againstPercentageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    againstPercentageBtn.backgroundColor = [HJProgressView2 fmut_colorWithRGB:0xff6e22];
    againstPercentageBtn.layer.cornerRadius = againstPercentageBtn.frame.size.width/2.0;
    againstPercentageBtn.layer.masksToBounds = YES;
    againstPercentageBtn.userInteractionEnabled = NO;
    [rightBGIMG addSubview:againstPercentageBtn];
    
    //背景长条+progress
    CGFloat progressSeparator = separator+CW+12.5;
    _progressBGVWidth = Width-2*progressSeparator+0.5;
    UIView * progressBGV = [self hjProgressView:CGRectMake(progressSeparator,(CH-7.0)/2.0,_progressBGVWidth, 7)];
    [self addSubview:progressBGV];
}

+ (UIColor *)fmut_colorWithRGB:(uint32_t)rgbValue{
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

@end
