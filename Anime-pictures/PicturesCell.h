//
//  PicturesCell.h
//  Anime-pictures
//
//  Created by iButs on 25.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicturesCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *firstImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondImage;

-(void)setImagesFormURL:(NSString*) first :(NSString*) second;

@end
