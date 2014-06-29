//
//  SettingsCell.h
//  Anime-pictures
//
//  Created by iButs on 25.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *setXField;
@property (strong, nonatomic) IBOutlet UITextField *setYField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *recentSegments;

@end
