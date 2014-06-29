//
//  PicturesCell.m
//  Anime-pictures
//
//  Created by iButs on 25.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "PicturesCell.h"

@implementation PicturesCell
@synthesize firstImage;
@synthesize secondImage;
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

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImagesFormURL:(NSString*) first :(NSString*) second{

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *url = first;
        NSURL *crrnturl = [NSURL URLWithString:url];
        NSData *data = [NSData dataWithContentsOfURL:crrnturl];
        UIImage *image1 = [UIImage imageWithData:data];
    

        url = second;
        crrnturl = [NSURL URLWithString:url];
        data = [NSData dataWithContentsOfURL:crrnturl];
        UIImage *image2 = [UIImage imageWithData:data];
    
        dispatch_sync(dispatch_get_main_queue(),^{
        firstImage.image = image1;
        secondImage.image = image2;
    
        });
    });

}



@end
