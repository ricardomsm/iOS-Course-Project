//
//  FootballMatchesViewController.m
//  Football Matches Project
//
//  Created by Developer on 22/09/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "FootballMatchesViewController.h"
#import "MatchTableViewCell.h"
#import "FootballMatchesAPI.h"
#import "CompetitionStandingsTableViewController.h"
#import "FavouritesManager.h"

@interface FootballMatchesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSArray *matches;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSDate *matchDate;
@property (weak, nonatomic) UIRefreshControl *refreshControl;
@property(strong, nonatomic) NSArray <FavouritesMO *> *favourites;

@end

@implementation FootballMatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(updateContent) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    self.favourites = [FavouritesManager allFavourites];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.segmentedControl setSelectedSegmentIndex:1];
    [self.refreshControl beginRefreshing];
    [self updateContent];
}

- (void)setMatches:(NSArray *)matches {
    _matches = matches;
    [self updateUI];
}

// MARK: Update UI Method

- (void)updateUI {
    
    [self.tableView reloadData];
    
}

// MARK: Updates content

- (void)updateContent {
    
    FootballMatchesAPI *clientAPI = [FootballMatchesAPI new];
    [clientAPI getFootballMatcheswithDate:self.matchDate andCompletion:^(NSArray<Match *> *matches, NSError *error)  {

        [NSOperationQueue.mainQueue addOperationWithBlock:^{

            [self.refreshControl endRefreshing];
            if (error) {
                NSLog(@"%@", error);
            } else {
                self.matches = matches;
            }
        }];

    }];
    
}

- (IBAction)segmentChange:(UISegmentedControl *)sender {
    
    NSDate *date = nil;

    switch (sender.selectedSegmentIndex) {
        case 0:
            date = [NSDate dateWithTimeIntervalSinceNow:-86400];
            break;
            
        case 2:
            date = [NSDate dateWithTimeIntervalSinceNow:86400];
            break;
            
        default:
            break;
    }
    
    self.matchDate = date;
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
    [self updateContent];
}


// MARK: TableView DataSource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *competitionMatches = self.matches[section];
    NSInteger count = [competitionMatches count] - 1;
    return count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.matches.count;

}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSDictionary *competitionMatches = self.matches[section];
    return competitionMatches[@"competitionName"];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *competitionSection = self.matches[indexPath.section];
    NSArray *matchobjects = [competitionSection allValues];
    NSMutableArray *matches = [NSMutableArray new];
    
    for (Match *match in matchobjects) {
        if ([match isKindOfClass:[Match class]]) {
            [matches addObject:match];
        }
    }
    
    NSSortDescriptor *matchSort = [NSSortDescriptor sortDescriptorWithKey:@"matchHour" ascending:YES];
    NSArray *orderedArray = [matches sortedArrayUsingDescriptors:@[matchSort]];
    Match *match =  orderedArray[indexPath.row];
    [self performSegueWithIdentifier:@"showStandingsForMatch" sender:match];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell" forIndexPath:indexPath];
    
    NSDictionary *competitionSection = self.matches[indexPath.section];
    NSArray *matchobjects = [competitionSection allValues];
    NSMutableArray *matches = [NSMutableArray new];
    
    for (Match *match in matchobjects) {
        if ([match isKindOfClass:[Match class]]) {
            [matches addObject:match];
        }
    }
    
    NSSortDescriptor *matchSort = [NSSortDescriptor sortDescriptorWithKey:@"matchHour" ascending:YES];
    NSArray *orderedArray = [matches sortedArrayUsingDescriptors:@[matchSort]];
    Match *match =  orderedArray[indexPath.row];
    
    
    [self configureCell:cell withMatch:match];
    
    return cell;
    
}

// MARK: Configuring Match Cell
- (void)configureCell:(MatchTableViewCell *)cell withMatch:(Match *)match {

        cell.matchHour.text = match.matchHour;
        cell.homeTeam.text = match.homeTeam;
        cell.awayTeam.text = match.awayTeam;
        
        if (match.homeTeamScore == nil && match.awayTeamScore == nil) {
            cell.homeTeamScore.text = @"";
            cell.awayTeamScore.text = @"";
        } else {
            cell.homeTeamScore.text = [NSString stringWithFormat:@"%@", match.homeTeamScore];
            cell.awayTeamScore.text = [NSString stringWithFormat:@"%@", match.awayTeamScore];
        }
        cell.status.text = match.status;
}

// MARK: Prepare for Segue Method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showStandingsForMatch"]) {
        Match *match = sender;
        CompetitionStandingsTableViewController *competitionstandingsVC = segue.destinationViewController;
        
        competitionstandingsVC.match = match;
        
    }
    
}

@end
