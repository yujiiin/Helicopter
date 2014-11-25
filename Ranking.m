//
//  Ranking.m
//  Hilicopter
//
//  Created by Yuji Shimizu on 1/12/14.
//  Copyright (c) 2014 Yuji Shimizu. All rights reserved.
//

#import "Ranking.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"

#define DB_FILE_NAME @"Helitest2.db"

#define SQL_CREATE @"CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, score INTEGER);"
#define SQL_INSERT @"INSERT INTO test (name,score) VALUES (?,?);"
#define SQL_UPDATE @"UPDATE test SET score = ?, WHERE id = ?;"
#define SQL_SELECTRANKING @"SELECT name, score FROM test ORDER BY score DESC LIMIT 1 OFFSET ?;"
#define SQL_DELETE @"DELETE FROM test WHERE id = ?;"


@interface Ranking ()
@property (nonatomic, copy) NSString* dbPath; //! データベース　ファイルへのパス
- (FMDatabase*)getConnection;
+ (NSString*)getDbFilePath;
@end

@implementation Ranking
@synthesize dbPath;


/**
 * データベースを取得します。
 */
- (FMDatabase *)getConnection
{
	if( self.dbPath == nil )
	{
		self.dbPath =  [Ranking getDbFilePath];
	}
	
	return [FMDatabase databaseWithPath:self.dbPath];
}

/**
 * データベース ファイルのパスを取得します。
 */
+ (NSString*)getDbFilePath
{
	NSArray*  paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* dir   = [paths objectAtIndex:0];
	
	return [dir stringByAppendingPathComponent:DB_FILE_NAME];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    int RankNumber = 0;
    NSNumber *number = [[NSNumber alloc] initWithInt:RankNumber];
    FMDatabase *db= [self getConnection];
    [db open];
    FMResultSet *result = [db executeQuery:SQL_SELECTRANKING,number]; //get top5
    while([result next]){
        //int result_id = [result intForColumn:@"id"];
        NSString *result_name = [result stringForColumn:@"name"];
        int result_score = [result intForColumn:@"score"];
        Rank1.text = [NSString stringWithFormat:@"Rank1 : %@, score: %d",result_name,result_score];
    }
    RankNumber++;
    number = [[NSNumber alloc] initWithInt:RankNumber];
    FMResultSet *result2 = [db executeQuery:SQL_SELECTRANKING,number]; //get top5
    while([result2 next]){
        //int result_id = [result intForColumn:@"id"];
        NSString *result2_name = [result2 stringForColumn:@"name"];
        int result2_score = [result2 intForColumn:@"score"];
        Rank2.text = [NSString stringWithFormat:@"Rank2 : %@, score: %d",result2_name,result2_score];
    }
    RankNumber++;
    number = [[NSNumber alloc] initWithInt:RankNumber];
    FMResultSet *result3 = [db executeQuery:SQL_SELECTRANKING,number]; //get top5
    while([result3 next]){
        //int result_id = [result intForColumn:@"id"];
        NSString *result3_name = [result3 stringForColumn:@"name"];
        int result3_score = [result3 intForColumn:@"score"];
        Rank3.text = [NSString stringWithFormat:@"Rank3 : %@, score: %d",result3_name,result3_score];
    }
    RankNumber++;
    number = [[NSNumber alloc] initWithInt:RankNumber];
    FMResultSet *result4 = [db executeQuery:SQL_SELECTRANKING,number]; //get top5
    while([result4 next]){
        //int result_id = [result intForColumn:@"id"];
        NSString *result4_name = [result4 stringForColumn:@"name"];
        int result4_score = [result4 intForColumn:@"score"];
        Rank4.text = [NSString stringWithFormat:@"Rank4 : %@, score: %d",result4_name,result4_score];
    }
    RankNumber++;
    number = [[NSNumber alloc] initWithInt:RankNumber];
    FMResultSet *result5 = [db executeQuery:SQL_SELECTRANKING,number]; //get top5
    while([result5 next]){
        //int result_id = [result intForColumn:@"id"];
        NSString *result5_name = [result5 stringForColumn:@"name"];
        int result5_score = [result5 intForColumn:@"score"];
        Rank5.text = [NSString stringWithFormat:@"Rank5 : %@, score: %d",result5_name,result5_score];
    }

  
    
    
    
    [db close];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
