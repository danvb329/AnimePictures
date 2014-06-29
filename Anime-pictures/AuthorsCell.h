//
//  AuthorsCell.h
//  Anime-pictures
//
//  Created by iButs on 25.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorsCell : UITableViewCell{
    IBOutlet UIImageView *authorLogo;
    IBOutlet UILabel *authorName;
    NSString *authorID;
}

@end
