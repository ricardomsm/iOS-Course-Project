//
//  Match.h
//  Football Matches Project
//
//  Created by Ricardo Magalhães on 24/09/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Match : NSObject

@property (strong, nonatomic, readonly) NSString *homeTeam;
@property (strong, nonatomic, readonly) NSString *awayTeam;
@property (strong, nonatomic, readonly) NSNumber *competitionID;
@property (strong, nonatomic, readonly) NSString *competitionName;
@property (strong, nonatomic, readonly) NSString *status;
@property (strong, nonatomic, readonly) NSNumber *homeTeamScore;
@property (strong, nonatomic, readonly) NSNumber *awayTeamScore;
@property (strong, nonatomic, readonly) NSString *matchHour;

- (instancetype)initWithDictionary:(NSDictionary *)matchDictionary;

@end
