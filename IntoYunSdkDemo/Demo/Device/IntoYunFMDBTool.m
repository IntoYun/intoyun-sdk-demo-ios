//
//  IntoYunFMDBTool.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/11.
//  Copyright © 2017年 hui he. All rights reserved.
//


#import "IntoYunFMDBTool.h"
#import "Macros.h"
#import "IntoSaveTool.h"
#import "MJExtension.h"

@implementation IntoYunFMDBTool

static FMDatabase *_db;

static NSString *const DEVICE_TABLE_NAME = @"device";

static NSString *const DATAPOINT_TABLE_NAME = @"datapoint";


static NSString *const PRODUCT_ID = @"productId";
static NSString *const PRIMARY_KEY = @"primary_key";
static NSString *const DEVICE_ID = @"deviceId";
static NSString *const UID = @"uid";


+ (void)initialize {
    // 1.打开数据库
//    NSString *path = [IntoSaveTool documentDirPathWithFilePath:@"IntoYunDataBase.sqlite"];
    _db = [FMDatabase databaseWithPath:IntoYunDataBasePath];
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    NSLog(@"%@", IntoYunDataBasePath);
    if ([_db open]) {
        //4.创表
        BOOL result1 = [_db executeUpdate:self.getDeviceTableSql];
        if (result1) {
            NSLog(@"创建device表成功");
        }
        BOOL result2 = [_db executeUpdate:self.getDatapointTableSql];
        if (result2) {
            NSLog(@"创建datapoint表成功");
        }
    }
}

+ (NSString *)getDeviceTableSql {
    NSMutableString *tableSql = [NSMutableString string];
    [tableSql appendFormat:@"CREATE TABLE IF NOT EXISTS %@", DEVICE_TABLE_NAME];
    [tableSql appendString:@" ("];
    [tableSql appendFormat:@"%@ TEXT PRIMARY KEY NOT NULL,", DEVICE_ID];
    [tableSql appendString:@"data blob NOT NULL,"];
    [tableSql appendFormat:@"%@ TEXT ", UID];
    [tableSql appendString:@");"];

    NSLog(@"tableSql is :%@", tableSql);
    return tableSql;
}

/**
 * 保存设备列表
 * @param devices 设备列表
 */
+ (void)saveDevices:(NSArray *)devices {
    if (_db == nil) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"IntoYunUid"];
    for (NSDictionary *device in devices) {
        // NSDictionary --> NSData
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:device];
        [_db executeUpdateWithFormat:@"INSERT OR REPLACE INTO device (deviceId, data, uid) VALUES (%@, %@, %@);", device[@"deviceId"], data, uid];
    }
}

/**
 * 删除一个指定id的设备
 * @param ID    deviceId
 */
+ (void)deleteDeviceWithID:(NSString *)ID {
    if (_db == nil) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"IntoYunUid"];
    [_db executeUpdateWithFormat:@"DELETE FROM device WHERE deviceId = %@ and uid = %@;", UID, uid];
}


/**
 * 更新设备信息
 * @param device    设备信息
 */
+ (void)updateDeviceWithID:(NSDictionary *)device {
    if (_db == nil) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"IntoYunUid"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:device];
    [_db executeUpdateWithFormat:@"UPDATE device SET data = %@ WHERE deviceId = %@ and uid = %@ ;", data, device[@"deviceId"], uid];
}

/**
 * 获取指定ID的设备
 * @param ID    设备id
 * @return      deviceinfo
 */
+ (DeviceModel *)getDeviceWithID:(NSString *)ID {
    if (_db == nil) {
        return nil;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"IntoYunUid"];
    // 执行SQL
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM device WHERE deviceId  = '%@' and uid = '%@';",ID, uid];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"data"];
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return [DeviceModel mj_objectWithKeyValues:status];
    }
    return nil;
}


/**
 * 获取设备列表
 * @return  设备列表
 */
+ (NSArray *)getDeviceListArray {
    if (_db == nil) {
        return nil;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"IntoYunUid"];
    // 根据请求参数生成对应的查询SQL语句
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM device WHERE uid = %@;", uid];
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *statuses = [NSMutableArray array];
    while (set.next) {
        NSData *statusData = [set objectForColumnName:@"data"];
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
        [statuses addObject:[DeviceModel mj_objectWithKeyValues:status]];
    }
    return statuses;
}

+ (void)cleanDevices {
    if (_db == nil) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"IntoYunUid"];
    [_db executeUpdateWithFormat:@"DELETE FROM device WHERE uid = %@", uid];
}



+ (NSString *)getDatapointTableSql {
    NSMutableString *tableSql = [NSMutableString string];
    [tableSql appendFormat:@"CREATE TABLE IF NOT EXISTS %@", DATAPOINT_TABLE_NAME];
    [tableSql appendString:@" ("];
    [tableSql appendFormat:@"%@ TEXT PRIMARY KEY NOT NULL,", PRODUCT_ID];
    [tableSql appendString:@"data blob NOT NULL,"];
    [tableSql appendFormat:@"%@ TEXT ", UID];
    [tableSql appendString:@");"];
    
    NSLog(@"tableSql is :%@", tableSql);
    
    return tableSql;
}


+ (void)saveDatapoints:(NSDictionary *)datapoints {
    if (_db == nil) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"IntoYunUid"];
    for (NSString *productId in [datapoints allKeys]) {
        // NSDictionary --> NSData
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[datapoints valueForKey:productId]];
        [_db executeUpdateWithFormat:@"INSERT OR REPLACE INTO datapoint (productId, data, uid) VALUES (%@, %@, %@);", productId, data, uid];
    }
}

+ (DatapointModel *)getDatapointWithDpID:(NSString *)productID dpID:(NSString *)dpId {
    NSArray *datapointArray = [self getDatapointListArray:productID];
    if (datapointArray != nil) {
        return [datapointArray valueForKey:dpId];
    }
    return nil;
}

+ (NSArray *)getDatapointListArray:(NSString *)productID {
    NSMutableArray *statuses = [NSMutableArray array];
    if (_db == nil) {
        return statuses;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"IntoYunUid"];
    // 根据请求参数生成对应的查询SQL语句
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM datapoint WHERE productId = '%@' and uid = '%@';", productID, uid];
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        NSData *statusData = [set objectForColumnName:@"data"];
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
        [statuses setArray:[DatapointModel mj_objectArrayWithKeyValuesArray:status]];
    }
    return statuses;
}

+ (void)cleanDatapoints {
    if (_db == nil) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"IntoYunUid"];
    [_db executeUpdateWithFormat:@"DELETE FROM datapoint WHERE uid = '%@'", uid];
}



@end
