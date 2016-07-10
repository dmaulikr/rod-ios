//
//  RunTableViewCell.h
//  RoD
//
//  Created by Pedro Anisio Silva on 09/07/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *distance_txt;
@property (weak, nonatomic) IBOutlet UILabel *decimal_distance_txt;
@property (weak, nonatomic) IBOutlet UILabel *date_human_txt;
@property (weak, nonatomic) IBOutlet UILabel *km_label;
@property (weak, nonatomic) IBOutlet UILabel *pace_txt;
@property (weak, nonatomic) IBOutlet UIImageView *pace_icon;
@property (weak, nonatomic) IBOutlet UIImageView *run_photo;

@end
