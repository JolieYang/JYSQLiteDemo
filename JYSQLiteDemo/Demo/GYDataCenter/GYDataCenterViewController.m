//
//  GYDataCenterViewController.m
//  JYSQLiteDemo
//
//  Created by Jolie_Yang on 2017/4/7.
//  Copyright © 2017年 China Industrial Bank. All rights reserved.
//

#import "GYDataCenterViewController.h"
#import "CustomModel.h"

@interface GYDataCenterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idTF;
@property (weak, nonatomic) IBOutlet UITextField *limitIdTF;

@property (weak, nonatomic) IBOutlet UITextView *showResultTV;

@end

@implementation GYDataCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Actions
- (IBAction)insertDataAction:(id)sender {
    [self insertDataDemo];
}
- (IBAction)deleteDataAction:(id)sender {
//    NSArray *arguments = @[[NSNumber numberWithInteger: self.limitIdTF.text.length == 0? 3: [self.limitIdTF.text integerValue]]];
//    // 删除数据
//    [CustomModel deleteObjectsWhere:@"WHERE employeeId < ?" arguments:arguments];
    
    [self deleteContextDemo];
}
- (IBAction)selectDataAction:(id)sender {
//    [self selectForIdDemo];
    [self selectWhereDemo];
}
- (IBAction)updateDataAction:(id)sender {
    [self updateDataDemo];
}
- (IBAction)contextUpdateDataAction:(id)sender {
    [self updateContextDataByPrimaryIdDemo];
}

#pragma mark Data Operations Demo
// 插入
- (void)insertDataDemo {
    CustomModel *model = [[CustomModel alloc] init];
    model.employeeId = [self.idTF.text integerValue];
    model.name = self.nameTF.text.length == 0? @"jolie" : self.nameTF.text;
    // 插入一条记录
    [model save];
}

- (void)insertFromDicDemo {
    NSDictionary *data = @{@"employeeId":@"2",@"name":@"jolie2"};
    // 从字典实例化数据对象
    CustomModel *anotherModel = [CustomModel objectWithDictionary:data];
    [anotherModel save];
}
// 获取数据
- (void)selectForIdDemo {
    CustomModel *model = (CustomModel *)[CustomModel objectForId:@1];
    NSString *resultText = [NSString stringWithFormat:@"employId:%lu, name:%@", model.employeeId, model.name];
    [self showInfomationWithText:resultText];
}

- (void)selectWhereDemo {
    NSArray *arguments = @[[NSNumber numberWithInteger: self.limitIdTF.text.length == 0? 3: [self.limitIdTF.text integerValue]]];
    // 通过条件获取对象数组
    NSArray *dataArray = [CustomModel objectsWhere:@"WHERE employeeId < ?" arguments: arguments];
    NSString *resultText = @"";
    for (int i = 0; i < dataArray.count; i++) {
        CustomModel *model = dataArray[i];
        resultText = [resultText stringByAppendingString:[NSString stringWithFormat:@"employId:%lu,name:%@;\n", model.employeeId, model.name]];
    }
    [self showInfomationWithText:resultText];
}
// 更新数据
- (void)updateDataDemo {
    NSString *whereSql = @"WHERE employeeId == ?";
    NSArray *arguments = @[[NSNumber numberWithInteger:self.idTF.text.length == 0? 3: [self.idTF.text integerValue]]];
    NSDictionary *set = @{@"name": self.nameTF.text.length == 0? @"jolie": self.nameTF.text};
    [CustomModel updateObjectsSet:set Where:whereSql arguments:arguments];
}

- (void)updateContextDataByPrimaryIdDemo {
    NSDictionary *set = @{@"name": self.nameTF.text.length == 0? @"jolie": self.nameTF.text};
    [[GYDataContext sharedInstance] updateObject:[CustomModel class] set:set primaryKey:[NSNumber numberWithInteger:[self.idTF.text integerValue]]];
}

- (CustomModel *)updateAndReturnContextDataByPrimaryIdDemo {
    NSDictionary *set = @{@"name": self.nameTF.text.length == 0? @"jolie": self.nameTF.text};
    return [[GYDataContext sharedInstance] updateAndReturnObject:[CustomModel class] set:set primaryKey:[NSNumber numberWithInteger:[self.idTF.text integerValue]]];
    
}
// 删
- (void)deleteContextDemo {
    NSString *whereSql = @"WHERE employeeId < ?";
    NSArray *arguments = @[[NSNumber numberWithInteger: self.limitIdTF.text.length == 0? 3: [self.limitIdTF.text integerValue]]];
    [[GYDataContext sharedInstance] deleteObjects:[CustomModel class] where:whereSql arguments:arguments];
    // 也可以根据主键删除数据
//    [[GYDataContext sharedInstance] deleteObject:[CustomModel class] primaryKey:@2];
}

- (void)deleteModelDemo {
    NSString *whereSql = @"WHERE employeeId < ?";
    NSArray *arguments = @[[NSNumber numberWithInteger: self.limitIdTF.text.length == 0? 3: [self.limitIdTF.text integerValue]]];
    [CustomModel deleteObjectsWhere:whereSql arguments:arguments];
}

// 链表查询
- (NSArray *)associationQuery {
    NSString *where = @"";
    NSArray *arguments = @[];
    //这里只创建了一张表，所以两个表都写为[QYJContactsInfo class], 实际开发是两张不同的表格
    NSArray *result = [[GYDataContext sharedInstance] getObjects:[CustomModel class]
                                                      properties:nil
                                                         objects:[CustomOtherModel class]
                                                      properties:nil
                                                        joinType:GYSQLJoinTypeInner
                                                   joinCondition:@"这里是相关联的字段"
                                                           where:where
                                                       arguments:arguments];
    
    //如果不能理解这查询的方式，可以先查一张表，再把查处来的表格，再查另外一张表  
    
    return result;
}

#pragma mark -- Others
- (void)showInfomationWithText:(NSString *)text {
    self.showResultTV.text = text;
}
@end
