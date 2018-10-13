//
//  CompetitionTableStanding.m
//  Football Matches Project
//
//  Created by Ricardo Magalhães on 26/09/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "CompetitionTableStanding.h"

@implementation CompetitionTableStanding

-(instancetype)initWithTableStandingDictionary:(NSDictionary *)tableStandingDictionary {
    
    self = [super init];
    
    if (self) {
        
        _position = tableStandingDictionary[@"position"];
        _teamID = tableStandingDictionary[@"team"][@"id"];
        _teamName = tableStandingDictionary[@"team"][@"name"];
        _playedGames = tableStandingDictionary[@"playedGames"];
        _points = tableStandingDictionary[@"points"];
        _gamesWon = tableStandingDictionary[@"won"];
        _gamesDrawn = tableStandingDictionary[@"draw"];
        _gamesLost = tableStandingDictionary[@"lost"];
        _goalsScored = tableStandingDictionary[@"goalsFor"];
        _goalsSuffered= tableStandingDictionary[@"goalsAgainst"];
        
    }
    
    return self;
}

@end
