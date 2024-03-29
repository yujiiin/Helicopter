//
//  ViewController.m
//  Hilicopter
//
//  Created by Yuji Shimizu on 1/12/14.
//  Copyright (c) 2014 Yuji Shimizu. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"

#define DB_FILE_NAME @"Helitest2.db"

#define SQL_CREATE @"CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, score INTEGER);"
#define SQL_INSERT @"INSERT INTO test (name,score) VALUES (?,?);"
#define SQL_UPDATE @"UPDATE test SET score = ?, WHERE id = ?;"
#define SQL_SELECTHIGHSCORE @"SELECT name, score FROM test WHERE score = (SELECT max(score) FROM test);"
#define SQL_DELETE @"DELETE FROM test WHERE id = ?;"


@interface ViewController ()
@property (nonatomic, copy) NSString* dbPath; //! データベース　ファイルへのパス
- (FMDatabase*)getConnection;
+ (NSString*)getDbFilePath;
@end

@implementation ViewController
@synthesize dbPath;


/**
 * データベースを取得します。
 */
- (FMDatabase *)getConnection
{
	if( self.dbPath == nil )
	{
		self.dbPath =  [ViewController getDbFilePath];
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



-(void)Collision{
    if(CGRectIntersectsRect(Heli.frame, Obstacle.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Obstacle2.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Bottom1.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Bottom2.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Bottom3.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Bottom4.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Bottom5.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Bottom6.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Bottom7.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Top1.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Top2.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Top3.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Top4.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Top5.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Top6.frame)){
        [self EndGame];
    }
    if(CGRectIntersectsRect(Heli.frame, Top7.frame)){
        [self EndGame];
    }
    if(Heli.center.y > 274 || Heli.center.y < 48){
        [self EndGame];
    }
}

-(void)EndGame{
    BackButton.hidden = NO;
    NameField.hidden = NO;
    if(ScoreNumber > HighScore){
        HighScore = ScoreNumber;
        [[NSUserDefaults standardUserDefaults] setInteger:HighScore forKey:@"HighScoreSaved"];
    
    }
    Heli.hidden = YES;
    [timer invalidate];
    [Scorer invalidate];
    
   // [self performSelector:@selector(NewGame) withObject:nil afterDelay:3];
}

-(IBAction)BackButton:(id)sender{
    NSString *name = NameField.text;
    if([name length] == 0){
        name = @"unknown";
    }
    //INT型はSQL代入前に型変換！！
    NSNumber *number = [[NSNumber alloc] initWithInt:ScoreNumber];
    FMDatabase* db = [self getConnection];
    [db open];
    [db setShouldCacheStatements:YES];
    [db executeUpdate:SQL_INSERT,name,number];
    [db close];
    [self NewGame];
    BackButton.hidden = YES;
    NameField.hidden = YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)theTextField{
    if(theTextField == NameField){
        [theTextField resignFirstResponder];
    }
    return YES;
}

-(void)NewGame{
    Bottom1.hidden = YES;
    Bottom2.hidden = YES;
    Bottom3.hidden = YES;
    Bottom4.hidden = YES;
    Bottom5.hidden = YES;
    Bottom6.hidden = YES;
    Bottom7.hidden = YES;
    Top1.hidden = YES;
    Top2.hidden = YES;
    Top3.hidden = YES;
    Top4.hidden = YES;
    Top5.hidden = YES;
    Top6.hidden = YES;
    Top7.hidden = YES;
    Obstacle.hidden = YES;
    Obstacle2.hidden = YES;
    BackButton.hidden = YES;
    NameField.hidden = YES;

    
    Intro1.hidden = NO;
    Intro2.hidden = NO;
    Intro3.hidden = NO;
    Ranking.hidden =NO;
    Heli.hidden = NO;
    Heli.center = CGPointMake(67, 114);
    Heli.image = [UIImage imageNamed:@"HeliUp.png"];
    Start = YES;
    
    ScoreNumber = 0;
    Score.text = [NSString stringWithFormat:@"Score: 0"];
//    Intro3.text = [NSString stringWithFormat:@"High Score: %i",HighScore];
    
    FMDatabase *db= [self getConnection];
    [db open];
    FMResultSet *result = [db executeQuery:SQL_SELECTHIGHSCORE]; //get highscore
    while([result next]){
        //        int result_id = [result intForColumn:@"id"];
        //        NSString *result_name = [result stringForColumn:@"playerName"];
        int result_score = [result intForColumn:@"score"];
        Intro3.text = [NSString stringWithFormat:@"Top Player's Score: %d",result_score];
    }
    [db close];

}

-(void)HeliMove{
    [self Collision];
    
    Heli.center = CGPointMake(Heli.center.x, Heli.center.y + Y);
    
    Obstacle.center = CGPointMake(Obstacle.center.x - 10, Obstacle.center.y);
    Obstacle2.center = CGPointMake(Obstacle2.center.x - 10, Obstacle2.center.y);
    Bottom1.center = CGPointMake(Bottom1.center.x -10, Bottom1.center.y);
    Bottom2.center = CGPointMake(Bottom2.center.x -10, Bottom2.center.y);
    Bottom3.center = CGPointMake(Bottom3.center.x -10, Bottom3.center.y);
    Bottom4.center = CGPointMake(Bottom4.center.x -10, Bottom4.center.y);
    Bottom5.center = CGPointMake(Bottom5.center.x -10, Bottom5.center.y);
    Bottom6.center = CGPointMake(Bottom6.center.x -10, Bottom6.center.y);
    Bottom7.center = CGPointMake(Bottom7.center.x -10, Bottom7.center.y);
    Top1.center = CGPointMake(Top1.center.x -10, Top1.center.y);
    Top2.center = CGPointMake(Top2.center.x -10, Top2.center.y);
    Top3.center = CGPointMake(Top3.center.x -10, Top3.center.y);
    Top4.center = CGPointMake(Top4.center.x -10, Top4.center.y);
    Top5.center = CGPointMake(Top5.center.x -10, Top5.center.y);
    Top6.center = CGPointMake(Top6.center.x -10, Top6.center.y);
    Top7.center = CGPointMake(Top7.center.x -10, Top7.center.y);
    
    if(Obstacle.center.x < 0){
        RandomPosition = arc4random() %75;
        RandomPosition = RandomPosition + 110;
        Obstacle.center = CGPointMake(510, RandomPosition);
        
    }
    if(Obstacle2.center.x < 0){
        RandomPosition = arc4random() %75;
        RandomPosition = RandomPosition + 110;
        Obstacle2.center = CGPointMake(510, RandomPosition);
        
    }
    if(Top1.center.x < -30){
        RandomPosition = arc4random() %55;
        Top1.center = CGPointMake(520, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom1.center = CGPointMake(520, RandomPosition);
    }
    if(Top2.center.x < -30){
        RandomPosition = arc4random() %55;
        Top2.center = CGPointMake(520, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom2.center = CGPointMake(520, RandomPosition);
    }
    if(Top3.center.x < -30){
        RandomPosition = arc4random() %55;
        Top3.center = CGPointMake(520, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom3.center = CGPointMake(520, RandomPosition);
    }
    if(Top4.center.x < -30){
        RandomPosition = arc4random() %55;
        Top4.center = CGPointMake(520, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom4.center = CGPointMake(520, RandomPosition);
    }
    if(Top5.center.x < -30){
        RandomPosition = arc4random() %55;
        Top5.center = CGPointMake(520, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom5.center = CGPointMake(510, RandomPosition);
    }
    if(Top6.center.x < -30){
        RandomPosition = arc4random() %55;
        Top6.center = CGPointMake(520, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom6.center = CGPointMake(520, RandomPosition);
    }
    if(Top7.center.x < -30){
        RandomPosition = arc4random() %55;
        Top7.center = CGPointMake(520, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom7.center = CGPointMake(520, RandomPosition);
    }

}

-(void)Scoring{
    ScoreNumber++;
    Score.text = [NSString stringWithFormat:@"Score: %i",ScoreNumber];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(Start == YES){
        Intro1.hidden = YES;
        Intro2.hidden = YES;
        Intro3.hidden = YES;
        Ranking.hidden =YES;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(HeliMove) userInfo:nil repeats:YES];
        Scorer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Scoring) userInfo:nil repeats:YES];
        Start = NO;
        
        Bottom1.hidden = NO;
        Bottom2.hidden = NO;
        Bottom3.hidden = NO;
        Bottom4.hidden = NO;
        Bottom5.hidden = NO;
        Bottom6.hidden = NO;
        Bottom7.hidden = NO;
        Top1.hidden = NO;
        Top2.hidden = NO;
        Top3.hidden = NO;
        Top4.hidden = NO;
        Top5.hidden = NO;
        Top6.hidden = NO;
        Top7.hidden = NO;
        Obstacle.hidden = NO;
        Obstacle2.hidden = NO;
        
        RandomPosition = arc4random() %75;
        RandomPosition = RandomPosition + 110;
        Obstacle.center = CGPointMake(570, RandomPosition);
        
        RandomPosition = arc4random() %75;
        RandomPosition = RandomPosition + 110;
        Obstacle2.center = CGPointMake(855, RandomPosition);
        
        
        
        RandomPosition = arc4random() %55;
        Top1.center = CGPointMake(560, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom1.center = CGPointMake(560, RandomPosition);
        
        RandomPosition = arc4random() %55;
        Top2.center = CGPointMake(640, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom2.center = CGPointMake(640, RandomPosition);
        
        RandomPosition = arc4random() %55;
        Top3.center = CGPointMake(720, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom3.center = CGPointMake(720, RandomPosition);
        
        RandomPosition = arc4random() %55;
        Top4.center = CGPointMake(800, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom4.center = CGPointMake(800, RandomPosition);
        
        RandomPosition = arc4random() %55;
        Top5.center = CGPointMake(880, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom5.center = CGPointMake(880, RandomPosition);
        
        RandomPosition = arc4random() %55;
        Top6.center = CGPointMake(960, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom6.center = CGPointMake(960, RandomPosition);
        
        RandomPosition = arc4random() %55;
        Top7.center = CGPointMake(1040, RandomPosition);
        RandomPosition = RandomPosition + 265;
        Bottom7.center = CGPointMake(1040, RandomPosition);
        
    }
    Y = -7;
    Heli.image = [UIImage imageNamed:@"HeliUp.png"];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    Y = 7;
    Heli.image = [UIImage imageNamed:@"HeliDown.png"];
    
}

- (void)viewDidLoad
{
    Start = YES;
    Bottom1.hidden = YES;
    Bottom2.hidden = YES;
    Bottom3.hidden = YES;
    Bottom4.hidden = YES;
    Bottom5.hidden = YES;
    Bottom6.hidden = YES;
    Bottom7.hidden = YES;
    Top1.hidden = YES;
    Top2.hidden = YES;
    Top3.hidden = YES;
    Top4.hidden = YES;
    Top5.hidden = YES;
    Top6.hidden = YES;
    Top7.hidden = YES;
    Obstacle.hidden = YES;
    Obstacle2.hidden = YES;
    BackButton.hidden = YES;
    NameField.hidden = YES;
    
//    HighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
//    Intro3.text = [NSString stringWithFormat:@"High Score: %i",HighScore];

    
    FMDatabase *db= [self getConnection];
    [db open];
    [db executeUpdate:SQL_CREATE];
    FMResultSet *result = [db executeQuery:SQL_SELECTHIGHSCORE]; //get highscore
    while([result next]){
//        int result_id = [result intForColumn:@"id"];
//        NSString *result_name = [result stringForColumn:@"playerName"];
        int result_score = [result intForColumn:@"score"];
        Intro3.text = [NSString stringWithFormat:@"Top Player's Score: %d",result_score];
    }
    [db close];

    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
