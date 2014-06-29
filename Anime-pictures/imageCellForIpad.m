//
//  imageCellForIpad.m
//  Anime-pictures
//
//  Created by iButs on 27.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "imageCellForIpad.h"

@implementation imageCellForIpad
@synthesize firstImage;
@synthesize secondImage;
@synthesize thirdImage;
@synthesize fourthImage;
@synthesize fivethImage;

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

-(void)setImagesFromArray:(NSArray*) array andSetIDS:(NSArray*) ids{
    NSLog(@"Images for cell is: %@", array);
    NSArray *images = [NSArray arrayWithObjects:firstImage,secondImage,thirdImage,fourthImage, fivethImage, nil];
    int i = 0;
    for (UIImage *image1 in array){
        dispatch_async(dispatch_get_main_queue(), ^{
        CGRect bounds = CGRectMake(0,0,image1.size.width,image1.size.height);
        [(UIImageView*)[images objectAtIndex:i] setBounds:bounds];
        [[images objectAtIndex:i]setImage:image1];
        NSString *string = [ids objectAtIndex:i];
        [[images objectAtIndex:i]setTag:[string integerValue]];
        });
        i++;
            
    }
    [self setBackgroundColor:[UIColor blackColor]];
}
@end
