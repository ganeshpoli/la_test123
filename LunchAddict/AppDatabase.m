//
//  AppDatabase.m
//  PetApp
//
//  Created by ramu chembeti on 03/04/13.
//  Copyright (c) 2013 ramu chembeti. All rights reserved.
//

#import "AppDatabase.h"
#import "AppConstants.h"
#import "LAAppDelegate.h"
#import "AppUtil.h"

static sqlite3 *database;

@implementation AppDatabase

+ (NSString *) getDbPath{

    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *strDirPath   = [paths objectAtIndex:0];
    
    NSString *path  = [strDirPath stringByAppendingPathComponent:@"ladb.sql"];
    
    //NSLog(@"%@",path );
    
    return path;
}

+ (void) finalizeStatements{

    sqlite3_close(database);
}

+(void) createAppDatabaseTables{
    
    if (sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK) {
        char *err;
        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS PROVIDERS(PROVIDER_ID INTEGER PRIMARY KEY AUTOINCREMENT,PROVIDER_NAME VARCHAR,USER_NAME VARCHAR, USER_HANDLER VARCHAR,ACCESS_TOKEN VARCHAR, ACCESS_TOKEN_SECRETE VARCHAR, ACCESSTOKEN_EXPIRE_TIME VARCHAR ,CREATE_DATE VARCHAR,UPDATED_DATE VARCHAR)" UTF8String], NULL, NULL, &err);
        
        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS MARCHANT_LOCATION_CHECK(LOC_ID INTEGER PRIMARY KEY AUTOINCREMENT, LAT VARCHAR, LNG VARCHAR, CREATE_DATE VARCHAR, UPDATED_DATE VARCHAR)" UTF8String], NULL, NULL, &err);
        
        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS USER_PAST_ADDRESS(ADDRESS_ID INTEGER PRIMARY KEY AUTOINCREMENT, ADDRESS_STR VARCHAR,CREATE_DATE VARCHAR, UPDATED_DATE VARCHAR)" UTF8String], NULL, NULL, &err);
        
//        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS MARCHANT(MAR_ID INTEGER PRIMARY KEY AUTOINCREMENT, IS_MARCHANT VARCHAR,FOOD_TRUCK_ID VARCHAR, FOODTRUCK_NAME VARCHAR, TWITTER_HANDLER VARCHAR, FACEBOOK_ADDRESS VARCHAR, LOCATION_ID VARCHAR, CREATE_DATE VARCHAR, UPDATED_DATE VARCHAR)" UTF8String], NULL, NULL, &err);
        
        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS MARCHANT(MAR_ID INTEGER PRIMARY KEY AUTOINCREMENT, IS_MARCHANT VARCHAR,FOOD_TRUCK_ID VARCHAR, FOODTRUCK_NAME VARCHAR, TWITTER_HANDLER VARCHAR, FACEBOOK_ADDRESS VARCHAR, LOCATION_ID VARCHAR, DESCRIPTION VARCHAR, EXTRA_DESCRIPTION VARCHAR, TWITTER_NAME VARCHAR, INSTAGRAMUSER VARCHAR, YELP_ADDRESS VARCHAR, COUSIN_TEXT VARCHAR, WEBSITE VARCHAR, EMAIL_ADDRESS VARCHAR, PHONE_NUM VARCHAR, CREATE_DATE VARCHAR, UPDATED_DATE VARCHAR)" UTF8String], NULL, NULL, &err);
        
        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS APP_REGISTER(APP_ID INTEGER PRIMARY KEY AUTOINCREMENT, USERID VARCHAR,EMAIL VARCHAR,NAME VARCHAR, DEVICEID VARCHAR,CREATE_DATE VARCHAR, UPDATED_DATE VARCHAR)" UTF8String], NULL, NULL, &err);
        
        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS ADD_FOOD_TRUCK_COUNT(ID INTEGER PRIMARY KEY AUTOINCREMENT, COUNT INTEGER, CREATE_DATE VARCHAR, UPDATED_DATE VARCHAR)" UTF8String], NULL, NULL, &err);
        
        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS TOKEN_CACHE_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, PROVIDER_NAME VARCHAR,USER_NAME VARCHAR,ACCESS_TOKEN VARCHAR,CHECKED_ATTEMPTS VARCHAR, MAX_LIMIT_CHECK_ATTEMPTS VARCHAR, IS_VALID VARCHAR, CREATE_DATE VARCHAR, UPDATED_DATE VARCHAR)" UTF8String], NULL, NULL, &err);
        
        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS CHECKIN_CHECKOUT_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, AT VARCHAR, ON_DATE VARCHAR, FROM_TIME VARCHAR, UNTIL_TIME VARCHAR,SUGG_FROM VARCHAR, SUGG_UNTIL VARCHAR, CHECK_IN VARCHAR, CREATE_DATE VARCHAR, UPDATED_DATE VARCHAR, LOCATION_ID VARCHAR)" UTF8String], NULL, NULL, &err);
        
        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS FD_CONFIRM_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, FOODTRUCK_ID VARCHAR, LOCATIONID VARCHAR, CONFIRMATION VARCHAR, CREATE_DATE VARCHAR, UPDATED_DATE VARCHAR)" UTF8String], NULL, NULL, &err);
        
        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS HASH_TAG_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, LOGGED_USER_FACEBOOK VARCHAR, LOGGED_USER_TWITTER VARCHAR, LOGGED_MAR_FACEBOOK VARCHAR, LOGGED_MAR_TWITTER VARCHAR)" UTF8String], NULL, NULL, &err);
        
        sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS RECENT_FOOD_TRUCK_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, LOCATION_ID VARCHAR,FOODTRUCK_ID VARCHAR, NAME VARCHAR,DESCRIPTION VARCHAR,EXTRA_DESCRIPTION VARCHAR,TWITTER_HANDLE VARCHAR,TWITTER_NAME VARCHAR,FACEBOOK_ADDRESS VARCHAR,INSTAGRAM_USERNAME VARCHAR,YELP_ADDRESS VARCHAR,COUSIN_TEXT VARCHAR,LATITUDE VARCHAR,LONGITUDE VARCHAR,WEBSITE VARCHAR,DISTANCE  VARCHAR,STATUS  VARCHAR,EMAIL_ADDRESS VARCHAR,PHONE_NUM VARCHAR,OPEN_DATE VARCHAR,CLOSE_DATE VARCHAR,ICON VARCHAR,MERCHANT VARCHAR)" UTF8String], NULL, NULL, &err);
        
        if (![self checkColumnExists:@"LOCATION_ID" inTable:@"CHECKIN_CHECKOUT_TABLE"]) {
            sqlite3_exec(database, [@"ALTER TABLE CHECKIN_CHECKOUT_TABLE ADD COLUMN LOCATION_ID VARCHAR" UTF8String], NULL, NULL, &err);
        }
        
        
        //Merchant table change
        
        
        if (![self checkColumnExists:@"DESCRIPTION" inTable:@"MARCHANT"]) {
            sqlite3_exec(database, [@"ALTER TABLE MARCHANT ADD COLUMN DESCRIPTION VARCHAR" UTF8String], NULL, NULL, &err);
        }
        
        if (![self checkColumnExists:@"EXTRA_DESCRIPTION" inTable:@"MARCHANT"]) {
            sqlite3_exec(database, [@"ALTER TABLE MARCHANT ADD COLUMN EXTRA_DESCRIPTION VARCHAR" UTF8String], NULL, NULL, &err);
        }
        
        if (![self checkColumnExists:@"TWITTER_NAME" inTable:@"MARCHANT"]) {
            sqlite3_exec(database, [@"ALTER TABLE MARCHANT ADD COLUMN TWITTER_NAME VARCHAR" UTF8String], NULL, NULL, &err);
        }
        
        if (![self checkColumnExists:@"INSTAGRAMUSER" inTable:@"MARCHANT"]) {
            sqlite3_exec(database, [@"ALTER TABLE MARCHANT ADD COLUMN INSTAGRAMUSER VARCHAR" UTF8String], NULL, NULL, &err);
        }
        
        if (![self checkColumnExists:@"YELP_ADDRESS" inTable:@"MARCHANT"]) {
            sqlite3_exec(database, [@"ALTER TABLE MARCHANT ADD COLUMN YELP_ADDRESS VARCHAR" UTF8String], NULL, NULL, &err);
        }
        
        if (![self checkColumnExists:@"COUSIN_TEXT" inTable:@"MARCHANT"]) {
            sqlite3_exec(database, [@"ALTER TABLE MARCHANT ADD COLUMN COUSIN_TEXT VARCHAR" UTF8String], NULL, NULL, &err);
        }
        
        if (![self checkColumnExists:@"WEBSITE" inTable:@"MARCHANT"]) {
            sqlite3_exec(database, [@"ALTER TABLE MARCHANT ADD COLUMN WEBSITE VARCHAR" UTF8String], NULL, NULL, &err);
        }
        
        if (![self checkColumnExists:@"EMAIL_ADDRESS" inTable:@"MARCHANT"]) {
            sqlite3_exec(database, [@"ALTER TABLE MARCHANT ADD COLUMN EMAIL_ADDRESS VARCHAR" UTF8String], NULL, NULL, &err);
        }
        
        if (![self checkColumnExists:@"PHONE_NUM" inTable:@"MARCHANT"]) {
            sqlite3_exec(database, [@"ALTER TABLE MARCHANT ADD COLUMN PHONE_NUM VARCHAR" UTF8String], NULL, NULL, &err);
        }
        
        sqlite3_close(database);
        
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"Error while opening Database . '%s'", sqlite3_errmsg(database));
        
    }
    
}


+ (void) insertHashTagSeedData{    
    if (sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        sqlite3_stmt *statement;
        
        NSString *strHashTagSqlQry  = @"SELECT COUNT(*) FROM HASH_TAG_TABLE";
        NSInteger count = 0;
        
        if(sqlite3_prepare_v2(database, [strHashTagSqlQry UTF8String], -1, &statement,nil ) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                count   = sqlite3_column_int(statement, 0);
            }
            
            
        }else{
            
            NSAssert1(0, @"INSERT SEDD DATA ERROR OCCURE . '%s'", sqlite3_errmsg(database));
            sqlite3_close(database);
            
        }
        
        //NSLog(@"Finalize statement");
        sqlite3_finalize(statement);
        
        if(count < 1){
            NSString *strDeleteQry = @"delete from HASH_TAG_TABLE";
            char *err;
            sqlite3_exec(database, [strDeleteQry UTF8String], NULL, NULL, &err);
            
            NSString *strQry1 = [NSString stringWithFormat:@"INSERT INTO HASH_TAG_TABLE(LOGGED_USER_FACEBOOK, LOGGED_USER_TWITTER, LOGGED_MAR_FACEBOOK, LOGGED_MAR_TWITTER) VALUES ('','','','')"];
            
            sqlite3_exec(database, [strQry1 UTF8String], NULL, NULL, &err);
            
        }
        
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"Error while opening Database . '%s'", sqlite3_errmsg(database));
        
    }
    
    
}

+ (void) insertCheckInCheckOutSeedData{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:APP_DB_DATE_FORMATE];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [df stringFromDate:now];
    
    if (sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        sqlite3_stmt *statement;
        
        NSString *strCheckinchekoutCountSqlQry  = @"SELECT COUNT(*) FROM CHECKIN_CHECKOUT_TABLE";
        NSInteger count = 0;
        
        if(sqlite3_prepare_v2(database, [strCheckinchekoutCountSqlQry UTF8String], -1, &statement,nil ) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                count   = sqlite3_column_int(statement, 0);
            }
            
            
        }else{
            
            NSAssert1(0, @"INSERT SEDD DATA ERROR OCCURE . '%s'", sqlite3_errmsg(database));
            sqlite3_close(database);
            
        }
        
       // NSLog(@"Finalize statement");
        sqlite3_finalize(statement);
        
        if(count < 1){
            NSString *strDeleteQry = @"delete from CHECKIN_CHECKOUT_TABLE";
            char *err;
            sqlite3_exec(database, [strDeleteQry UTF8String], NULL, NULL, &err);
            
            NSString *strQry1 = [NSString stringWithFormat:@"INSERT INTO CHECKIN_CHECKOUT_TABLE(CHECK_IN,AT, ON_DATE, FROM_TIME, UNTIL_TIME,SUGG_FROM, SUGG_UNTIL, CREATE_DATE, UPDATED_DATE) VALUES ('YES','','','','','','','%@','%@')", dateString, dateString];
            
            sqlite3_exec(database, [strQry1 UTF8String], NULL, NULL, &err);
            
        }
        
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"Error while opening Database . '%s'", sqlite3_errmsg(database));
        
    }
    
    
}


+(void) deleteAllCheckinDetails{    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:APP_DB_DATE_FORMATE];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [df stringFromDate:now];
    
    if (sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        NSString *strDeleteQry = @"delete from CHECKIN_CHECKOUT_TABLE";
        char *err;
        sqlite3_exec(database, [strDeleteQry UTF8String], NULL, NULL, &err);
        NSString *strQry1 = [NSString stringWithFormat:@"INSERT INTO CHECKIN_CHECKOUT_TABLE(CHECK_IN,AT, ON_DATE, FROM_TIME, UNTIL_TIME,SUGG_FROM, SUGG_UNTIL, CREATE_DATE, UPDATED_DATE) VALUES ('YES','','','','','','','%@','%@')", dateString, dateString];
            
        sqlite3_exec(database, [strQry1 UTF8String], NULL, NULL, &err);
    }
    
}


+ (void) insertAddFoodTruckSeedData{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:APP_DB_DATE_FORMATE];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [df stringFromDate:now];
    
    if (sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        sqlite3_stmt *statement;
        
        NSString *strAddFoodtruckCountSqlQry    = @"SELECT COUNT(*) FROM ADD_FOOD_TRUCK_COUNT";
        NSInteger count = 0;
        
        if(sqlite3_prepare_v2(database, [strAddFoodtruckCountSqlQry UTF8String], -1, &statement,nil ) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                count   = sqlite3_column_int(statement, 0);
            }
            
            
        }else{
            
            NSAssert1(0, @"INSERT SEDD DATA ERROR OCCURE . '%s'", sqlite3_errmsg(database));
            sqlite3_close(database);
            
        }
        
        //NSLog(@"Finalize statement");
        sqlite3_finalize(statement);
        
        if(count < 1){
            NSString *strDeleteQry = @"delete from ADD_FOOD_TRUCK_COUNT";
            char *err;
            sqlite3_exec(database, [strDeleteQry UTF8String], NULL, NULL, &err);
            
            NSString *strQry1 = [NSString stringWithFormat:@"INSERT INTO ADD_FOOD_TRUCK_COUNT(COUNT,CREATE_DATE, UPDATED_DATE) VALUES (0,'%@','%@')", dateString, dateString];
            
            sqlite3_exec(database, [strQry1 UTF8String], NULL, NULL, &err);
            
        }
        
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"Error while opening Database . '%s'", sqlite3_errmsg(database));
        
    }}


+ (void) insertUserMerchantSeedData{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:APP_DB_DATE_FORMATE];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [df stringFromDate:now];
    
    if (sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        sqlite3_stmt *statement;
        
        NSString *strMarchantCountSqlQry        = @"SELECT COUNT(*) FROM MARCHANT";
        NSInteger count = 0;
        
        if(sqlite3_prepare_v2(database, [strMarchantCountSqlQry UTF8String], -1, &statement,nil ) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                count   = sqlite3_column_int(statement, 0);
            }
            
            
        }else{
            
            NSAssert1(0, @"INSERT SEDD DATA ERROR OCCURE . '%s'", sqlite3_errmsg(database));
            sqlite3_close(database);
            
        }
        
        //NSLog(@"Finalize statement");
        sqlite3_finalize(statement);
        
        if(count < 1){
            NSString *strDeleteQry = @"delete from MARCHANT";
            char *err;
            sqlite3_exec(database, [strDeleteQry UTF8String], NULL, NULL, &err);
            
            NSString *strQry1 = [NSString stringWithFormat:@"INSERT INTO MARCHANT(IS_MARCHANT,CREATE_DATE, UPDATED_DATE) VALUES ('NO','%@','%@')", dateString, dateString];
            
            sqlite3_exec(database, [strQry1 UTF8String], NULL, NULL, &err);
            
        }
        
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"Error while opening Database . '%s'", sqlite3_errmsg(database));
        
    }}


+ (void) insertUserPastAddressSeedData{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:APP_DB_DATE_FORMATE];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [df stringFromDate:now];
    
    if (sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        sqlite3_stmt *statement;
        
        NSString *strUserPastAddressCountSqlQry = @"SELECT COUNT(*) FROM USER_PAST_ADDRESS";
        NSInteger count = 0;
        
        if(sqlite3_prepare_v2(database, [strUserPastAddressCountSqlQry UTF8String], -1, &statement,nil ) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                count   = sqlite3_column_int(statement, 0);
            }
            
            
        }else{
            
            NSAssert1(0, @"INSERT SEDD DATA ERROR OCCURE . '%s'", sqlite3_errmsg(database));
            sqlite3_close(database);
            
        }
        
       // NSLog(@"Finalize statement");
        sqlite3_finalize(statement);
        
        if(count < 1){
            NSString *strDeleteQry = @"delete from USER_PAST_ADDRESS";
            char *err;
            sqlite3_exec(database, [strDeleteQry UTF8String], NULL, NULL, &err);
            
            NSString *strQry1 = [NSString stringWithFormat:@"INSERT INTO USER_PAST_ADDRESS(ADDRESS_STR,CREATE_DATE, UPDATED_DATE) VALUES ('%@','%@','%@')", PASTADDRESS,dateString, dateString];
            
            sqlite3_exec(database, [strQry1 UTF8String], NULL, NULL, &err);
            
        }
        
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"Error while opening Database . '%s'", sqlite3_errmsg(database));
        
    }}



+ (void) insertProviderSeedData{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:APP_DB_DATE_FORMATE];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [df stringFromDate:now];
    
    if (sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        sqlite3_stmt *statement;
        
        NSString *strProviderCountSqlQry        = @"SELECT COUNT(*) FROM PROVIDERS";
        NSInteger count = 0;
        
        if(sqlite3_prepare_v2(database, [strProviderCountSqlQry UTF8String], -1, &statement,nil ) == SQLITE_OK){
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                count   = sqlite3_column_int(statement, 0);
            }
            
            
        }else{
            
            NSAssert1(0, @"INSERT SEDD DATA ERROR OCCURE . '%s'", sqlite3_errmsg(database));
            sqlite3_close(database);
            
        }
        
        //NSLog(@"Finalize statement");
        sqlite3_finalize(statement);
        
        if(count < 2){
            NSString *strDeleteQry = @"delete from PROVIDERS";
            char *err;
            sqlite3_exec(database, [strDeleteQry UTF8String], NULL, NULL, &err);
            
            NSString *strQry1 = [NSString stringWithFormat:@"INSERT INTO PROVIDERS (PROVIDER_NAME,CREATE_DATE,UPDATED_DATE) VALUES ('FACEBOOK','%@','%@')", dateString, dateString];
            
            NSString *strQry2 = [NSString stringWithFormat:@"INSERT INTO PROVIDERS (PROVIDER_NAME,CREATE_DATE,UPDATED_DATE) VALUES ('TWITTER','%@','%@')", dateString, dateString];
            
            sqlite3_exec(database, [strQry1 UTF8String], NULL, NULL, &err);
            sqlite3_exec(database, [strQry2 UTF8String], NULL, NULL, &err);
        }
        
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"Error while opening Database . '%s'", sqlite3_errmsg(database));
        
    }}



+ (BOOL) loadUserid{
    bool isload = NO;
    sqlite3_stmt *statement;
    NSString *strQry = @"select USERID from APP_REGISTER";
    
    LAAppDelegate *appDelegate = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if(sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *userid            = (char *)sqlite3_column_text(statement, 0);
                appDelegate.userid      = [[NSString alloc] initWithUTF8String:userid];
            }
        }
        
        sqlite3_finalize(statement);
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"details query fail '%s'", sqlite3_errmsg(database));
    }
    
    sqlite3_close(database);
    
    if(appDelegate.userid != nil && appDelegate.userid != NULL && [[appDelegate.userid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0){
        isload = YES;
    }
    
    
    return  isload;
}

+ (void) insertUserId:(RegistrationVO *)regVO{
    if(regVO != nil){
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:APP_DB_DATE_FORMATE];
        NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [df stringFromDate:now];
        
        sqlite3_stmt *statement;
        NSString *strQry    = @"INSERT INTO APP_REGISTER  (USERID,EMAIL,NAME,DEVICEID,CREATE_DATE, UPDATED_DATE) VALUES (?,?,?,?,?,?)";
        
        if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [regVO.userid UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 2, [regVO.email UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 3, [regVO.name UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 4, [regVO.deviceid UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 5, [dateString UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 6, [dateString UTF8String ], -1, NULL);            }
            
            if(sqlite3_step(statement) == SQLITE_DONE){
               NSLog(@"user registration details are inserted successfully");
            }else{
                
                NSAssert1(0, @"user registration details insert query fail '%s'", sqlite3_errmsg(database));
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
            
            
        }else{
            sqlite3_close(database);
            NSAssert1(0, @"details query fail '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_close(database);
        
    }
}


+ (NSMutableArray *) loadPastAddress{
    NSMutableArray *arObjs  = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *strQry = @"select ADDRESS_STR from USER_PAST_ADDRESS";
    
    NSString *strPastAddress = @"";
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if(sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *pastaddress   = (char *)sqlite3_column_text(statement, 0);
                strPastAddress      = [[NSString alloc] initWithUTF8String:pastaddress];
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
        }
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"details query fail '%s'", sqlite3_errmsg(database));
    }
    
    if(strPastAddress != nil && [[strPastAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0){
        NSArray *arr    = [strPastAddress componentsSeparatedByString:@"&"];
        [arObjs addObjectsFromArray:arr];
    }
    
    return arObjs;
}


//sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS RECENT_FOOD_TRUCK_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, LOCATION_ID VARCHAR,FOODTRUCK_ID VARCHAR, NAME VARCHAR,DESCRIPTION VARCHAR,EXTRA_DESCRIPTION VARCHAR,TWITTER_HANDLE VARCHAR,TWITTER_NAME VARCHAR,FACEBOOK_ADDRESS VARCHAR,INSTAGRAM_USERNAME VARCHAR,YELP_ADDRESS VARCHAR,COUSIN_TEXT VARCHAR,LATITUDE VARCHAR,LONGITUDE VARCHAR,WEBSITE VARCHAR,DISTANCE  VARCHAR,STATUS  VARCHAR,EMAIL_ADDRESS VARCHAR,PHONE_NUM VARCHAR,OPEN_DATE VARCHAR,CLOSE_DATE VARCHAR,ICON VARCHAR,MERCHANT VARCHAR)" UTF8String], NULL, NULL, &err);


+ (NSMutableArray *) loadRecentFoodTrucks{
    NSMutableArray *arObjs  = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *strQry = @"select LOCATION_ID,FOODTRUCK_ID, NAME,DESCRIPTION,EXTRA_DESCRIPTION,TWITTER_HANDLE,TWITTER_NAME,FACEBOOK_ADDRESS,INSTAGRAM_USERNAME,YELP_ADDRESS,COUSIN_TEXT,LATITUDE,LONGITUDE,WEBSITE,DISTANCE,STATUS,EMAIL_ADDRESS,PHONE_NUM,OPEN_DATE,CLOSE_DATE,ICON,MERCHANT from RECENT_FOOD_TRUCK_TABLE";
    
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if(sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                FoodTruckVO *foodtruckVO = [[FoodTruckVO alloc] init];
                
                char *locationid        = (char *)sqlite3_column_text(statement, 0);
                char *foodtruckid       = (char *)sqlite3_column_text(statement, 1);
                char *foodtruckname     = (char *)sqlite3_column_text(statement, 2);
                char *description       = (char *)sqlite3_column_text(statement, 3);
                char *extra_description = (char *)sqlite3_column_text(statement, 4);
                char *twitterhandle     = (char *)sqlite3_column_text(statement, 5);
                char *twittername       = (char *)sqlite3_column_text(statement, 6);
                char *facebookaddress   = (char *)sqlite3_column_text(statement, 7);
                char *instagramuser     = (char *)sqlite3_column_text(statement, 8);
                char *yelpaddress       = (char *)sqlite3_column_text(statement, 9);
                char *cousintext        = (char *)sqlite3_column_text(statement, 10);
                char *latitude          = (char *)sqlite3_column_text(statement, 11);
                char *longitude         = (char *)sqlite3_column_text(statement, 12);
                char *website           = (char *)sqlite3_column_text(statement, 13);
                char *distance          = (char *)sqlite3_column_text(statement, 14);
                char *status            = (char *)sqlite3_column_text(statement, 15);
                char *emailaddress      = (char *)sqlite3_column_text(statement, 16);
                char *phonenum          = (char *)sqlite3_column_text(statement, 17);
                char *opendate          = (char *)sqlite3_column_text(statement, 18);
                char *closedate         = (char *)sqlite3_column_text(statement, 19);
                char *icon              = (char *)sqlite3_column_text(statement, 20);
                char *ismerchant        = (char *)sqlite3_column_text(statement, 21);
                
                
                foodtruckVO.isMerchant  =[[NSString alloc] initWithUTF8String:((ismerchant==NULL)?[@"" UTF8String]:ismerchant)];
                foodtruckVO.foodtruckid =[[NSString alloc] initWithUTF8String:((foodtruckid==NULL)?[@"" UTF8String]:foodtruckid)];
                foodtruckVO.name =[[NSString alloc] initWithUTF8String:((foodtruckname==NULL)?[@"" UTF8String]:foodtruckname)];
                foodtruckVO.twitterHandle =[[NSString alloc] initWithUTF8String:((twitterhandle==NULL)?[@"" UTF8String]:twitterhandle)];
                foodtruckVO.facebookAddress =[[NSString alloc] initWithUTF8String:((facebookaddress==NULL)?[@"" UTF8String]:facebookaddress)];
                foodtruckVO.locationid =[[NSString alloc] initWithUTF8String:((locationid==NULL)?[@"" UTF8String]:locationid)];
                foodtruckVO.description =[[NSString alloc] initWithUTF8String:((description==NULL)?[@"" UTF8String]:description)];
                foodtruckVO.extraDescription =[[NSString alloc] initWithUTF8String:((extra_description==NULL)?[@"" UTF8String]:extra_description)];
                foodtruckVO.twitterName =[[NSString alloc] initWithUTF8String:((twittername==NULL)?[@"" UTF8String]:twittername)];
                foodtruckVO.instagramUserName =[[NSString alloc] initWithUTF8String:((instagramuser==NULL)?[@"" UTF8String]:instagramuser)];
                foodtruckVO.yelpAddress =[[NSString alloc] initWithUTF8String:((yelpaddress==NULL)?[@"" UTF8String]:yelpaddress)];
                foodtruckVO.cousineText =[[NSString alloc] initWithUTF8String:((cousintext==NULL)?[@"" UTF8String]:cousintext)];
                foodtruckVO.website =[[NSString alloc] initWithUTF8String:((website==NULL)?[@"" UTF8String]:website)];
                foodtruckVO.emailAddress =[[NSString alloc] initWithUTF8String:((emailaddress==NULL)?[@"" UTF8String]:emailaddress)];
                foodtruckVO.phoneNum =[[NSString alloc] initWithUTF8String:((phonenum==NULL)?[@"" UTF8String]:phonenum)];
                
                
                if (latitude != NULL) {
                    
                    foodtruckVO.lat =[[NSNumber alloc] initWithDouble:[[[NSString alloc] initWithUTF8String:latitude] doubleValue]];
                }else{
                    
                    foodtruckVO.lat = [[NSNumber alloc] initWithDouble:0.0];
                }
                
                
                if (longitude != NULL) {
                    
                    foodtruckVO.lng =[[NSNumber alloc] initWithDouble:[[[NSString alloc] initWithUTF8String:longitude] doubleValue]];
                }else{
                    
                    foodtruckVO.lng = [[NSNumber alloc] initWithDouble:0.0];
                }
                
                
                if (distance != NULL) {
                    
                    foodtruckVO.distance =[[NSNumber alloc] initWithDouble:[[[NSString alloc] initWithUTF8String:distance] doubleValue]];
                }else{
                    
                    foodtruckVO.distance = [[NSNumber alloc] initWithDouble:0.0];
                }
                
                foodtruckVO.status =[[NSString alloc] initWithUTF8String:((status==NULL)?[@"" UTF8String]:status)];
                foodtruckVO.openDate =[[NSString alloc] initWithUTF8String:((opendate==NULL)?[@"" UTF8String]:opendate)];
                foodtruckVO.closeDate =[[NSString alloc] initWithUTF8String:((closedate==NULL)?[@"" UTF8String]:closedate)];
                foodtruckVO.icon =[[NSString alloc] initWithUTF8String:((icon==NULL)?[@"" UTF8String]:icon)];
                
                
                [arObjs addObject:foodtruckVO];
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
        }
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"details query fail '%s'", sqlite3_errmsg(database));
    }
    
    
    
    return arObjs;
}


+ (void) updatePastAddress{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:APP_DB_DATE_FORMATE];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [df stringFromDate:now];
    
    sqlite3_stmt *statement;
    
    LAAppDelegate *appDelegate = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *strQry = @"UPDATE USER_PAST_ADDRESS SET ADDRESS_STR = ? ,UPDATED_DATE= ? where ADDRESS_ID = 1";
    
    NSMutableArray *arrPastAddress = appDelegate.arrPastAddress;
    
    NSString *strPastAddress = [[NSString alloc] init];
    
    for (int i=0; i< [arrPastAddress count]; i++) {
        if(i==0){
            strPastAddress = [strPastAddress stringByAppendingString:[arrPastAddress objectAtIndex:i]];
        }else{
            strPastAddress = [strPastAddress stringByAppendingString:@"&"];
            strPastAddress = [strPastAddress stringByAppendingString:[arrPastAddress objectAtIndex:i]];
        }
    }
    
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [strPastAddress UTF8String ], -1, NULL);
            sqlite3_bind_text(statement, 2, [dateString UTF8String ], -1, NULL);
        }
        
        if(sqlite3_step(statement) == SQLITE_DONE){
           NSLog(@"user past address are updated successfully");
        }else{
            NSAssert1(0, @"user past address updated query fail '%s'", sqlite3_errmsg(database));
        }
        
        //NSLog(@"Finalize statement");
        sqlite3_finalize(statement);
        
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"user past address updated query fail '%s'", sqlite3_errmsg(database));
    }
}

+ (void) loadusercredentials{
    LAAppDelegate *appDelegate = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.userVO  = [[UserVO alloc] init];
    sqlite3_stmt *statement1;
    NSString *strQry1    = @"select PROVIDER_ID,PROVIDER_NAME,USER_NAME, USER_HANDLER,ACCESS_TOKEN, ACCESS_TOKEN_SECRETE, ACCESSTOKEN_EXPIRE_TIME,CREATE_DATE,UPDATED_DATE from PROVIDERS";
    
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if(sqlite3_prepare_v2(database, [strQry1 UTF8String], -1, &statement1, nil) == SQLITE_OK){
            while (sqlite3_step(statement1) == SQLITE_ROW) {
                char *providername          = (char *)sqlite3_column_text(statement1, 1);
                char *username              = (char *)sqlite3_column_text(statement1, 2);
                char *userhamdler           = (char *)sqlite3_column_text(statement1, 3);
                char *accesstoken           = (char *)sqlite3_column_text(statement1, 4);
                char *accesstokensecrete    = (char *)sqlite3_column_text(statement1, 5);
                char *accessexpire          = (char *)sqlite3_column_text(statement1, 6);
                
                NSString *strProviderName       = [[NSString alloc] initWithUTF8String:providername];
                NSString *strUserHandler,*strUserName,*strAccessToken,*strAccessTokenScrete,*strAccessExpire;
                
                
                if (userhamdler == NULL) {
                    strUserHandler = @"";
                }else{
                    strUserHandler        = [[NSString alloc] initWithUTF8String:userhamdler];
                }
                
                if (username == NULL) {
                    strUserName = @"";
                }else{
                     strUserName           = [[NSString alloc] initWithUTF8String:username];
                }
                
                if (accesstoken == NULL) {
                    strAccessToken = @"";
                }else{
                     strAccessToken        = [[NSString alloc] initWithUTF8String:accesstoken];
                }
                
                if (accesstokensecrete == NULL) {
                    strAccessTokenScrete = @"";
                }else{
                    strAccessTokenScrete  = [[NSString alloc] initWithUTF8String:accesstokensecrete];
                }
                
                if (accessexpire == NULL) {
                    strAccessExpire = @"";
                }else{
                    strAccessExpire       = [[NSString alloc] initWithUTF8String:accessexpire];
                }
                
                
                
                if([strProviderName isEqualToString:FACEBOOK]){
                    appDelegate.userVO.facebookName                 = strUserName;
                    appDelegate.userVO.facebookHandler              = strUserHandler;
                    appDelegate.userVO.facebookAccessToken          = strAccessToken;
                    appDelegate.userVO.faceboolAccessTokenExpire    = strAccessExpire;
                    
                }else if([strProviderName isEqualToString:TWITTER]){
                    appDelegate.userVO.twitterName                 = strUserName;
                    appDelegate.userVO.twitterHanbler              = strUserHandler;
                    appDelegate.userVO.twitterAccessToken          = strAccessToken;
                    appDelegate.userVO.twitterAccessTokenScrete    = strAccessTokenScrete;
                }
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement1);
            
            sqlite3_stmt *statement2;
            
            NSString *strQry2    = @"select IS_MARCHANT,FOOD_TRUCK_ID,FOODTRUCK_NAME,LOCATION_ID from MARCHANT where MAR_ID = 1";
            
            if(sqlite3_prepare_v2(database, [strQry2 UTF8String], -1, &statement2, nil) == SQLITE_OK){
                while (sqlite3_step(statement2) == SQLITE_ROW) {
                    char *isMar          = (char *)sqlite3_column_text(statement2, 0);
                    char *fdid           = (char *)sqlite3_column_text(statement2, 1);
                    char *fdName         = (char *)sqlite3_column_text(statement2, 2);
                    char *locationid     = (char *)sqlite3_column_text(statement2, 3);
                    
                    NSString *strIsMar       = [[NSString alloc] initWithUTF8String:((isMar==NULL)?[@"" UTF8String]:isMar)];
                    NSString *strFdId        = [[NSString alloc] initWithUTF8String:((fdid==NULL)?[@"" UTF8String]:fdid)];
                    NSString *strFdName      = [[NSString alloc] initWithUTF8String:((fdName==NULL)?[@"" UTF8String]:fdName)];
                    NSString *strLocationID  = [[NSString alloc] initWithUTF8String:((locationid==NULL)?[@"" UTF8String]:locationid)];
                    
                    if([strIsMar isEqualToString:@"YES"]){
                        appDelegate.userVO.isMarchant = YES;
                        appDelegate.userVO.foodtruckid = strFdId;
                        appDelegate.userVO.foodtruckLocationId = strLocationID;
                        appDelegate.userVO.foodtruckname = strFdName;
                        
                    }else{
                        appDelegate.userVO.isMarchant = NO;
                        appDelegate.userVO.foodtruckid = @"";
                        appDelegate.userVO.foodtruckLocationId = @"";
                        appDelegate.userVO.foodtruckname = @"";
                    }
                    
                }
                    
                //NSLog(@"Finalize statement");
                sqlite3_finalize(statement2);
            }
            
            
        }
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"details query fail '%s'", sqlite3_errmsg(database));
    }
    
}

+ (BOOL) hasAddFoodTruckLimitExceed{
    BOOL isExceed   = YES;
    LAAppDelegate *appDelegate = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    sqlite3_stmt *statement;
    NSString *strUpdateDate;
    int count = 0;
    
    NSString *strQry    = @"select COUNT,UPDATED_DATE from ADD_FOOD_TRUCK_COUNT where ID=1";
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if(sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                count                   = sqlite3_column_int(statement, 0);
                char *charupdatedate    = (char *)sqlite3_column_text(statement, 1);
                strUpdateDate           = [[NSString alloc] initWithUTF8String:charupdatedate];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:APP_DB_DATE_FORMATE];
                NSDate *updatedate = [df dateFromString:strUpdateDate];                
                NSComparisonResult result   = [AppUtil compareDateOnly:updatedate];
                
                if (result == NSOrderedSame) {
                    //NSLog(@"today date");
                    
                    if(appDelegate.userVO.twitterLogin || appDelegate.userVO.facebookLogin){
                        if(count < appDelegate.settingsVO.afterlogin){
                            isExceed = NO;
                            count ++;
                            appDelegate.numAddFoodTruckCount = [[NSNumber alloc] initWithInt:count];
                        }
                    }else{
                        if(count < appDelegate.settingsVO.beforelogin){
                            isExceed = NO;
                            count ++;
                            appDelegate.numAddFoodTruckCount = [[NSNumber alloc] initWithInt:count];
                        }
                    }
                    
                }else if(result == NSOrderedDescending){
                    isExceed = NO;
                    count = 1;
                    appDelegate.numAddFoodTruckCount = [[NSNumber alloc] initWithInt:count];
                    
                }
                
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
        }
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"details query fail '%s'", sqlite3_errmsg(database));
    }
    
    return isExceed;
}

+ (void) saveAddFoodTruckCount{
    LAAppDelegate *appDelegate = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:APP_DB_DATE_FORMATE];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [df stringFromDate:now];
    
    sqlite3_stmt *statement;
    
    NSString *strQry = @"UPDATE ADD_FOOD_TRUCK_COUNT SET COUNT = ? ,UPDATED_DATE = ? where ID = 1";
    
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [appDelegate.numAddFoodTruckCount intValue]);
            sqlite3_bind_text(statement, 2, [dateString UTF8String ], -1, NULL);
        }
        
        if(sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"add food truck count  updated successfully");
        }else{
            NSAssert1(0, @"add food truck count updated query fail '%s'", sqlite3_errmsg(database));
        }
        
        //NSLog(@"Finalize statement");
        sqlite3_finalize(statement);
        
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"add food truck count updated query fail '%s'", sqlite3_errmsg(database));
    }
}

+ (void) saveSocialNetworkInfo:(SocialNetworkVO *)socialNetworkVO isLogin:(BOOL)islogin isSessionValid:(BOOL)isSessionValid{
    if(socialNetworkVO != nil){
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:APP_DB_DATE_FORMATE];
        NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [df stringFromDate:now];
        
        sqlite3_stmt *statement;
        
        NSString *strQry = [NSString stringWithFormat:@"UPDATE PROVIDERS SET USER_NAME = ?, USER_HANDLER = ?,ACCESS_TOKEN = ?, ACCESS_TOKEN_SECRETE = ?, ACCESSTOKEN_EXPIRE_TIME = ?,UPDATED_DATE = ? where PROVIDER_NAME LIKE '%@'", socialNetworkVO.providerName];
        
        if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [socialNetworkVO.username UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 2, [socialNetworkVO.userHandler UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 3, [socialNetworkVO.accessToken UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 4, [socialNetworkVO.accessTokenSecrete UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 5, [socialNetworkVO.accessTokenExpire UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 6, [dateString UTF8String ], -1, NULL);
                
            }
            
            if(sqlite3_step(statement) == SQLITE_DONE){
               // NSLog(@"social network updated successfully");
                
                LAAppDelegate *appDelegate = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
                
                if ([TWITTER isEqualToString: socialNetworkVO.providerName]) {
                    
                    appDelegate.userVO.twitterLogin         = islogin;
                    appDelegate.userVO.isValidTwitterToken  = isSessionValid;
                    appDelegate.userVO.twitterAccessToken   = socialNetworkVO.accessToken;
                    appDelegate.userVO.twitterAccessTokenScrete = socialNetworkVO.accessTokenSecrete;
                    appDelegate.userVO.twitterName              = socialNetworkVO.username;
                    appDelegate.userVO.twitterHanbler           = socialNetworkVO.userHandler;
                    
                    
                }else if ([FACEBOOK isEqualToString:socialNetworkVO.providerName]){
                    appDelegate.userVO.facebookLogin         = islogin;
                    appDelegate.userVO.isValidFbToken        = isSessionValid;
                    appDelegate.userVO.facebookAccessToken   = socialNetworkVO.accessToken;
                    appDelegate.userVO.faceboolAccessTokenExpire = socialNetworkVO.accessTokenExpire;
                    appDelegate.userVO.facebookName              = socialNetworkVO.username;
                    appDelegate.userVO.facebookHandler           = socialNetworkVO.userHandler;
                }
                
            }else{
                NSAssert1(0, @"social network updated query fail '%s'", sqlite3_errmsg(database));
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
            
        }else{
            sqlite3_close(database);
            NSAssert1(0, @"social network updated query fail '%s'", sqlite3_errmsg(database));
        }
        
    }
}

+ (void) updateMerchantData:(FoodTruckVO *)fdVO{
    if (fdVO != nil) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:APP_DB_DATE_FORMATE];
        NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [df stringFromDate:now];
        
        sqlite3_stmt *statement;
        
//        MAR_ID INTEGER PRIMARY KEY AUTOINCREMENT, IS_MARCHANT VARCHAR,FOOD_TRUCK_ID VARCHAR, FOODTRUCK_NAME VARCHAR, TWITTER_HANDLER VARCHAR, FACEBOOK_ADDRESS VARCHAR, LOCATION_ID VARCHAR, DESCRIPTION VARCHAR, EXTRA_DESCRIPTION VARCHAR, TWITTER_NAME VARCHAR, INSTAGRAMUSER VARCHAR, YELP_ADDRESS VARCHAR, COUSIN_TEXT VARCHAR, WEBSITE VARCHAR, EMAIL_ADDRESS VARCHAR, PHONE_NUM VARCHAR, CREATE_DATE VARCHAR, UPDATED_DATE VARCHAR
        
        NSString *strQry = @"UPDATE MARCHANT SET  IS_MARCHANT=?,FOOD_TRUCK_ID=?, FOODTRUCK_NAME=?, TWITTER_HANDLER=?, FACEBOOK_ADDRESS=?, LOCATION_ID=?, DESCRIPTION=?, EXTRA_DESCRIPTION =?, TWITTER_NAME=?, INSTAGRAMUSER=?, YELP_ADDRESS=?, COUSIN_TEXT=?, WEBSITE=?, EMAIL_ADDRESS=?, PHONE_NUM=?, UPDATED_DATE=? where MAR_ID=1";
        
        if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [fdVO.isMerchant UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 2, [fdVO.foodtruckid UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 3, [fdVO.name UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 4, [fdVO.twitterHandle UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 5, [fdVO.facebookAddress UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 6, [fdVO.locationid UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 7, [fdVO.description UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 8, [fdVO.extraDescription UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 9, [fdVO.twitterName UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 10, [fdVO.instagramUserName UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 11, [fdVO.yelpAddress UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 12, [fdVO.cousineText UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 13, [fdVO.website UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 14, [fdVO.emailAddress UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 15, [fdVO.phoneNum UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 16, [dateString UTF8String ], -1, NULL);
                
            }
            
            if(sqlite3_step(statement) == SQLITE_DONE){
               // NSLog(@"merchant updated successfully");
                
                LAAppDelegate *appDelegate = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
                
                if([APP_YES isEqualToString:fdVO.isMerchant]){
                    appDelegate.userVO.isMarchant = YES;
                }else if([APP_NO isEqualToString:fdVO.isMerchant]){
                    appDelegate.userVO.isMarchant = NO;
                }
                
                appDelegate.userVO.foodtruckid          = fdVO.foodtruckid;
                appDelegate.userVO.foodtruckLocationId  = fdVO.locationid;
                appDelegate.userVO.foodtruckname        = fdVO.name;
                
            }else{
                NSAssert1(0, @"merchant updated query fail '%s'", sqlite3_errmsg(database));
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
            
        }else{
            sqlite3_close(database);
            NSAssert1(0, @"merchant updated query fail '%s'", sqlite3_errmsg(database));
        }
    }
}


+ (FdConfirmVO *)getFoodTruckFromLocationCache:(FoodTruckVO *)ifdvo{
    FdConfirmVO *fdConfirmVO = nil;
    sqlite3_stmt *statement;
    
    NSString *strQry =  [NSString stringWithFormat:@"select ID , FOODTRUCK_ID , LOCATIONID , CONFIRMATION , CREATE_DATE,UPDATED_DATE  from FD_CONFIRM_TABLE where FOODTRUCK_ID='%@' AND LOCATIONID='%@'",ifdvo.foodtruckid,ifdvo.locationid ];
    
    
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if(sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int tid       = sqlite3_column_int(statement, 0);
                char *fdid    = (char *)sqlite3_column_text(statement, 1);
                char *fdlocationid          = (char *)sqlite3_column_text(statement, 2);
                char *fdconfirmation        = (char *)sqlite3_column_text(statement, 3);
                char *fdcreateddate         = (char *)sqlite3_column_text(statement, 4);
                char *fdupdatedate          = (char *)sqlite3_column_text(statement, 5);
                
                fdConfirmVO = [[FdConfirmVO alloc] init];
                
                fdConfirmVO.tID =[[NSString alloc] initWithFormat:@"%d",tid];
                fdConfirmVO.foodtruckid =[[NSString alloc] initWithUTF8String:fdid];
                fdConfirmVO.confirmation =[[NSString alloc] initWithUTF8String:fdconfirmation];
                fdConfirmVO.createddate =[[NSString alloc] initWithUTF8String:fdcreateddate];
                fdConfirmVO.updatedate =[[NSString alloc] initWithUTF8String:fdupdatedate];
                fdConfirmVO.locationid =[[NSString alloc] initWithUTF8String:fdlocationid];
                
                
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
        }
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"fd confirm details query fail '%s'", sqlite3_errmsg(database));
    }
    
    
    return fdConfirmVO;
}


+ (void)saveFDConfirmDetails:(FoodTruckVO *)ifdvo withConfirmation:(NSString *)strConfirm{
    FdConfirmVO *fdConfirmVO    = [self getFoodTruckFromLocationCache:ifdvo];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:APP_DB_DATE_FORMATE];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [df stringFromDate:now];
    
    sqlite3_stmt *statement;
    
    if(fdConfirmVO != nil){
        NSString *strQry = @"UPDATE FD_CONFIRM_TABLE SET CONFIRMATION=?,UPDATED_DATE=?  where FOODTRUCK_ID=? AND LOCATIONID=?";
        
        if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [strConfirm UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 2, [dateString UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 3, [ifdvo.foodtruckid UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 4, [ifdvo.locationid UTF8String ], -1, NULL);
            }
            
            if(sqlite3_step(statement) == SQLITE_DONE){
                NSLog(@"fdconfirm details updated successfully");
            }else{
                NSAssert1(0, @"fdconfirm details updated query fail '%s'", sqlite3_errmsg(database));
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
            
        }else{
            sqlite3_close(database);
            NSAssert1(0, @"fdconfirm details updated query fail '%s'", sqlite3_errmsg(database));
        }
    }else{
        NSString *strQry    = @"INSERT INTO FD_CONFIRM_TABLE(FOODTRUCK_ID,LOCATIONID,CONFIRMATION, CREATE_DATE,UPDATED_DATE) VALUES (?,?,?,?,?)";
        
        if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [ifdvo.foodtruckid UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 2, [ifdvo.locationid UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 3, [strConfirm UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 4, [dateString UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 5, [dateString UTF8String ], -1, NULL);
            }
            
            if(sqlite3_step(statement) == SQLITE_DONE){
                NSLog(@"FD_CONFIRM_TABLE details are inserted successfully");
            }else{
                NSAssert1(0, @"FD_CONFIRM_TABLE details insert query fail '%s'", sqlite3_errmsg(database));
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
            
        }else{
            sqlite3_close(database);
            NSAssert1(0, @"FD_CONFIRM_TABLE details query fail '%s'", sqlite3_errmsg(database));
        }
    }
}

+ (void) insertTokenIntoTokenCache:(TokenCacheVO *)tokenCacheVO{
    if(tokenCacheVO != nil){
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:APP_DB_DATE_FORMATE];
        NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [df stringFromDate:now];
        
        sqlite3_stmt *statement;
        NSString *strQry    = @"INSERT INTO TOKEN_CACHE_TABLE  (PROVIDER_NAME ,USER_NAME ,ACCESS_TOKEN ,CHECKED_ATTEMPTS , MAX_LIMIT_CHECK_ATTEMPTS , IS_VALID , CREATE_DATE , UPDATED_DATE) VALUES (?,?,?,?,?,?,?,?)";
        
        if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [tokenCacheVO.providername UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 2, [tokenCacheVO.username UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 3, [tokenCacheVO.accesstoken UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 4, [tokenCacheVO.numofattempts UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 5, [tokenCacheVO.maxlimit UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 6, [tokenCacheVO.isvalid UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 7, [dateString UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 8, [dateString UTF8String ], -1, NULL);            }
            
            if(sqlite3_step(statement) == SQLITE_DONE){
                NSLog(@"tokencache details are inserted successfully");
            }else{
                NSAssert1(0, @"token cache details insert query fail '%s'", sqlite3_errmsg(database));
            }
            
            NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
            
        }else{
            sqlite3_close(database);
            NSAssert1(0, @"token cache details query fail '%s'", sqlite3_errmsg(database));
        }
        
        //sqlite3_close(database);
        
    }
    
}
+ (void) updateTokenIntoTokenCache:(TokenCacheVO *)tokenCacheVO{
    if(tokenCacheVO != nil){
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:APP_DB_DATE_FORMATE];
        NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [df stringFromDate:now];
        
        sqlite3_stmt *statement;
        NSString *strQry    = @"UPDATE TOKEN_CACHE_TABLE SET CHECKED_ATTEMPTS=?,IS_VALID=?,UPDATED_DATE=?  where PROVIDER_NAME =?";
        
        if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [tokenCacheVO.numofattempts UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 2, [tokenCacheVO.isvalid UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 3, [dateString UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 4, [tokenCacheVO.providername UTF8String ], -1, NULL);
                
            }
            
            if(sqlite3_step(statement) == SQLITE_DONE){
                NSLog(@"tokencache details are update successfully");
            }else{
                NSAssert1(0, @"token cache details update query fail '%s'", sqlite3_errmsg(database));
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
            
        }else{
            sqlite3_close(database);
            NSAssert1(0, @"token cache details update query fail '%s'", sqlite3_errmsg(database));
        }
        
        //sqlite3_close(database);
        
    }
}
+ (void) deleteTokenIntoTokenCache:(TokenCacheVO *)tokenCacheVO{
    NSString *strDeleteQry = nil;
    sqlite3_stmt *statement ;
    if (tokenCacheVO != nil) {
        if (sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK) {
            strDeleteQry    = @"DELETE FROM TOKEN_CACHE_TABLE WHERE PROVIDER_NAME=?";
            if (sqlite3_prepare_v2(database, [strDeleteQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [tokenCacheVO.providername UTF8String ], -1, NULL);
                if(sqlite3_step(statement) == SQLITE_DONE){
                    NSLog(@"token cache are deleted successfully");
                }else{
                    NSAssert1(0, @"token cache are deleted query fail '%s'", sqlite3_errmsg(database));
                }
            }
            
        }
        
        sqlite3_finalize(statement);
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"Opendatabase error '%s'", sqlite3_errmsg(database));
    }
    
}

+ (NSMutableArray *)getListOfTokenCaches{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *strQry = @"select PROVIDER_NAME ,USER_NAME ,ACCESS_TOKEN ,CHECKED_ATTEMPTS , MAX_LIMIT_CHECK_ATTEMPTS , IS_VALID , CREATE_DATE , UPDATED_DATE  from TOKEN_CACHE_TABLE";
    
    
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if(sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *providername              = (char *)sqlite3_column_text(statement, 0);
                char *username                  = (char *)sqlite3_column_text(statement, 1);
                char *accesstoken               = (char *)sqlite3_column_text(statement, 2);
                char *checkedattempts           = (char *)sqlite3_column_text(statement, 3);
                char *maxlimit                  = (char *)sqlite3_column_text(statement, 4);
                char *isvalid                   = (char *)sqlite3_column_text(statement, 5);
                char *createddate               = (char *)sqlite3_column_text(statement, 6);
                char *updatedate                = (char *)sqlite3_column_text(statement, 7);
                
                TokenCacheVO *tokenCacheVO   = [[TokenCacheVO alloc] init];
                
                tokenCacheVO.providername = [[NSString alloc] initWithUTF8String:providername];
                tokenCacheVO.username = [[NSString alloc] initWithUTF8String:username];
                tokenCacheVO.accesstoken = [[NSString alloc] initWithUTF8String:accesstoken];
                tokenCacheVO.numofattempts = [[NSString alloc] initWithUTF8String:checkedattempts];
                tokenCacheVO.maxlimit = [[NSString alloc] initWithUTF8String:maxlimit];
                tokenCacheVO.isvalid = [[NSString alloc] initWithUTF8String:isvalid];
                tokenCacheVO.createddate = [[NSString alloc] initWithUTF8String:createddate];
                tokenCacheVO.updatedate = [[NSString alloc] initWithUTF8String:updatedate];
                
                [array addObject:tokenCacheVO];
               
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
        }
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"token cache details query fail '%s'", sqlite3_errmsg(database));
    }
    
    return array;
    
}

//CREATE TABLE IF NOT EXISTS CHECKIN_CHECKOUT_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, AT VARCHAR, ON_DATE VARCHAR, FROM_TIME VARCHAR, UNTIL_TIME VARCHAR,SUGG_FROM VARCHAR, SUGG_UNTIL VARCHAR, CHECK_IN VARCHAR, CREATE_DATE VARCHAR, UPDATED_DATE VARCHAR)


+ (CheckinoutVO*) getCheckOutDetails{
    CheckinoutVO *checkinDetailsVO = nil;
    sqlite3_stmt *statement;
    
    NSMutableArray *listCheckins = [[NSMutableArray alloc] init];
    NSMutableArray *listDeleteCheckins = [[NSMutableArray alloc] init];
    
    NSString *strQry =  [NSString stringWithFormat:@"select ID , AT, ON_DATE, FROM_TIME, UNTIL_TIME,SUGG_FROM, SUGG_UNTIL, CHECK_IN, CREATE_DATE, UPDATED_DATE,LOCATION_ID  from CHECKIN_CHECKOUT_TABLE"];
    
    
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if(sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int cid                 = sqlite3_column_int(statement, 0);
                char *at                = (char *)sqlite3_column_text(statement, 1);
                char *ondate            = (char *)sqlite3_column_text(statement, 2);
                char *fromtime          = (char *)sqlite3_column_text(statement, 3);
                char *untiltime         = (char *)sqlite3_column_text(statement, 4);
                char *suggfrom          = (char *)sqlite3_column_text(statement, 5);
                char *sugguntil         = (char *)sqlite3_column_text(statement, 6);
                char *checkin           = (char *)sqlite3_column_text(statement, 7);
                char *createddate       = (char *)sqlite3_column_text(statement, 8);
                char *updatedate        = (char *)sqlite3_column_text(statement, 9);
                char *locationid        = (char *)sqlite3_column_text(statement, 10);
                
                CheckinoutVO *checkinVO = [[CheckinoutVO alloc] init];
                
                checkinVO.checkid =[[NSString alloc] initWithFormat:@"%d",cid];
                checkinVO.checkin =[[NSString alloc] initWithUTF8String:checkin];
                checkinVO.at =[[NSString alloc] initWithUTF8String:at];
                checkinVO.on =[[NSString alloc] initWithUTF8String:ondate];
                checkinVO.from =[[NSString alloc] initWithUTF8String:fromtime];
                checkinVO.until =[[NSString alloc] initWithUTF8String:untiltime];
                checkinVO.suggfrom =[[NSString alloc] initWithUTF8String:suggfrom];
                checkinVO.sugguntil =[[NSString alloc] initWithUTF8String:sugguntil];
                checkinVO.createddate =[[NSString alloc] initWithUTF8String:createddate];
                checkinVO.updatedate =[[NSString alloc] initWithUTF8String:updatedate];
                checkinVO.locationid = [[NSString alloc] initWithUTF8String:((locationid==NULL)?[@"" UTF8String]:locationid)];
                
                [listCheckins  addObject:checkinVO];
                
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
        }
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"Checkin details query fail '%s'", sqlite3_errmsg(database));
    }
    
    
    
    if ([listCheckins count]>0) {
        
        if ([listCheckins count]>1) {
            
            NSMutableArray *arrTempChekins = [[NSMutableArray alloc] init];
            
            for (int i=0; i< listCheckins.count; i++) {
                CheckinoutVO *checkVO = [listCheckins objectAtIndex:i];
                
                if ([[[APP_YES stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString]
                     isEqualToString:
                     [[checkVO.checkin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString]
                     ]) {
                    
                }else{
                    [arrTempChekins addObject:checkVO];
                }
                
            }
            
            NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
            [dateformate setDateFormat:[NSString stringWithFormat:@"%@%@",CHECK_IN_DATE_FORMATE,CHECK_IN_TIME_FORMATE]];
            
            NSArray *sortarray = [arrTempChekins sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                
                CheckinoutVO *checkinoutVO1 = (CheckinoutVO *)a;
                CheckinoutVO *checkinoutVO2 = (CheckinoutVO *)b;
                
                 NSDate *openDate1    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@", checkinoutVO1.on,checkinoutVO1.from]];
                
                NSDate *openDate2    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@", checkinoutVO2.on,checkinoutVO2.from]];
                
                return [openDate1 compare:openDate2];
            }];
            
            NSDate *now = [NSDate date];
            
            for (int i=0; i<[sortarray count] ; i++) {
                CheckinoutVO *checkinoutVO = [sortarray objectAtIndex:i];
                NSDate *openDate    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@", checkinoutVO.on,checkinoutVO.from]];
                NSDate *closeDate    = [dateformate dateFromString:[NSString stringWithFormat:@"%@%@",checkinoutVO.on,checkinoutVO.until]];
                
                if([AppUtil isDate:now inRangeFirstDate:openDate lastDate:closeDate]){
                    if (checkinDetailsVO == nil) {
                        checkinDetailsVO = checkinoutVO;
                    }
                }else{
                    NSDateFormatter *onDateformate = [[NSDateFormatter alloc] init];
                    [onDateformate setDateFormat:[NSString stringWithFormat:@"%@",CHECK_IN_DATE_FORMATE]];
                    
                    NSDate *today = [onDateformate dateFromString:[onDateformate stringFromDate:[NSDate date]]];
                    NSDate *onDate= [onDateformate dateFromString:checkinoutVO.on];
                    
                    if ([today compare:onDate]== NSOrderedDescending) {
                        [listDeleteCheckins addObject:checkinoutVO];
                    }
                    
                }
            }
            
            for (int i=0; i<[listDeleteCheckins count]; i++) {
                CheckinoutVO *deleteCheckinVO = [listDeleteCheckins objectAtIndex:i];
                [self deleteCheckinDetails:deleteCheckinVO.checkid];
            }
            
            
        }else{
            NSUInteger index = [listCheckins count]-1;
            checkinDetailsVO = [listCheckins objectAtIndex:index];
        }
    }
    
    
    return checkinDetailsVO;
}


+(void) deleteCheckinDetails:(NSString *)strID{
    
    if (strID != nil && [[strID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        if (sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            NSString *strDeleteQry = [NSString stringWithFormat:@"delete from CHECKIN_CHECKOUT_TABLE where ID=%@",strID];
            char *err;
            sqlite3_exec(database, [strDeleteQry UTF8String], NULL, NULL, &err);
            if(err==NULL){
               NSLog(@"CHECKIN_CHECKOUT_TABLE details are delete successfully");
            }else{
                NSAssert1(0, @"CHECKIN_CHECKOUT_TABLE details delete query fail '%s'", sqlite3_errmsg(database));
            }
        }
    }else{
        NSLog(@"Id is empty value coming");
    }
}



+ (void)saveCheckinDetails:(CheckinoutVO *)checkVO{
    if (checkVO != nil) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:APP_DB_DATE_FORMATE];
        NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [df stringFromDate:now];
        
        sqlite3_stmt *statement;
        //NSString *strQry    = @"UPDATE CHECKIN_CHECKOUT_TABLE SET AT=?, ON_DATE=?, FROM_TIME=?, UNTIL_TIME=?,SUGG_FROM=?, SUGG_UNTIL=?, CHECK_IN=?,UPDATED_DATE=?  where ID =1";
        
        NSString *strQry    = @"INSERT INTO CHECKIN_CHECKOUT_TABLE(AT, ON_DATE, FROM_TIME, UNTIL_TIME,SUGG_FROM, SUGG_UNTIL, CHECK_IN, CREATE_DATE, UPDATED_DATE, LOCATION_ID) VALUES(?,?,?,?,?,?,?,?,?,?) ";
        
        if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [checkVO.at UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 2, [checkVO.on UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 3, [checkVO.from UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 4, [checkVO.until UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 5, [checkVO.suggfrom UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 6, [checkVO.sugguntil UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 7, [checkVO.checkin UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 8, [dateString UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 9, [dateString UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 10, [checkVO.locationid UTF8String ], -1, NULL);
                
            }
            
            if(sqlite3_step(statement) == SQLITE_DONE){
                //NSLog(@"CHECKIN_CHECKOUT_TABLE details are update successfully");
            }else{
                NSAssert1(0, @"CHECKIN_CHECKOUT_TABLE details update query fail '%s'", sqlite3_errmsg(database));
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
            
        }else{
            sqlite3_close(database);
            NSAssert1(0, @"CHECKIN_CHECKOUT_TABLE details update query fail '%s'", sqlite3_errmsg(database));
        }
        
       
    }
}


+ (BOOL) checkColumnExists:(NSString *)strColumname inTable:(NSString *)strTableName{
    NSString *desiredColumn = strColumname;
    
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@)",strTableName];
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK)
    {
        
        
        if (stmt != nil) {
            sqlite3_finalize(stmt);
        }
        
        sqlite3_close(database);
        
        return NO;
    }
    
    while(sqlite3_step(stmt) == SQLITE_ROW)
    {
        
        NSString *fieldName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
        if([desiredColumn isEqualToString:fieldName]){
            
            if (stmt != nil) {
                sqlite3_finalize(stmt);
            }
            
            sqlite3_close(database);
            
            return YES;
            
        }
        
    }
    
    if (stmt != nil) {
        sqlite3_finalize(stmt);
    }
    
    sqlite3_close(database);
    
    return NO;
}




+ (void)saveHasTagDetails:(HashTagVO *)hashTagVO{
    
    if (hashTagVO != nil) {
        sqlite3_stmt *statement;
        NSString *strQry = [NSString stringWithFormat:@"UPDATE HASH_TAG_TABLE SET LOGGED_USER_FACEBOOK = ? ,LOGGED_USER_TWITTER= ?,LOGGED_MAR_FACEBOOK=?, LOGGED_MAR_TWITTER=?  where ID = %@", hashTagVO.hasid];
        
        if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [hashTagVO.loggedFacebookUser UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 2, [hashTagVO.loggedTwitterUser UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 3, [hashTagVO.loggedFacebookMar UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 4, [hashTagVO.loggedTwitterMar UTF8String ], -1, NULL);
                
            }
            
            if(sqlite3_step(statement) == SQLITE_DONE){
               // NSLog(@"HASH_TAG_TABLE are updated successfully");
            }else{
                NSAssert1(0, @"HASH_TAG_TABLE updated query fail '%s'", sqlite3_errmsg(database));
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
            
        }else{
            sqlite3_close(database);
            NSAssert1(0, @"HASH_TAG_TABLE updated query fail '%s'", sqlite3_errmsg(database));
        }
    }
    
    
}


//CREATE TABLE IF NOT EXISTS HASH_TAG_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, LOGGED_USER_FACEBOOK VARCHAR, LOGGED_USER_TWITTER VARCHAR, LOGGED_MAR_FACEBOOK VARCHAR, LOGGED_MAR_TWITTER VARCHAR)


+ (HashTagVO *)getHastagDetails{
    sqlite3_stmt *statement;
    HashTagVO *hashTagVO = [[HashTagVO alloc] init];
    NSString *strQry =  [NSString stringWithFormat:@"select ID, LOGGED_USER_FACEBOOK, LOGGED_USER_TWITTER, LOGGED_MAR_FACEBOOK, LOGGED_MAR_TWITTER  from HASH_TAG_TABLE where ID=1"];
    
    
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if(sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int hashid       = sqlite3_column_int(statement, 0);
                char *loggeduserfacebook    = (char *)sqlite3_column_text(statement, 1);
                char *loggedusertwitter     = (char *)sqlite3_column_text(statement, 2);
                char *loggedmarfacebook     = (char *)sqlite3_column_text(statement, 3);
                char *loggedmartwitter      = (char *)sqlite3_column_text(statement, 4);
               
                
                
                
                hashTagVO.hasid =[[NSString alloc] initWithFormat:@"%d",hashid];
                hashTagVO.loggedFacebookUser =[[NSString alloc] initWithUTF8String:loggeduserfacebook];
                hashTagVO.loggedFacebookMar =[[NSString alloc] initWithUTF8String:loggedmarfacebook];
                hashTagVO.loggedTwitterUser =[[NSString alloc] initWithUTF8String:loggedusertwitter];
                hashTagVO.loggedTwitterMar =[[NSString alloc] initWithUTF8String:loggedmartwitter];
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
        }
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"fd confirm details query fail '%s'", sqlite3_errmsg(database));
    }
    
    
    return hashTagVO;
}








+ (FoodTruckVO *)getMerchantFoodTruckVO{
    sqlite3_stmt *statement;
    FoodTruckVO *foodtruckVO = [[FoodTruckVO alloc] init];
    NSString *strQry =  [NSString stringWithFormat:@"select IS_MARCHANT ,FOOD_TRUCK_ID, FOODTRUCK_NAME, TWITTER_HANDLER, FACEBOOK_ADDRESS, LOCATION_ID, DESCRIPTION, EXTRA_DESCRIPTION, TWITTER_NAME, INSTAGRAMUSER, YELP_ADDRESS, COUSIN_TEXT VARCHAR, WEBSITE, EMAIL_ADDRESS , PHONE_NUM from MARCHANT where MAR_ID=1"];
    
    
    if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
        if(sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                char *ismerchant        = (char *)sqlite3_column_text(statement, 0);
                char *foodtruckid       = (char *)sqlite3_column_text(statement, 1);
                char *foodtruckname     = (char *)sqlite3_column_text(statement, 2);
                char *twitterhandle     = (char *)sqlite3_column_text(statement, 3);
                char *facebookaddress   = (char *)sqlite3_column_text(statement, 4);
                char *locationid        = (char *)sqlite3_column_text(statement, 5);
                char *description       = (char *)sqlite3_column_text(statement, 6);
                char *extra_description = (char *)sqlite3_column_text(statement, 7);
                char *twittername       = (char *)sqlite3_column_text(statement, 8);
                char *instagramuser     = (char *)sqlite3_column_text(statement, 9);
                char *yelpaddress       = (char *)sqlite3_column_text(statement, 10);
                char *cousintext        = (char *)sqlite3_column_text(statement, 11);
                char *website           = (char *)sqlite3_column_text(statement, 12);
                char *emailaddress      = (char *)sqlite3_column_text(statement, 13);
                char *phonenum          = (char *)sqlite3_column_text(statement, 14);
                
                
                foodtruckVO.isMerchant  =[[NSString alloc] initWithUTF8String:((ismerchant==NULL)?[@"" UTF8String]:ismerchant)];
                foodtruckVO.foodtruckid =[[NSString alloc] initWithUTF8String:((foodtruckid==NULL)?[@"" UTF8String]:foodtruckid)];
                foodtruckVO.name =[[NSString alloc] initWithUTF8String:((foodtruckname==NULL)?[@"" UTF8String]:foodtruckname)];
                foodtruckVO.twitterHandle =[[NSString alloc] initWithUTF8String:((twitterhandle==NULL)?[@"" UTF8String]:twitterhandle)];
                foodtruckVO.facebookAddress =[[NSString alloc] initWithUTF8String:((facebookaddress==NULL)?[@"" UTF8String]:facebookaddress)];
                foodtruckVO.locationid =[[NSString alloc] initWithUTF8String:((locationid==NULL)?[@"" UTF8String]:locationid)];
                foodtruckVO.description =[[NSString alloc] initWithUTF8String:((description==NULL)?[@"" UTF8String]:description)];
                foodtruckVO.extraDescription =[[NSString alloc] initWithUTF8String:((extra_description==NULL)?[@"" UTF8String]:extra_description)];
                foodtruckVO.twitterName =[[NSString alloc] initWithUTF8String:((twittername==NULL)?[@"" UTF8String]:twittername)];
                foodtruckVO.instagramUserName =[[NSString alloc] initWithUTF8String:((instagramuser==NULL)?[@"" UTF8String]:instagramuser)];
                foodtruckVO.yelpAddress =[[NSString alloc] initWithUTF8String:((yelpaddress==NULL)?[@"" UTF8String]:yelpaddress)];
                foodtruckVO.cousineText =[[NSString alloc] initWithUTF8String:((cousintext==NULL)?[@"" UTF8String]:cousintext)];
                foodtruckVO.website =[[NSString alloc] initWithUTF8String:((website==NULL)?[@"" UTF8String]:website)];
                foodtruckVO.emailAddress =[[NSString alloc] initWithUTF8String:((emailaddress==NULL)?[@"" UTF8String]:emailaddress)];
                foodtruckVO.phoneNum =[[NSString alloc] initWithUTF8String:((phonenum==NULL)?[@"" UTF8String]:phonenum)];
            }
            
            //NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
        }
    }else{
        sqlite3_close(database);
        NSAssert1(0, @"fd confirm details query fail '%s'", sqlite3_errmsg(database));
    }
    
    
    return foodtruckVO;
    
    
}


+ (void) deleteRecentFooTruckDetails:(NSString *)locationid withFoodTruckID:(NSString *)foodtruckid{
    if (locationid != nil && [[locationid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 && foodtruckid != nil && [[foodtruckid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        if (sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            NSString *strDeleteQry = [NSString stringWithFormat:@"delete from RECENT_FOOD_TRUCK_TABLE where FOODTRUCK_ID='%@' AND LOCATION_ID='%@'",foodtruckid, locationid];
            char *err;
            sqlite3_exec(database, [strDeleteQry UTF8String], NULL, NULL, &err);
            if(err==NULL){
                NSLog(@"RECENT_FOOD_TRUCK_TABLE details are delete successfully");
            }else{
                NSAssert1(0, @"RECENT_FOOD_TRUCK_TABLE details delete query fail '%s'", sqlite3_errmsg(database));
            }
        }
    }else{
        NSLog(@"location id or food truck id is empty value coming");
    }
}


+(void) insertRecentFoodTruckDetails:(FoodTruckVO *)foodtruckVO{
//    sqlite3_exec(database, [@"CREATE TABLE IF NOT EXISTS RECENT_FOOD_TRUCK_TABLE(ID INTEGER PRIMARY KEY AUTOINCREMENT, LOCATION_ID VARCHAR,FOODTRUCK_ID VARCHAR, NAME VARCHAR,DESCRIPTION VARCHAR,EXTRA_DESCRIPTION VARCHAR,TWITTER_HANDLE VARCHAR,TWITTER_NAME VARCHAR,FACEBOOK_ADDRESS VARCHAR,INSTAGRAM_USERNAME VARCHAR,YELP_ADDRESS VARCHAR,COUSIN_TEXT VARCHAR,LATITUDE VARCHAR,LONGITUDE VARCHAR,WEBSITE VARCHAR,DISTANCE  VARCHAR,STATUS  VARCHAR,EMAIL_ADDRESS VARCHAR,PHONE_NUM VARCHAR,OPEN_DATE VARCHAR,CLOSE_DATE VARCHAR,ICON VARCHAR,MERCHANT VARCHAR)" UTF8String], NULL, NULL, &err);
    
    
    if (foodtruckVO != nil) {
        sqlite3_stmt *statement;
        NSString *strQry = [NSString stringWithFormat:@"INSERT INTO RECENT_FOOD_TRUCK_TABLE(LOCATION_ID,FOODTRUCK_ID, NAME,DESCRIPTION ,EXTRA_DESCRIPTION ,TWITTER_HANDLE,TWITTER_NAME,FACEBOOK_ADDRESS,INSTAGRAM_USERNAME,YELP_ADDRESS,COUSIN_TEXT,LATITUDE,LONGITUDE,WEBSITE,DISTANCE,STATUS,EMAIL_ADDRESS,PHONE_NUM,OPEN_DATE,CLOSE_DATE,ICON,MERCHANT) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];

        
        if(sqlite3_open([[self getDbPath] UTF8String], &database) == SQLITE_OK){
            if (sqlite3_prepare_v2(database, [strQry UTF8String], -1, &statement, nil) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [foodtruckVO.locationid UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 2, [foodtruckVO.foodtruckid UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 3, [foodtruckVO.name UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 4, [foodtruckVO.description UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 5, [foodtruckVO.extraDescription UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 6, [foodtruckVO.twitterHandle UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 7, [foodtruckVO.twitterName UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 8, [foodtruckVO.facebookAddress UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 9, [foodtruckVO.instagramUserName UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 10, [foodtruckVO.yelpAddress UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 11, [foodtruckVO.cousineText UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 12, [[foodtruckVO.lat stringValue] UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 13, [[foodtruckVO.lng stringValue] UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 14, [foodtruckVO.website UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 15, [[foodtruckVO.distance stringValue] UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 16, [foodtruckVO.status UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 17, [foodtruckVO.emailAddress UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 18, [foodtruckVO.phoneNum UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 19, [[NSString stringWithFormat:@"%@",foodtruckVO.openDate] UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 20, [[NSString stringWithFormat:@"%@",foodtruckVO.closeDate] UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 21, [foodtruckVO.icon UTF8String ], -1, NULL);
                sqlite3_bind_text(statement, 22, [foodtruckVO.isMerchant UTF8String ], -1, NULL);
                
                
            }
            
            if(sqlite3_step(statement) == SQLITE_DONE){
                NSLog(@"RECENT_FOOD_TRUCK_TABLE are updated successfully");
            }else{
                NSAssert1(0, @"RECENT_FOOD_TRUCK_TABLE insert query fail '%s'", sqlite3_errmsg(database));
            }
            
            NSLog(@"Finalize statement");
            sqlite3_finalize(statement);
            
        }else{
            sqlite3_close(database);
            NSAssert1(0, @"RECENT_FOOD_TRUCK_TABLE insert query fail '%s'", sqlite3_errmsg(database));
        }
    }
    
    
}




@end
