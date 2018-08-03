#import <Cordova/CDVPlugin.h>
#import <sqlite3.h>

@interface MyCordovaPlugin : CDVPlugin {
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

@end
