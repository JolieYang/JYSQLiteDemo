//
//  FMDBViewController.m
//  JYSQLiteDemo
//
//  Created by Jolie_Yang on 2017/4/5.
//  Copyright © 2017年 China Industrial Bank. All rights reserved.
//

#import "FMDBViewController.h"
#import "FMDB.h"

@interface User : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger age;
@end
@implementation User
@end

@interface FMDBViewController ()

@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)simpleSelect {
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbpath = [docsdir stringByAppendingString:@"user.sqlite"];
    // 建立数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    // 打开数据库
    BOOL opened = [db open];
    if (!opened) {
        // 打开数据库失败,可能是权限不足或资源不足。
        return;
    }
    // Select操作,操作为标准的SQL语句
    FMResultSet *rs = [db executeQuery:@"select * from people"];
    while ([rs next]) {// 通过调用next获取操作结果，即使只有一条记录
        // stringForColumn获取字符串类型数据，FMResultSet还提供了方法提供多种类型的数据，包括date,data,int,object等
        NSLog(@"%@ %@", [rs stringForColumn:@"firstname"], [rs stringForColumn:@"lastname"]);
    }
    // 使用完一般都要关闭数据库
    [db close];// ps: 数据库关闭时，也会将FMResultSet关闭，所以一般不用手动关闭FMResultSet
}

- (void)simpeInsert {
    User *user = [[User alloc] init];
    user.name = @"rose";
    user.password= @"123";
    user.age = 17;
    FMDatabase *db = [FMDatabase databaseWithPath:@""];
    NSString *sql = @"insert into User( name, password) values (?, ?, ?)";
    [db executeUpdate:sql, user.name, user.password, [NSNumber numberWithInteger:user.age]];// ps:  参数必须时NSOBject的子类，所以像int,double,book这种基本类型需要封装成对象
}

#pragma mark --  多线程操作数据库--使用FMDatabaseQueue保证线程安全
@end
