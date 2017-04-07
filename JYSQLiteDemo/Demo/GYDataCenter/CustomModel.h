//
//  CustomModel.h
//  JYSQLiteDemo
//
//  Created by Jolie_Yang on 2017/4/7.
//  Copyright © 2017年 China Industrial Bank. All rights reserved.
//

#import <GYDataCenter/GYDataCenter.h>

@interface CustomModel : GYModelObject
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *dateOfBirth;
@end

@interface CustomOtherModel : GYModelObject
@property (nonatomic, assign) NSInteger otherId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *nick;

@end