//
//  FootballMatchesAPI.h
//  Football Matches Project
//
//  Created by Developer on 22/09/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Match.h"
#import "CompetitionTableStanding.h"

@interface FootballMatchesAPI : NSObject

- (void)getFootballMatcheswithDate:(NSDate *)date andCompletion:(void(^)(NSArray <Match*> *, NSError *))completion;

- (void)getStandingsforMatch:(Match *)match withCompletion:(void(^)(NSArray <CompetitionTableStanding *>*, NSError *))completion;

- (NSString *)configureMatchDateStringWithDay:(NSDate *)date;

@end
