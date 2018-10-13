//
//  StandingTableViewCell.h
//  Football Matches Project
//
//  Created by Ricardo Magalhães on 26/09/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandingTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *position;
@property(weak, nonatomic) IBOutlet UILabel *teamName;
@property(weak, nonatomic) IBOutlet UILabel *matchesPlayed;
@property(weak, nonatomic) IBOutlet UILabel *points;
@property (weak, nonatomic) IBOutlet UILabel *gamesWonLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamesDrawnLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamesLostLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalsForLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalsAgainsLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteStar;


@end
