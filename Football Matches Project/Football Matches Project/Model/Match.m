//
//  Match.m
//  Football Matches Project
//
//  Created by Ricardo Magalhães on 24/09/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "Match.h"

@implementation Match

- (instancetype)initWithDictionary:(NSDictionary *)matchDictionary {
    
    self = [super init];
    
    if (self) {
        _homeTeam = matchDictionary[@"homeTeam"][@"name"];
        _awayTeam = matchDictionary[@"awayTeam"][@"name"];
        _competitionID = matchDictionary[@"competition"][@"id"];
        _competitionName = matchDictionary[@"competition"][@"name"];
        _status = matchDictionary[@"status"];
        
        // Formatting match time
        NSDateFormatter *dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *matchTime = [dateFormat dateFromString:matchDictionary[@"utcDate"]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:matchTime];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        NSString *hourString = hour < 10 ? [NSString stringWithFormat:@"0%ld", hour] : [NSString stringWithFormat:@"%ld", hour];
        NSString *minuteString = minute < 10 ? [NSString stringWithFormat:@"0%ld", minute] : [NSString stringWithFormat:@"%ld", minute];
        _matchHour = [NSString stringWithFormat:@"%@:%@", hourString, minuteString];
        
        
        // Assigning team scores
        id homeScore = matchDictionary[@"score"][@"fullTime"][@"homeTeam"];
        id awayScore = matchDictionary[@"score"][@"fullTime"][@"awayTeam"];
        if ([homeScore isKindOfClass:[NSNumber class]] && [awayScore isKindOfClass:[NSNumber class]]) {
            _homeTeamScore = homeScore;
            _awayTeamScore = awayScore;
        }
        
    }
    
    return self;
}

@end
