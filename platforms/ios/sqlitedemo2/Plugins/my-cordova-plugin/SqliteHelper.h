#import <Foundation/Foundation.h>
#import <sqlite3.h>

static sqlite3 *novagoDb = nil;
static  NSString *dbFullPath = nil;
static const char *dbpath;
@interface SqliteHelper : NSObject
@property (atomic, retain) NSString *databaseName;
@property (atomic, retain) NSString *folder;
@property (atomic, retain) NSString *password;

-(int)initialize;
-(int)createTable;
-(int) insert: (NSString *) insertQuery;
-(NSArray *) select: (NSString *) selectQuery;


@end
