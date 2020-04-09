//
//  SingleTest.h
//  多线程---GCD
//
//  Created by CJW on 2019/8/8.
//  Copyright © 2019 CJW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingleTest : NSObject
+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
