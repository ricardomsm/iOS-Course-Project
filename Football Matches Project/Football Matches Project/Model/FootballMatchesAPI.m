//
//  FootballMatchesAPI.m
//  Football Matches Project
//
//  Created by Developer on 22/09/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "FootballMatchesAPI.h"

@implementation FootballMatchesAPI

/**
 Method for obtaining football matches based on a date

 @param date Date we want to pass in
 @param completion Completion Block
 */
- (void)getFootballMatcheswithDate:(NSDate *)date andCompletion:(void(^)(NSArray <Match *> *, NSError *))completion {
    
    NSURL *url = [NSURL new];
    
    if (!date) {
        url = [NSURL URLWithString:@"https://api.football-data.org/v2/matches"];
    } else {
        NSString *dayString = [self configureMatchDateStringWithDay:date];
        NSString *requestString = [NSString stringWithFormat:@"https://api.football-data.org/v2/matches?dateFrom=%@&dateTo=%@", dayString, dayString];
        url = [NSURL URLWithString:requestString];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"f3379dd66bd8493ab8a7e654e73923da" forHTTPHeaderField:@"X-Auth-Token"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
        } else {
            NSError *jsonError;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError) {
                completion(nil, jsonError);
            } else {
                
                NSArray *matchesDictionary = responseDictionary[@"matches"];
                NSMutableArray *matches = [NSMutableArray new];
                
                for (NSDictionary *matchDictionary in matchesDictionary) {
                    Match *match = [[Match alloc] initWithDictionary:matchDictionary];
                    [matches addObject:match];
                }
                
                NSSortDescriptor *sortMatchesByCompetition = [NSSortDescriptor sortDescriptorWithKey:@"competitionName" ascending:YES];
                [matches sortUsingDescriptors:@[sortMatchesByCompetition]];

                NSMutableArray *resultArray = [NSMutableArray new];
                NSArray *competitions = [matches valueForKeyPath:@"@distinctUnionOfObjects.competitionName"];
                for (NSString *competitionName in competitions)
                {
                    NSMutableDictionary *entry = [NSMutableDictionary new];
                    [entry setObject:competitionName forKey:@"competitionName"];
                    
                    NSArray *groupNames = [matches filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"competitionName = %@", competitionName]];
                    for (int i = 0; i < groupNames.count; i++)
                    {
                        Match *match = [groupNames objectAtIndex:i];
                        [entry setObject:match forKey:[NSString stringWithFormat:@"match%d", i + 1]];
                    }
                    [resultArray addObject:entry];
                }
                
                completion([resultArray copy], nil);
            }
        }
    }];
    
    [task resume];
    
}

// MARK: Formatting date to string for insertion in url request
- (NSString *)configureMatchDateStringWithDay:(NSDate *)date {
    
    NSDateFormatter *dayFormat = [NSDateFormatter new];
    [dayFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dayString = [dayFormat stringFromDate:date];
    
    return dayString;
    
}


/**
 Method for obtaining the standings of a competition based a user clicked match

 @param match Match the user clicked on
 @param completion Completion Block
 */
- (void)getStandingsforMatch:(Match *)match withCompletion:(void(^)(NSArray <CompetitionTableStanding *> *, NSError *))completion {
    
    NSString *requestStandingsString = [NSString stringWithFormat:@"https://api.football-data.org/v2/competitions/%@/standings", match.competitionID];
    
    NSURL *url = [NSURL URLWithString:requestStandingsString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"f3379dd66bd8493ab8a7e654e73923da" forHTTPHeaderField:@"X-Auth-Token"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
        } else {
            NSError *jsonError;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError) {
                completion(nil, jsonError);
            } else {
                
                NSArray *standingsDictionary = [responseDictionary[@"standings"] firstObject][@"table"];
                NSMutableArray *table = [NSMutableArray new];
                
                for (NSDictionary *tableDictionary in standingsDictionary) {
                    CompetitionTableStanding *standing = [[CompetitionTableStanding alloc] initWithTableStandingDictionary:tableDictionary];
                    [table addObject:standing];
                }
                completion([table copy], nil);
            }
        }
    }];
    
    [task resume];
    
}

@end
