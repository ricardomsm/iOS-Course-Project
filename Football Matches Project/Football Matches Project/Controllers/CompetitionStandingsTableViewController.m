//
//  CompetitionStandingsTableViewController.m
//  Football Matches Project
//
//  Created by Ricardo Magalhães on 26/09/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "CompetitionStandingsTableViewController.h"
#import "FootballMatchesAPI.h"
#import "StandingTableViewCell.h"
#import "CompetitionTableStanding.h"
#import "FavouritesManager.h"

@interface CompetitionStandingsTableViewController ()

@property(strong, nonatomic) NSArray *competitionStandings;
@property(strong, nonatomic) NSArray <FavouritesMO *> *favourites;

@end

@implementation CompetitionStandingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.favourites = [FavouritesManager allFavourites];
    self.title = self.match.competitionName;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
    [self updateContent];
}

- (void)setCompetitionStandings:(NSArray *)competitionStandings {
    _competitionStandings = competitionStandings;
    [self updateUI];
}

- (IBAction)refresh:(UIRefreshControl *)sender {
    
    if (sender.isRefreshing) {
        [self updateContent];
    }
    
}

// MARK: updateUI
- (void)updateUI {
    
    [self.tableView reloadData];
    
}

// MARK: Updates content

- (void)updateContent {
    
    FootballMatchesAPI *clientAPI = [FootballMatchesAPI new];
    
    [clientAPI getStandingsforMatch:self.match withCompletion:^(NSArray<CompetitionTableStanding *> *standings, NSError *error) {
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{

            [self.refreshControl endRefreshing];
            if (error) {
                NSLog(@"%@", error);
            } else {
                self.competitionStandings = standings;
            }
        }];
        
    }];
    
}

#pragma mark - Table view data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.competitionStandings.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CompetitionTableStanding *tablePosition = self.competitionStandings[indexPath.row];

    FavouritesMO *favourite = [FavouritesManager searchFavouriteWithTeamName:tablePosition.teamID];
    
    if (favourite) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete team from Favourites" message:@"Do you want to delete this team from your Favourites list?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [FavouritesManager deleteFavourite:favourite];
            [self updateUI];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add team to Favourites" message:@"Do you want to add this to team to your Favourites list?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [FavouritesManager createFavouriteWithTeamID:tablePosition.teamID andTeamName:tablePosition.teamName];
            [self updateUI];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:addAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StandingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"standingTableCell" forIndexPath:indexPath];
    
    CompetitionTableStanding *standing = self.competitionStandings[indexPath.row];
    
    [self configureCell:cell withStanding:standing];

    return cell;
}

// MARK: Configure Cell
-(void)configureCell:(StandingTableViewCell *)cell withStanding:(CompetitionTableStanding *)standing {
    
    FavouritesMO *favourite = [FavouritesManager searchFavouriteWithTeamName:standing.teamID];
    
    cell.favouriteStar.image = nil;
    cell.containerView.backgroundColor = nil;
    
    cell.position.text = [NSString stringWithFormat:@"%@.", standing.position];
    cell.teamName.text = standing.teamName;
    cell.matchesPlayed.text = [NSString stringWithFormat:@"%@", standing.playedGames];
    cell.points.text = [NSString stringWithFormat:@"%@", standing.points];
    cell.gamesWonLabel.text = [NSString stringWithFormat:@"%@", standing.gamesWon];
    cell.gamesDrawnLabel.text = [NSString stringWithFormat:@"%@", standing.gamesDrawn];
    cell.gamesLostLabel.text = [NSString stringWithFormat:@"%@", standing.gamesLost];
    
    if ([cell.teamName.text isEqualToString:self.match.homeTeam]) {
        cell.containerView.backgroundColor = [UIColor blueColor];
    }
    if ([cell.teamName.text isEqualToString:self.match.awayTeam]) {
        cell.containerView.backgroundColor = [UIColor redColor];
    }
    
    if (favourite) {
        cell.favouriteStar.image = [UIImage imageNamed:@"staricon"];
    }
        


}

@end
