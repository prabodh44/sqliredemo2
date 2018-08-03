#import "SqliteHelper.h"
@implementation SqliteHelper
-(int)initialize{
    @try {
        _databaseName = @"student.db";
        _folder = @"sqlitedemo";
        // overwrite = [jsonParam objectForKey:@"overwrite"];
        NSString *docsDir;
        NSArray *dirPaths;
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        NSString *dbFullPathFolder = [[NSString alloc] initWithFormat:@"%@/%@",docsDir,_folder];
        dbFullPath = [[NSString alloc] initWithFormat:@"%@/%@/%@",docsDir,_folder,_databaseName];
        dbpath = [dbFullPath UTF8String];
        
        [self createFileLocation:dbFullPathFolder];
        
        
        if(!novagoDb){
            if (sqlite3_open_v2(dbpath, &novagoDb, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL) == SQLITE_OK) {
                //sqlite3_key(novagoDb, [encryptionKey UTF8String], (int)strlen([encryptionKey UTF8String]));
                [self createTable];
                return 0;
            }
        }else if(![[NSFileManager defaultManager] fileExistsAtPath:dbFullPath]){
            if (sqlite3_open_v2(dbpath, &novagoDb, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL) == SQLITE_OK) {
                //sqlite3_key(novagoDb, [encryptionKey UTF8String], (int)strlen([encryptionKey UTF8String]));
                [self createTable];
                return 0;
            }
        }
        return 0;
    }
    @catch (NSException *exception) {
        return  -1;
    }
    return -1;
}

- (NSString *) createFileLocation: (NSString *) location{
    @try {
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:location])    //Does directory already exist?
        {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:location
                                           withIntermediateDirectories:YES
                                                            attributes:nil
                                                                 error:&error])
            {
                NSLog(@"Create directory error: %@", error);
                return NULL;
            }
        }
        return location;
    }
    @catch (NSException *exception) {
    }
}

-(int)createTable{
    //const char *dbpath = [dbFullPath UTF8String];
    if (sqlite3_open(dbpath, &novagoDb) == SQLITE_OK){
        char *err;
        sqlite3_exec(novagoDb,"CREATE TABLE IF NOT EXISTS [Messages] ([MessageId] TEXT PRIMARY KEY NOT NULL, [UserIdFrom] TEXT, [UserIdTo] TEXT,[MessageContent] TEXT, [MessageTitle] TEXT, [UserNameFrom] TEXT, [UserNameTo] TEXT,[MessageStartDate] DATE, [ReadByUser] INTEGER,[DateCreated] TIMESTAMP, [DateModified] TIMESTAMP, [DateDeleted] TIMESTAMP);", NULL, NULL, &err);
        
        sqlite3_exec(novagoDb,"CREATE TABLE IF NOT EXISTS [studentsDetail] ([Regno] INTEGER PRIMARY KEY NOT NULL, [Name] TEXT, [Department] TEXT,[Year] TEXT);", NULL, NULL, &err);
        
        
        if(err){
            NSLog(@"%s", err);
            NSString *errorMessage = [NSString stringWithFormat:@"Exception:%s", err];
        }
        
        
    }
    
    return 0;
}

-(int) insert: (NSString *) insertQuery{
    dbpath = [dbFullPath UTF8String];
    // if (sqlite3_open(dbpath, &novagoDb) == SQLITE_OK){
    sqlite3_stmt *statement;
    const char *insert_stmt = [insertQuery UTF8String];
    sqlite3_prepare_v2(novagoDb, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE) {
        //NSLog(@"Data inserted");
        NSLog(@"%lld",sqlite3_last_insert_rowid(novagoDb));
        
        sqlite3_finalize(statement);
        return 0;
    }else{
        NSLog(@"Data not inserted!: %s", sqlite3_errmsg(novagoDb));
        NSString *errorMessage = [NSString stringWithFormat:@"%s", sqlite3_errmsg(novagoDb)];
        return -1;
    }
    
    return -1;
}

-(NSArray *) select: (NSString *) selectQuery{
    dbpath = [dbFullPath UTF8String];
    // if (sqlite3_open(dbpath, &novagoDb) == SQLITE_OK){
    sqlite3_stmt *statement;
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    const char *select_stmt = [selectQuery UTF8String];
    if (sqlite3_prepare_v2(novagoDb, select_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)// sqlite3_step() has another row ready
        {
            NSString *name = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 0)];
            [resultArray addObject:name];
            NSString *department = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
            [resultArray addObject:department];
            NSString *year = [[NSString alloc]initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 2)];
            [resultArray addObject:year];
            return resultArray;
        }
        else{
            NSLog(@"Not found");
            return nil;
        }
        //sqlite3_reset(statement);
    }
}

@end
