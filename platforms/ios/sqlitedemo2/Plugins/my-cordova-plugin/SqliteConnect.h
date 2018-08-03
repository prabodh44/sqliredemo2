#import <Cordova/CDVPlugin.h>
#import <sqlite3.h>
#import "SqliteHelper.h"
#import "AppDelegate.h"

@interface SqliteConnect : CDVPlugin {
    sqlite3 *tryDb;
    const char *dbPath;
}


// The hooks for our plugin commands
- (void)echo:(CDVInvokedUrlCommand *)command;
- (void)getDate:(CDVInvokedUrlCommand *)command;
- (void)ActionCreateTable:(CDVInvokedUrlCommand *)command;
- (void)ActionInsertIntoTable:(CDVInvokedUrlCommand *)command;
- (void)ActionIsLoginDataPresent:(CDVInvokedUrlCommand *)command;
- (void)ActionUpdateUserData:(CDVInvokedUrlCommand *)command;
- (void)ActionDatabaseInitialize:(CDVInvokedUrlCommand *)command;
- (void)ActionReadFromTable:(CDVInvokedUrlCommand *)command;


@end
