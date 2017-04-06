//
//  FMDBViewController.m
//  JYSQLiteDemo
//
//  Created by Jolie_Yang on 2017/4/5.
//  Copyright © 2017年 China Industrial Bank. All rights reserved.
//
//  参考: http://blog.devtang.com/2012/04/22/use-fmdb

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
@property (weak, nonatomic) IBOutlet UITextField *tableNameTF;
@property (weak, nonatomic) IBOutlet UITextView *selectResultTV;
@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) NSString *dbpath;
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

- (NSString *)dbpath {
    if (!_dbpath) {
        NSString *docdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        _dbpath = [docdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.tableName]];
        NSLog(@"dbpath:%@", _dbpath);
    }
    return _dbpath;
}
- (NSString *)tableName {
    if (!_tableName) {
        _tableName = self.tableNameTF.text.length != 0? self.tableNameTF.text : @"User";
    }
    return _tableName;
}
#pragma mark -- Action
- (IBAction)createTableAction:(id)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.dbpath]) {
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbpath];
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'name' VARCHAR(30), 'password' VARCHAR(30))", self.tableName];
            BOOL res = [db executeUpdate:sql];
            
            if (!res) {
                // 创建表失败
                [self showInfomationWithText:@"创建table失败"];
                [db close];
                return;
            }
            [db close];
        } else {
            // 打开时出现问题
        }
    } else {
        [self showInfomationWithText:@"已存在该SQlite文件"];
    }
}
- (IBAction)insertDataAction:(id)sender {
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbpath];
    if ([db open]) {
        NSString *sql = @"insert into User(name, password) values (?, ?)";
        BOOL res = [db executeUpdate:sql, @"jolie", @"123"];
        if (!res) {
            // 插入失败
            [self showInfomationWithText:@"插入失败"];
        }
        [db close];
    }
}
- (IBAction)queryDataAction:(id)sender {
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbpath];
    if ([db open]) {
        NSString * sql = @"select * from user";
        FMResultSet * rs = [db executeQuery:sql];
        NSString *result = @"";
        while ([rs next]) {// 结果会从队列中出去
            int userId = [rs intForColumn:@"id"];
            NSString * name = [rs stringForColumn:@"name"];
            NSString * pass = [rs stringForColumn:@"password"];
            result  = [result stringByAppendingString:[NSString stringWithFormat:@" user id = %d, name = %@, pass = %@\n", userId, name, pass]];
        }
        [self showInfomationWithText:result];
        
        [db close];
    }
}
- (IBAction)deleteAction:(id)sender {
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbpath];
    if ([db open]) {
        NSString *sql = @"delete from user";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            // 操作失败
            [self showInfomationWithText:@"删除数据操作失败"];
        }
        [db close];
    }
}
- (IBAction)multiThreadInsertAction:(id)sender {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.dbpath];
    [queue inDatabase:^(FMDatabase *db) {
        for (int i = 1; i < 100; i++) {
            NSString * sql = @"insert into user (name, password) values(?, ?) ";
            NSString * name = [NSString stringWithFormat:@"Jolie-q1 %d", i];
            BOOL res = [db executeUpdate:sql, name, @"123"];
            if (!res) {
                [self showInfomationWithText:@"批量插入失败"];
            } else {
                [self showInfomationWithText:@"批量插入成功-q2"];
            }
        }
        
    }];
}

- (void)showInfomationWithText:(NSString *)text {
    self.selectResultTV.text = text;
}

#pragma mark -- SQL Opeations Demo
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

- (void)simpeUpdate {
    User *user = [[User alloc] init];
    user.name = @"rose";
    user.password= @"123";
    user.age = 17;
    FMDatabase *db = [FMDatabase databaseWithPath:@""];
    NSString *sql = @"insert into User( name, password, age) values (?, ?, ?)";// ? 代表参数
    // executeUpdate将SQL语句和参数传入
    [db executeUpdate:sql, user.name, user.password, [NSNumber numberWithInteger:user.age]];// ps:  参数必须时NSOBject的子类，所以像int,double,book这种基本类型需要封装成对象
}

#pragma mark -- FMDatabaseQueue 多线程操作数据库保证线程安全 ps: FMDatabase无法保证线程安全，多线程使用会造成数据混乱等问题
- (void)simpleDatabaseQueue {
    // 最好在一个单例的类中创建
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:@""];
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];
        
        FMResultSet *rs = [db executeQuery:@"select * from foo"];
        while ([rs next]) {
            // ...
        }
    }];
    
    // 事务
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];
        
        BOOL somethingWrongHappens = NO; // 是否有异常发生
        if (somethingWrongHappens) {
            *rollback = YES;
            return ;
        }
        
    }];
}
@end
