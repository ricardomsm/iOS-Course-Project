//
//  FavouritesManager.h
//  Football Matches Project
//
//  Created by Ricardo Magalhães on 28/09/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavouritesMO+CoreDataProperties.h"

@interface FavouritesManager : NSObject

+(void)createFavouriteWithTeamID:(NSNumber *)teamID andTeamName:(NSString *)teamName;

+(FavouritesMO *)searchFavouriteWithTeamName:(NSNumber *)teamID;

+ (NSArray <FavouritesMO *> *)allFavourites;

+ (void)deleteFavourite:(FavouritesMO *)favourite;

@end
