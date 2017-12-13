//
//  HJProgressView.h
//  FormaxCopyMaster
//
//  Created by 何杰 on 2017/3/16.
//  Copyright © 2017年 Formax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJProgressView2 : UIView

- (instancetype)initWithFrame:(CGRect)frame joinNumber:(int64_t)joinNumber voteCount:(int64_t)voteCount;

- (void)setProgressPercent:(int64_t)joinNumber voteCount:(int64_t)voteCount;

@end
