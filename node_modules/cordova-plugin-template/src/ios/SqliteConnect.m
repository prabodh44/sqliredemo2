#import "MyCordovaPlugin.h"

#import <Cordova/CDVAvailability.h>

@implementation MyCordovaPlugin

- (void)pluginInitialize {
}

- (void)echo:(CDVInvokedUrlCommand *)command {
    NSString* phrase = [command.arguments objectAtIndex:0];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:phrase delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    NSLog(@"%@", phrase);
}

- (void)getDate:(CDVInvokedUrlCommand *)command {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
  [dateFormatter setLocale:enUSPOSIXLocale];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];

  NSDate *now = [NSDate date];
  NSString *iso8601String = [dateFormatter stringFromDate:now];

  CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:iso8601String];
  [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) ActionCreateTable:(CDVInvokedUrlCommand *)command{
    NSLog(@"Command Object: %@", command);
    //implementation of the create tables function
    @try{
        //NSLog(@"app dir: %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
        
        
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = dirPaths[0];
        NSError *folderError;
        NSString *dbDirectory = [NSString stringWithFormat:@"%@/%@",docsDir,@"prabodh"];
        NSString *dbFullPath = [NSString stringWithFormat:@"%@/%@/%@",docsDir,@"prabodh",@"tryDb.sqlite"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dbDirectory]){
            [[NSFileManager defaultManager] createDirectoryAtPath:dbDirectory withIntermediateDirectories:NO attributes:nil error:&folderError];
        }
        dbPath = [dbFullPath UTF8String];
        
        BOOL status = [[NSFileManager defaultManager] fileExistsAtPath:dbFullPath];
        if (tryDb == nil) {
            int code1 = sqlite3_open_v2(dbPath, &tryDb, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
            NSLog(@"code %d", code1);
            if (sqlite3_open_v2(dbPath, &tryDb, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL) == SQLITE_OK) {
                NSLog(@"data base created");
            }
        }
        
        NSString *createTableQuery = @"CREATE TABLE IF NOT EXISTS Users (UserId INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Password TEXT);";
       char *createError;
       int createStatus = sqlite3_exec(tryDb, [createTableQuery UTF8String], NULL, NULL, nil);
        NSLog(@"CreateStatus: %d", createStatus);
        
//        insert query
//        NSString *insertQuery = @"INSERT INTO Users VALUES(2,'Ravi', '4558');";
//        char *insertError;
//        int code = sqlite3_exec(tryDb, [insertQuery UTF8String], NULL, NULL, nil);
//        NSLog(@"code %d", code);
       
//
//      reading data
        NSString *selectQuery = @"SELECT * FROM Users";
        sqlite3_stmt *preparedStmt;
        int selectCode = sqlite3_prepare(tryDb, [selectQuery UTF8String], -1, &preparedStmt, NULL);
        NSLog(@"Select Code: %d", selectCode);
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        while (sqlite3_step(preparedStmt) == SQLITE_ROW) {
            NSMutableDictionary *tableRows = [[NSMutableDictionary alloc] init];
            NSInteger colCount = sqlite3_data_count(preparedStmt);
            for(int i = 0; i < colCount; i++){
                char *value = "";
                char *key = "";
                key = (char *)sqlite3_column_name(preparedStmt, i+1);
                value = (char *)sqlite3_column_text(preparedStmt, i+1);
                //NSLog(@"Column name: %c, Values: %c", key, value);
                [tableRows setObject:[NSString stringWithFormat:@"%s", value] forKey:[NSString stringWithFormat:@"%s", key]];

            }
            [dataArray addObject:tableRows];
            NSLog(@"Data Array: %@", dataArray);
        }
        
//        //updating data
//        NSString *updateQuery = @"UPDATE Users SET Name = 'NewName' WHERE UserId = 1";
//        //executing query
//        char *updatError;
//        int updateCode = sqlite3_exec(tryDb, [updateQuery UTF8String], NULL, NULL, &updatError);
//        NSLog(@"Update code: %d", updateCode);
//
//        //showing updated data
//        sqlite3_stmt *newUpdateStatement;
//        int updatedSelectCode = sqlite3_prepare(tryDb, [selectQuery UTF8String], -1, &newUpdateStatement, NULL);
//        NSLog(@"update code: %d", updatedSelectCode);
//        NSMutableArray *updatedArray = [[NSMutableArray alloc] init];
//        while(sqlite3_step(newUpdateStatement) == SQLITE_ROW){
//            NSMutableDictionary *updatedData = [[NSMutableDictionary alloc] init];
//            NSInteger colCount = sqlite3_data_count(newUpdateStatement);
//            for(int i = 0; i < colCount; i++){
//                char *value = "";
//                char *key = "";
//
//                value = (char *) sqlite3_column_name(newUpdateStatement, i + 1);
//                key = (char *) sqlite3_column_text(newUpdateStatement, i + 1);
//
//                [updatedData setObject:[NSString stringWithFormat:@"%s", value] forKey:[NSString stringWithFormat:@"%s", key]];
//            }
//            [updatedArray addObject:updatedData];
//            [updatedArray description];
//            NSLog(@"Updated data: %@", updatedArray);
//
//        }
        
        
    }
    @catch(NSException *exception){
        NSString *excDesc = [NSString stringWithFormat:@"Exception:%@", [exception reason]];
    }
}

- (void) ActionInsertIntoTable:(CDVInvokedUrlCommand *)command{
    NSLog(@"Hello");
    NSDictionary *params = [command.arguments objectAtIndex:0];
    NSDictionary *message = [params objectForKey:@"message"];
    NSString *username = [message objectForKey:@"username"];
    NSString *password = [message objectForKey:@"password"];
    
    sqlite3_stmt *checkStatement;
    NSString *checkQuery = [NSString stringWithFormat:@"SELECT * FROM Users WHERE Name = '%@'", username];
    sqlite3_prepare(tryDb, [checkQuery UTF8String], -1, &checkStatement, NULL);
    
    NSString *status = @"";
    if(sqlite3_step(checkStatement) == SQLITE_ROW){
        status = @"PRESENT";
        NSLog(@"user alreay exists");
    }else{
        NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO Users ('Name', 'Password') VALUES('%@', '%@');", username, password ];
        char *insertError;
        int code = sqlite3_exec(tryDb, [insertQuery UTF8String], NULL, NULL, &insertError);
        NSLog(@"code %d", code);
    }
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:status];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) ActionIsLoginDataPresent:(CDVInvokedUrlCommand *)command{
//    NSDictionary *params = [command.arguments objectAtIndex:0];
//    NSDictionary *message = [params objectForKey:@"message"];
//    NSString *username = [message objectForKey:@"username"];
//    NSString *password = [message objectForKey:@"password"];
//    sqlite3_stmt *loginStatement;
//    NSString *loginQuery = [NSString stringWithFormat:@"SELECT * FROM Users WHERE Name = '%@' AND Password = '%@'", username, password];
//    sqlite3_prepare(tryDb, [loginQuery UTF8String], -1, &loginStatement, NULL);
//    NSString *status = @"";
//    if(sqlite3_step(loginStatement) == SQLITE_ROW){
//        status = @"OK";
//        NSLog(@"you can log in");
//    }else{
//        status = @"NOK";
//        NSLog(@"you can not log in");
//    }
//
//    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:status];
//    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    
    
    //////////////////////////////////////////////////////////
    NSDictionary *params = [command.arguments objectAtIndex:0];
    NSDictionary *message = [params objectForKey:@"message"];
    NSString *username = [message objectForKey:@"userName"];
    NSString *password = [message objectForKey:@"password"];
    NSString *domain = [message objectForKey:@"domain"];
    
    //create the post body
    //NSString *postBody = [NSString stringWithFormat:@"userName:'%@'&password='%@'&domain:'%@'", username, password, domain];
    NSString *postBody = [NSString stringWithFormat:@"{\"userName\":\"%@\",\"password\":\"%@\",\"domain\":\"%@\"}",username, password, domain];
    NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    
    //create the URL with headers
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://novago-dev.procit.com/NovaGoService/NovaGoService.svc/Login"];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"mobile" forHTTPHeaderField:@"X-LoginSource"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];

    //send request using NSURLSession
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        @try{
            NSError* error;
            NSDictionary *loginData = [NSJSONSerialization JSONObjectWithData:data                                                                 options:kNilOptions error:&error];
            NSDictionary *loginResult = [loginData valueForKey:@"LoginResult"];
            
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:loginResult];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            
            NSLog(@"loginResult: %@", loginResult);
            NSLog(@"loginData: %@", loginData);
        }@catch(NSException *e){
            NSLog(@"Error");
        }
    }] resume];
}


- (void) ActionUpdateUserData:(CDVInvokedUrlCommand *)command{
    NSDictionary *params = [command.arguments objectAtIndex:0];
    NSDictionary *message = [params objectForKey:@"message"];
    NSString *username = [message objectForKey:@"username"];
    NSString *password = [message objectForKey:@"password"];
    
    
    //updating data
    //UPDATE Users SET Name = 'NewName' WHERE UserId = 1
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE Users Set Password = '%@' WHERE Name = '%@'", password, username];
    //executing query
    char *updateError;
    int updateCode = sqlite3_exec(tryDb, [updateQuery UTF8String], NULL, NULL, &updateError);
    NSLog(@"Update code: %d", updateCode);
    
    //reading updated data
    sqlite3_stmt *newUpdateStatement;
    NSString *updatedSelectQuery = [NSString stringWithFormat:@"SELECT Password FROM Users WHERE Name = '%@'", username];
    int updatedSelectCode = sqlite3_prepare(tryDb, [updatedSelectQuery UTF8String], -1, &newUpdateStatement, NULL);
    NSLog(@"update code: %d", updatedSelectCode);
    NSMutableArray *updatedArray = [[NSMutableArray alloc] init];
    while(sqlite3_step(newUpdateStatement) == SQLITE_ROW){
        NSMutableDictionary *updatedData = [[NSMutableDictionary alloc] init];
        NSInteger colCount = sqlite3_data_count(newUpdateStatement);
        for(int i = 0; i < colCount; i++){
            char *value = "";
            char *key = "";
            
            value = (char *) sqlite3_column_name(newUpdateStatement, i);
            key = (char *) sqlite3_column_text(newUpdateStatement, i);
            
            [updatedData setObject:[NSString stringWithFormat:@"%s", value] forKey:[NSString stringWithFormat:@"%s", key]];
        }
        
        
    }
    
}
@end
