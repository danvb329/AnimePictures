//
//  SettingsCell.m
//  Anime-pictures
//
//  Created by iButs on 25.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell
@synthesize setXField;
@synthesize setYField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)autoPressed:(id)sender {
    [setXField setText:[NSString stringWithFormat:@"%f",self.superview.frame.size.width]];
    [setYField setText:[NSString stringWithFormat:@"%f",self.superview.frame.size.height]];
}

@end
