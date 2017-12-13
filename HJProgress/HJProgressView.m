//
//  HJProgressView.m
//  FormaxCopyMaster
//
//  Created by 何杰 on 2017/3/16.
//  Copyright © 2017年 Formax. All rights reserved.
//

#import "HJProgressView.h"

@interface HJProgressView()

@property(nonatomic) double maxNumber;
@property(nonatomic) double usedNumber;

@property(strong,nonatomic) CAGradientLayer *lGradientLayer;
@property(strong,nonatomic) UILabel *usedMoneyLab;
@property(strong,nonatomic) UILabel *maxMoneyLab;
@property(strong,nonatomic) UIView  *progressBGV;

@end

@implementation HJProgressView


- (instancetype)initWithFrame:(CGRect)frame maxNumber:(double)maxNumber usedNumber:(double)usedNumber{
    self = [super initWithFrame:frame];
    if(self){
        self.maxNumber  = maxNumber;
        self.usedNumber = usedNumber;
        [self configUI:frame];
    }
    return self;
}

- (void)updateProgressPercent:(double)maxNumber usedNumber:(double)usedNumber{
    if (self.maxNumber != maxNumber || self.usedNumber!=usedNumber){
        self.maxNumber  = maxNumber;
        self.usedNumber = usedNumber;
        NSString * string =[NSString stringWithFormat:@"已用%@",[self fmcr_formatLoanMoney:self.usedNumber]];
        self.usedMoneyLab.text = string;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSMutableAttributedString *mAttStr = [[NSMutableAttributedString alloc] initWithString:string];
//            NSInteger len = string.length;
//            [mAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(len-2, 2)];
//            self.usedMoneyLab.attributedText = mAttStr.copy;
//        });
        NSString * string1 =[NSString stringWithFormat:@"可用额度%@",[self fmcr_formatLoanMoney:self.maxNumber]];
        self.maxMoneyLab.text = string1;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSMutableAttributedString *mAttStr1 = [[NSMutableAttributedString alloc] initWithString:string1];
//            NSInteger len = string1.length;
//            [mAttStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(len-2, 2)];
//            self.maxMoneyLab.attributedText = mAttStr1.copy;
//        });

        CGFloat percent = 0.00;
        if(maxNumber > 0)
            percent = 1.00 - usedNumber/(maxNumber*1.00);

        self.lGradientLayer.frame = CGRectMake(0, 0, self.frame.size.width * percent,  10.f);
    }
}

-(UILabel*)usedMoneyLab{
    if(!_usedMoneyLab){
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 14)];
        titleLabel.text =[NSString stringWithFormat:@"已用%@",[self fmcr_formatLoanMoney:self.usedNumber]];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor clearColor];
//        NSString * string = titleLabel.text;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSMutableAttributedString *mAttStr = [[NSMutableAttributedString alloc] initWithString:string];
//            NSInteger len = string.length;
//            [mAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(len-2, 2)];
//            titleLabel.attributedText = mAttStr.copy;
//        });
        titleLabel.textColor = [HJProgressView fmut_colorWithRGB:0x7575a6];
        _usedMoneyLab = titleLabel;
    }
    return _usedMoneyLab;
}

-(UILabel*)maxMoneyLab{
    if(!_maxMoneyLab){
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 250, 14)];
        titleLabel.text =[NSString stringWithFormat:@"可用额度%@",[self fmcr_formatLoanMoney:self.maxNumber]];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor clearColor];
//        NSString * string = titleLabel.text;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSMutableAttributedString *mAttStr = [[NSMutableAttributedString alloc] initWithString:string];
//            NSInteger len = string.length;
//            [mAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(len-2, 2)];
//            titleLabel.attributedText = mAttStr.copy;
//        });
        titleLabel.textColor = [HJProgressView fmut_colorWithRGB:0x7575a6];
        _maxMoneyLab = titleLabel;
    }
    return _maxMoneyLab;

}

- (void)configUI:(CGRect)frame{
    self.backgroundColor = [UIColor whiteColor];

    //背景长条
    UIView * progressBGV = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
    progressBGV.backgroundColor =  [HJProgressView fmut_colorWithRGB:0xe7f0fc];
    progressBGV.layer.masksToBounds = YES;
    progressBGV.layer.cornerRadius = 5.0;
    _progressBGV =progressBGV;
    
    CGFloat percent = 0.00;
    if(self.maxNumber > 0)
        percent = 1.00 - self.usedNumber/(self.maxNumber*1.00);
    
    CAGradientLayer *lGradientLayer = [CAGradientLayer layer];
    lGradientLayer.colors = @[(__bridge id) [HJProgressView fmut_colorWithRGB:0x38b6fe].CGColor,
                              (__bridge id) [HJProgressView fmut_colorWithRGB:0x146de6].CGColor];
    lGradientLayer.locations = @[@0, @1.0];
    lGradientLayer.startPoint = CGPointMake(0, 0);
    lGradientLayer.endPoint = CGPointMake(1.0, 0);
    
    lGradientLayer.masksToBounds = YES;
    lGradientLayer.cornerRadius = 5.0;
    
    lGradientLayer.frame = CGRectMake(0, 0, frame.size.width * percent,  10.f);
    [progressBGV.layer addSublayer:lGradientLayer];
    
    _lGradientLayer = lGradientLayer;

    [self addSubview:progressBGV];
    [self addSubview:self.maxMoneyLab];
    [self addSubview:self.usedMoneyLab];
}

+ (UIColor *)fmut_colorWithRGB:(uint32_t)rgbValue{
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

-(NSString *)fmcr_formatLoanMoney:(double)money{
    NSString *text = [NSString stringWithFormat:@"%.0f",money];
    return [NSString stringWithFormat:@"¥%@",[self formatLoanMoney:text]];
}

-(NSString *)formatLoanMoney:(NSString *)text {
    //判断是否是纯数字
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:text]) {
        return text;
    }
    if(text.length>10)
        return text;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *loanMoney = [formatter stringFromNumber:[NSNumber numberWithInt:text.intValue]];
    return loanMoney;
}

@end
