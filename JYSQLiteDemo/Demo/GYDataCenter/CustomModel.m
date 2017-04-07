//
//  CustomModel.m
//  JYSQLiteDemo
//
//  Created by Jolie_Yang on 2017/4/7.
//  Copyright © 2017年 China Industrial Bank. All rights reserved.
//

#import "CustomModel.h"

@implementation CustomModel
// 数据存放的数据库名
+ (NSString *)dbName {
    return @"GYDataCenterTests";
}

// 数据存放的表名
+ (NSString *)tableName {
    return @"GYDataCenterEmployee";
}

// 主键
+ (NSString *)primaryKey {
    return @"employeeId";
}

// 属性列表，按属性生命顺序
+ (NSArray *)persistentProperties {
    static NSArray *properties = nil;
    if (!properties) {
        properties = @[
                       @"employeeId",
                       @"name",
                       @"dateOfBirth",
                       ];
    }
    return properties;
}

@end

@implementation CustomOtherModel
+ (NSString *)dbName {
    return @"GYDataCenterTests";
}

+ (NSString *)tableName {
    return @"GYDateCenterOther";
}

+ (NSString *)primaryKey {
    return @"otherId";
}

+ (NSArray *)persistentProperties {
    static NSArray *properties = nil;
    if (!properties) {
        properties = @[
                       @"otherId",
                       @"name",
                       @"nick",
                       ];
    }
    return properties;
}

+ (NSArray *)indices {
    
}

@end
