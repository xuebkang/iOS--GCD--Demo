//
//  SingleTest.m
//  多线程---GCD
//
//  Created by CJW on 2019/8/8.
//  Copyright © 2019 CJW. All rights reserved.
//

#import "SingleTest.h"

@implementation SingleTest
//只执行一次
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static SingleTest *single = nil;
    dispatch_once(&onceToken, ^{
        NSLog(@"初始化单例");
        single = [[SingleTest alloc] init];
    });
    return single;
}
@end
