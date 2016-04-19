//
//  ViewController.m
//  123
//
//  Created by wyz on 16/4/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:91 green:198 blue:72 alpha:1.0];
    NSDictionary *d1 = @{@"image":@"1",@"time":@"08:00",@"tip":@"早上起床后是不是觉得昏昏沉沉没睡醒呢，别急着吃早餐，先来杯淡盐水清理一下肠道，然后再喝一杯温开水保护肠胃，最后别忘了吃早餐哦！"};
    NSDictionary *d2 = @{@"image":@"2",@"time":@"09:00",@"tip":@"上午开始一天的工作时，别忘了喝杯水，一方面它可以让你精神焕发，更一方面还可以让你提神醒脑，提高工作效率哦，所以做工作之前千万别忘了喝杯水"};
    NSDictionary *d3 = @{@"image":@"3",@"time":@"11:30",@"tip":@"辛苦工作了一上午，马上就到午餐时间了，可是吃午饭之前记得喝杯水，避免因为空腹而引起暴食哦"};
    NSDictionary *d4 = @{@"image":@"4",@"time":@"13:30",@"tip":@"午餐很重要，但是也要适量的吃到八分饱，如果吃的太饱会给肠胃造成负担，所以要记得在饭后20分钟喝杯水，促进消化"};
    NSDictionary *d5 = @{@"image":@"5",@"time":@"15:30",@"tip":@"下午茶时间记得喝杯咖啡或者喝杯水，振奋精神哦"};
    NSDictionary *d6 = @{@"image":@"6",@"time":@"17:30",@"tip":@"一天的工作结束了，下班之前记得喝杯温开水，缓解因为工作带来的疲劳哦"};
    NSDictionary *d7 = @{@"image":@"7",@"time":@"19:00",@"tip":@"这个时间段正是代谢的高峰期，记得喝杯温开水，促进身体排毒"};
    NSDictionary *d8 = @{@"image":@"8",@"time":@"20:15",@"tip":@"睡前两个小时之内喝杯水，可以预防血稠，建议大家睡前几分钟内不要喝水，避免第二天水肿"};
    NSArray *array = @[d1,d2,d3,d4,d5,d6,d7,d8];
    [array writeToFile:@"/Users/wyz/Desktop/drinkInfo.plist" atomically:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


    


@end
