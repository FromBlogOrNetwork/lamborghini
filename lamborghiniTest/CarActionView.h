//
//  CarActionView.h
//  lamborghiniTest
//
//  Created by lwj on 17/2/10.
//  Copyright © 2017年 WenJin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarActionView : UIView
- (instancetype)initWithFrame:(CGRect)frame loadPlistFilewithPath:(NSString*)plistPath withUserName:(NSString*)username withCarName:(NSString*)carname;
@end
