//
//  SettingsViewController.h
//  Anime-pictures
//
//  Created by iButs on 03.04.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *itsX;
@property (strong, nonatomic) IBOutlet UITextField *itsY;
@property (strong, nonatomic) IBOutlet UISegmentedControl *itsHowRecent;
@property (strong, nonatomic) IBOutlet UISegmentedControl *itsSortingsBy;
@property (strong,nonatomic) NSString *sortingOrder;
@property (strong, nonatomic) NSString *recentOrder;

@end
