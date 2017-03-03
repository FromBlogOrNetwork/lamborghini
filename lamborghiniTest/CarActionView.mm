//
//  CarActionView.m
//  lamborghiniTest
//
//  Created by lwj on 17/2/10.
//  Copyright © 2017年 WenJin Li. All rights reserved.
//
#define SCREEN_MODE_IPHONE4 ([[UIScreen mainScreen] bounds].size.height <= 480)
#define SCREEN_MODE_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREEN_MODE_IPHONE5_BELOW ([[UIScreen mainScreen] bounds].size.height < 568)
#define SCREEN_MODE_IPHONE5x ([[UIScreen mainScreen] bounds].size.height >= 568)
#define SCREEN_MODE_IPHONE6  ([[UIScreen mainScreen] bounds].size.height == 667)
#define SCREEN_MODE_IPHONE6Plus  ([[UIScreen mainScreen] bounds].size.height == 736)
#define SCREEN_MODE_IPHONE6x ([[UIScreen mainScreen] bounds].size.height > 568)

#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#import "CarActionView.h"

@interface CarActionView ()

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *carname;

@end

@implementation CarActionView
- (instancetype)initWithFrame:(CGRect)frame loadPlistFilewithPath:(NSString*)plistPath withUserName:(NSString*)username withCarName:(NSString*)carname
{
    self = [super initWithFrame:frame];
    if (self) {
        _userName = username;
        _carname = carname;
       [self loadPlistFilewithPath:plistPath];
    }
    return self;
}
- (void)loadPlistFilewithPath:(NSString*)plistPath{
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSMutableArray *imageMtbArray = [[NSMutableArray alloc]initWithCapacity:0];
    if ([data objectForKey:@"animationPlus"] && ![[data objectForKey:@"animationPlus"] isKindOfClass:[NSNull class]]) {
        imageMtbArray = [data objectForKey:@"animationPlus"];
    }
    [self createUIWithImageArray:imageMtbArray];
}
- (void)animationCarMoveAction:(CGFloat)animationDuration withImageVIew:(UIImageView*)carImageView withstartArray:(NSMutableArray*)startPointArray withendArray:(NSMutableArray*)endPointArray withDelay:(CGFloat)animationDelay{
    if (startPointArray.count > 0  && endPointArray.count > 0) {
        CGPoint startPoint = CGPointFromString(startPointArray[0]);
        CGPoint endPoint = CGPointFromString(endPointArray[0]);
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect rect = carImageView.frame;
            rect.origin = endPoint;
            carImageView.frame = rect;
            
        } completion:^(BOOL finished) {
            [startPointArray removeObjectAtIndex:0];
            [endPointArray removeObjectAtIndex:0];
            [self animationCarMoveAction:animationDuration withImageVIew:carImageView withstartArray:startPointArray withendArray:endPointArray withDelay:0];
        }];
        
    }
}
- (void)createUIWithImageArray:(NSMutableArray*)imageArray{
    if (imageArray.count > 0) {
        
        NSDictionary* carDictionary = imageArray[0];
        NSString* rectString =  [carDictionary objectForKey:@"frame1"];
        if (SCREEN_MODE_IPHONE6Plus) {
            rectString = [carDictionary objectForKey:@"frame1"];
            
        }else if (SCREEN_MODE_IPHONE6x){
            rectString = [carDictionary objectForKey:@"frame2"];
        }else{
            rectString = [carDictionary objectForKey:@"frame3"];
        }
        CGRect carFrame = CGRectFromString(rectString);
        NSString* carName = [carDictionary objectForKey:@"name"];
        UIImageView*carImageView = [[UIImageView alloc]initWithFrame:carFrame];
        carImageView.image = [UIImage imageNamed:carName];
        [self addSubview:carImageView];
        
        UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -36, carImageView.frame.size.width, 26)];
        nameLabel.layer.masksToBounds = YES;
        nameLabel.layer.cornerRadius = 13;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        nameLabel.layer.borderWidth = 1;
        nameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        nameLabel.font = [UIFont systemFontOfSize:14];
        
        NSString* str = [NSString stringWithFormat:@"%@开着%@进入直播间",_userName,_carname];
        NSMutableAttributedString* nsmutableAttributeString = [[NSMutableAttributedString alloc]initWithString:str];
        [nsmutableAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0, _userName.length)];
        [nsmutableAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(_userName.length+2, _carname.length)];
        [nameLabel setAttributedText:nsmutableAttributeString];
        
        [carImageView addSubview:nameLabel];
        
        
        
        
        BOOL isCarhaveAnimation = [[carDictionary objectForKey:@"isHaveAnimation"]boolValue];
        if (isCarhaveAnimation) {
            
            if ([carDictionary objectForKey:@"startPoint"]&&[carDictionary objectForKey:@"endPoint"]) {
                NSMutableArray*startPointArray = [carDictionary objectForKey:@"startPoint"];
                
                NSMutableArray* endPointArray = [carDictionary objectForKey:@"endPoint"];
                
                if (SCREEN_MODE_IPHONE6Plus) {
                    
                }
                else if (SCREEN_MODE_IPHONE6x){
                    endPointArray = [carDictionary objectForKey:@"endPoint1"];
                }else{
                    endPointArray = [carDictionary objectForKey:@"endPoint2"];
                }

                CGFloat animationDuration = [[carDictionary objectForKey:@"animationDuration"]floatValue];
                CGFloat animationDelay = [[carDictionary objectForKey:@"animationDelay"]floatValue];
                [self animationCarMoveAction:animationDuration withImageVIew:carImageView withstartArray:startPointArray withendArray:endPointArray withDelay:animationDelay];
            }
        }
        
        for (int i = 1; i < imageArray.count; i++) {
            NSDictionary* otherDictionary = imageArray[i];
            NSString* otherString = [otherDictionary objectForKey:@"frame"];
            CGRect otherRect = CGRectFromString(otherString);
            NSString* otherName = [otherDictionary objectForKey:@"name"];
            UIImageView* otherImgView = [[UIImageView alloc]initWithFrame:otherRect];
            otherImgView.image = [UIImage imageNamed:otherName];
            [carImageView addSubview:otherImgView];
            BOOL isRotate = [[otherDictionary objectForKey:@"rotate"]boolValue];
            BOOL ishaveAnimation = [[otherDictionary objectForKey:@"isHaveAnimation"]boolValue];
            if (ishaveAnimation) {
                CGFloat animationDuration = [[otherDictionary objectForKey:@"animationDuration"]floatValue];
                CGFloat animationDelay = [[otherDictionary objectForKey:@"animationDelay"]floatValue];
                NSInteger repeatCount = [[otherDictionary objectForKey:@"repeatCount"]integerValue];
                BOOL isAlpalChangeAnimation  = [[otherDictionary objectForKey:@"isAlpalChangeAnimation"]boolValue];
                if (isAlpalChangeAnimation) {
                    otherImgView.alpha = 0;
                }
                if (isRotate) {
                    CGFloat radius = [[otherDictionary objectForKey:@"radius"]floatValue];
                    CGFloat secondStarDaly = [[otherDictionary objectForKey:@"secondStarDaly"]floatValue];
                    otherImgView.layer.transform = CATransform3DMakeRotation(radius, 0, 1, 0);
                    
                    [self rotationanimationAction:animationDuration withDelay:animationDelay withrepeatCount:repeatCount withImageVIew:otherImgView withSecondStarDelay:secondStarDaly];
                }else{
                    [self animationAction:animationDuration withDelay:animationDelay withrepeatCount:repeatCount withImageVIew:otherImgView withisAlpalChangeAnimation:isAlpalChangeAnimation];
                }
            }
        }
    }
}
-(void)keepRotationduration:(NSDictionary *)dict{
    CGFloat duration = [[dict objectForKey:@"duration"]floatValue];
    UIImageView* otherImgView = [dict objectForKey:@"otherImgView"];
    NSInteger repeatCount  = [[dict objectForKey:@"repeatCount"]integerValue];
    CGFloat duration2 = duration/4;
    [UIView animateWithDuration:duration2 delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [otherImgView.layer setTransform:CATransform3DRotate(otherImgView.layer.transform, M_PI * 0.5f, 0, 0, -1.0)];//车轮逆时针旋转180度
    } completion:^(BOOL finished) {
        
        if (repeatCount > 0) {
            NSInteger repeatCount2 = repeatCount - 1;
            //[self  keepRotationduration:duration withImageVIew:otherImgView withDuration:animationDuration withrepeatCount:repeatCount2];
            NSDictionary* dict2 = @{@"duration":[NSNumber numberWithFloat:duration],@"otherImgView":otherImgView,@"repeatCount":[NSNumber numberWithInteger:repeatCount2]};
            [self keepRotationduration:dict2];
        }
    }];
}

- (void)rotationanimationAction:(CGFloat)animationDuration withDelay:(CGFloat)animationDelay withrepeatCount:(NSInteger)repeatCount withImageVIew:(UIImageView*)otherImgView withSecondStarDelay:(CGFloat)SecondDelay{
    
    //if(repeatCount == 0){
    NSDictionary* dict = @{@"duration":[NSNumber numberWithFloat:animationDuration],@"otherImgView":otherImgView,@"repeatCount":[NSNumber numberWithInteger:repeatCount]};
    [self  keepRotationduration:dict];
    if (SecondDelay > 0) {
        [self performSelector:@selector(keepRotationduration:) withObject:dict afterDelay:SecondDelay];
    }
}
- (void)animationAction:(CGFloat)animationDuration withDelay:(CGFloat)animationDelay withrepeatCount:(NSInteger)repeatCount withImageVIew:(UIImageView*)otherImgView withisAlpalChangeAnimation:(BOOL)isAlpalChangeAnimation{
   
    [UIView animateWithDuration:animationDuration delay:animationDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (isAlpalChangeAnimation) {
            otherImgView.alpha = 1;
        }
        
    } completion:^(BOOL finished) {
        if (repeatCount > 1) {
            if (isAlpalChangeAnimation) {
                [UIView animateWithDuration:animationDuration delay:animationDelay/3.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    otherImgView.alpha = 0 ;
                } completion:^(BOOL finished) {
                    NSInteger repeatCount2 = repeatCount - 1;
                    [self animationAction:animationDuration withDelay:0 withrepeatCount:repeatCount2 withImageVIew:otherImgView withisAlpalChangeAnimation:isAlpalChangeAnimation];
                }];
                
                
            }else{
                NSInteger repeatCount2 = repeatCount - 1;
                [self animationAction:animationDuration withDelay:0 withrepeatCount:repeatCount2 withImageVIew:otherImgView withisAlpalChangeAnimation:isAlpalChangeAnimation];
            }
        }else if (isAlpalChangeAnimation){
            [UIView animateWithDuration:animationDuration delay:animationDelay*1.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                otherImgView.alpha = 0 ;
            } completion:nil];
            
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
