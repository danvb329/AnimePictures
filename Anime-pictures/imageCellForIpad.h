//
//  imageCellForIpad.h
//  Anime-pictures
//
//  Created by iButs on 27.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageCellForIpad : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *firstImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondImage;
@property (strong, nonatomic) IBOutlet UIImageView *thirdImage;
@property (strong, nonatomic) IBOutlet UIImageView *fourthImage;
@property (strong, nonatomic) IBOutlet UIImageView *fivethImage;
@property (strong, nonatomic) NSArray *imageID;

-(void)setImagesFromArray:(NSArray*) array andSetIDS:(NSArray*) ids;

@end
