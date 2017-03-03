//
//  ViewController.m
//  lamborghiniTest
//
//  Created by lwj on 17/2/9.
//  Copyright © 2017年 WenJin Li. All rights reserved.
//

#import "ViewController.h"
#import "CarActionView.h"
@interface ViewController ()
   
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self loadCar];
}

- (void)loadCar{
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView*backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"jpg"]];
    [self.view addSubview:backImageView];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"JeepCherokee" ofType:@"plist"];//Benz  //Audi  //BMW //Ferrari
    //Lamborghini   //Benz //JeepCherokee
    CarActionView* carView = [[CarActionView alloc]initWithFrame:self.view.bounds loadPlistFilewithPath:plistPath withUserName:@"小笑话" withCarName:@"兰博基尼"];
    
    [self.view addSubview:carView];
}

@end

