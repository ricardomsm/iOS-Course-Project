//
//  FavouritesManager.m
//  Football Matches Project
//
//  Created by Ricardo Magalhães on 28/09/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "FavouritesManager.h"
#import "AppDelegate.h"

@implementation FavouritesManager

+(void)createFavouriteWithTeamID:(NSNumber *)teamID andTeamName:(NSString *)teamName {
    
    NSManagedObjectContext *context = [FavouritesManager context];
    
    FavouritesMO *favourite = [NSEntityDescription insertNewObjectForEntityForName:@"Favourites" inManagedObjectContext:context];

    favourite.teamID = teamID.intValue;
    favourite.teamName = teamName;

    [context save:nil];
    
}

+(FavouritesMO *)searchFavouriteWithTeamName:(NSNumber *)teamID {
    
    NSManagedObjectContext *context = [FavouritesManager context];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"teamID == %@", teamID];
    
    NSFetchRequest *fetchRequest = [FavouritesMO fetchRequest];
    [fetchRequest setPredicate:pred];
    FavouritesMO *favourite = [[context executeFetchRequest:fetchRequest error:nil] firstObject];
    return favourite;
}

+ (NSManagedObjectContext *)context {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return appDelegate.persistentContainer.viewContext;
    
}

+ (NSArray <FavouritesMO *> *)allFavourites {
    
    NSManagedObjectContext *context = [FavouritesManager context];
    
    NSFetchRequest *favouritesFetch = [FavouritesMO fetchRequest];
    
    NSArray<FavouritesMO *> *favourites = [context executeFetchRequest:favouritesFetch error:nil];
    
    return favourites;
    
}

+ (void)deleteFavourite:(FavouritesMO *)favourite {
    
    NSManagedObjectContext *context = [FavouritesManager context];
    [context deleteObject:favourite];
    [context save:nil];
    
}

@end
