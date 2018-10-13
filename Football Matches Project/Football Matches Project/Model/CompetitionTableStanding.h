//
//  CompetitionTableStanding.h
//  Football Matches Project
//
//  Created by Ricardo Magalhães on 26/09/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompetitionTableStanding : NSObject

@property(strong, nonatomic) NSNumber *position;
@property(strong, nonatomic) NSNumber *teamID;
@property(strong, nonatomic) NSString *teamName;
@property(strong, nonatomic) NSNumber *playedGames;
@property(strong, nonatomic) NSNumber *points;
@property(strong, nonatomic) NSNumber *gamesWon;
@property(strong, nonatomic) NSNumber *gamesDrawn;
@property(strong, nonatomic) NSNumber *gamesLost;
@property(strong, nonatomic) NSNumber *goalsScored;
@property(strong, nonatomic) NSNumber *goalsSuffered;

-(instancetype)initWithTableStandingDictionary:(NSDictionary *)tableStandingDictionary;

@end

