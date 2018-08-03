#import "SqliteConnect.h"


#import <Cordova/CDVAvailability.h>

@implementation SqliteConnect

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
- (void)ActionDatabaseInitialize:(CDVInvokedUrlCommand *)command{
    SqliteHelper *sqlitehelper = ((AppDelegate *)[[UIApplication sharedApplication]delegate]).sqliteHelper;
    CDVPluginResult *pluginResult = nil;
    int result = [sqlitehelper initialize];
    if (result == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];// success callback
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]; // error callback
    }
    //[pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

- (void) ActionInsertIntoTable:(CDVInvokedUrlCommand *)command{
     SqliteHelper *sqlitehelper = ((AppDelegate *)[[UIApplication sharedApplication]delegate]).sqliteHelper;
    CDVPluginResult *pluginResult = nil;
    NSLog(@"Hello");
    NSString *message = [command.arguments objectAtIndex:0];
    int result = [sqlitehelper insert:message];
    if (result == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];// success callback
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"fail"]; // error callback
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)ActionReadFromTable:(CDVInvokedUrlCommand *)command{
    SqliteHelper *sqlitehelper = ((AppDelegate *)[[UIApplication sharedApplication]delegate]).sqliteHelper;
    CDVPluginResult *pluginResult = nil;
    NSLog(@"Hello");
    NSString *message = [command.arguments objectAtIndex:0];
    NSArray *result = [sqlitehelper select:message];
    if(result != nil){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"fail"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
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
