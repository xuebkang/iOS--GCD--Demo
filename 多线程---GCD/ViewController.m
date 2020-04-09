//
//  ViewController.m
//  多线程---GCD
//
//  Created by CJW on 2019/8/7.
//  Copyright © 2019 CJW. All rights reserved.
//

#import "ViewController.h"
#import "SingleTest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"GCD测试" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(70, 100, self.view.bounds.size.width - 140, 50);
    [button addTarget:self action:@selector(GCDTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor whiteColor];
    [button1 setTitle:@"Global_queue" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(70, 200, self.view.bounds.size.width - 140, 50);
    [button1 addTarget:self action:@selector(Global_queue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = [UIColor whiteColor];
    [button2 setTitle:@"Group_queue" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.frame = CGRectMake(70, 300, self.view.bounds.size.width - 140, 50);
    [button2 addTarget:self action:@selector(Group_queue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];

    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.backgroundColor = [UIColor whiteColor];
    [button3 setTitle:@"单例" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button3.frame = CGRectMake(70, 400, self.view.bounds.size.width - 140, 50);
    [button3 addTarget:self action:@selector(signaldd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.backgroundColor = [UIColor whiteColor];
    [button4 setTitle:@"延时执行" forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button4.frame = CGRectMake(70, 500, self.view.bounds.size.width - 140, 50);
    [button4 addTarget:self action:@selector(afterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];

}

- (void)GCDTest{
    //异步线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"开启任务1");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程执行任务！");
            self.view.backgroundColor = [UIColor purpleColor];
        });
        [NSThread sleepForTimeInterval:5];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"再次改变视图颜色");
            self.view.backgroundColor = [UIColor yellowColor];
        });
    });
}
//关于global_queue 全局并发的线程
- (void)Global_queue{
    //global_queue 有两个参数，第一个参数为优先级
    /****   队列优先级  高  默认  低 
     #define DISPATCH_QUEUE_PRIORITY_HIGH 2
     #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0
     #define DISPATCH_QUEUE_PRIORITY_LOW (-2)
     #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN

     *****/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"开启任务1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"结束任务1");
    });

   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"开启任务2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"结束任务2");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"开启任务3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"结束任务3");
    });
    
    //自定义队列异步执行，串行队列。。  创建队列时候，第二个参数 为 NULL的时候为 串行队列. DISPATCH_QUEUE_CONCURRENT:为并行队列
    
//    dispatch_queue_t customQueue = dispatch_queue_create("queue.com", DISPATCH_QUEUE_CONCURRENT);
//
//    dispatch_async(customQueue, ^{
//        NSLog(@"开启自定义队列任务1");
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"结束自定义队列任务1");
//    });
//
//    dispatch_async(customQueue, ^{
//        NSLog(@"开启自定义队列任务2");
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"结束自定义队列任务2");
//    });
//
//    dispatch_async(customQueue, ^{
//        NSLog(@"开启自定义队列任务3");
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"结束自定义队列任务3");
//    });

}

//group_queue 的使用
- (void)Group_queue{
    NSLog(@"执行主线程");
    //创建并发的queue
    dispatch_queue_t customQueue = dispatch_queue_create("com.group_queue", DISPATCH_QUEUE_CONCURRENT);
    //创建group
    dispatch_group_t groupQueue = dispatch_group_create();
    
    dispatch_group_async(groupQueue, customQueue, ^{
        NSLog(@"开启自定义队列并发任务1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"结束自定义队列并发任务1");
    });
    
    dispatch_group_async(groupQueue, customQueue, ^{
        NSLog(@"开启自定义队列并发任务2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"结束自定义队列并发任务2");
    });
    
    dispatch_group_async(groupQueue, customQueue, ^{
        NSLog(@"开启自定义队列并发任务3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"结束自定义队列并发任务3");
    });
    
    //所有任务都结束后的回调通知
    dispatch_group_notify(groupQueue, customQueue, ^{
        NSLog(@"所有任务都已经结束了！！！");
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程刷新UI");
            self.view.backgroundColor = [UIColor blueColor];
        });
    });
}

#pragma mark --GCD的其他一些方法---初始化一个单例
- (void)signaldd{
    SingleTest *single = [SingleTest shareInstance];
    NSLog(@"hhh: %@",single);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"整个生命周期中，只执行一次");
    });
}

- (void)afterAction{
    
    NSLog(@"立即执行");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"我是3秒后执行打印的");
    });
}
@end
