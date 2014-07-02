//
//  ConnectionManager.h
//  Anime-pictures
//
//  Created by iButs on 10.04.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol downloadingConnectionManagerDelegate;
@protocol loginUserDelegate;
@protocol downloadSmallPreviewsDelegate;
@protocol downloadImageDetails;

@interface ConnectionManager : NSObject<NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate>
{
    NSMutableArray *imagesIDS;
    NSArray *imagesPathes;
    NSMutableArray *images;
    NSMutableString *imageID;
    NSMutableString *imagePathForBigPreview;
    NSMutableString *imagePathForMediumPreview;
    NSMutableString *imagePathForFullSize;
    NSMutableString *authorName;
    UIImage *image;
    
}
@property (nonatomic, weak)id<downloadingConnectionManagerDelegate>delegate;

@property (nonatomic, weak)id<loginUserDelegate>loginDelegate;
@property (nonatomic, weak)id<downloadSmallPreviewsDelegate>smallPreviewsDelegate;
@property (nonatomic, weak)id<downloadImageDetails>imageDetailsDelegate;

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSURLSession *currentSession;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;
@property BOOL isVotedImage;
@property BOOL isFavoriteImage;
@property (strong, nonatomic) NSArray *imagesTags;

-(ConnectionManager*)init;
-(ConnectionManager*)initForLoginController;
-(ConnectionManager*)initForDetailsController;
-(ConnectionManager*)initForSearchingAndFavoritesConrollers;

-(void)loginUserWithName:(NSString*)name andPassword:(NSString*)password;
-(void)authorizedUser;
//-(void)newURLDataTaskWithRequest:(NSURLRequest*) request andParsingMethodWithName:(NSString*)name;
-(void)setImageID:(NSNumber*)imageTag;
-(void)reloadImagesArray;
//-(NSString*)getUserID;
-(NSArray*)getImagesIDs;
-(UIImage*)getImage;
-(NSString*)getAuthorName;
-(NSArray*)getTagsArray;
-(NSArray*)fetImagesIDs;
-(UIImage*)downloadFullSizeImage;
-(UIImage*)downloadBigPreviewImage;
-(UIImage*)downloadMediumPreviewImage;
-(NSArray*)returnSmallPreviews;
//-(UIImage*)downloadImageFromPath:(NSString*)path;
-(void)downloadSmallPreviewsImagesForPage:(int)pageNumber;

-(void)downloadingPathesForDetailsForImage;
-(void)downloadingPathesForFavoritesWithPageNumber:(int) number;
-(void)downloadingPathesForImagesFromSearchTag:(NSString*)searchTag forPageWithNumber:(int) pageNumber withHeight:(NSString*)height andWeight:(NSString*) weight withOrderBY:(NSString*) orderBy andRecentBy:(NSString*) recentBy;

-(void)parsingPathForImageFromDictionary:(NSDictionary*) imageDict;
-(void)parsingUserIDFromDictionary:(NSDictionary *)ids;
-(void)parsingPathesForSmallPreviewsFromDictionary:(NSDictionary *)pathes;

-(BOOL)addImageToFavourites;
-(BOOL)voteFromImage;
-(void)loginUserWithToken:(NSString*)token;
@end


#pragma - mark ---PROTOCOLS----

@protocol downloadingConnectionManagerDelegate<NSObject>
@optional
-(void)userIdDidParsing;
-(void)parsingPathesForSmallPreviews;
-(void)imageDetailsDidParsing;
-(void)imagesDidLoad;
-(void)imageDidLoad;

@end

@protocol loginUserDelegate<NSObject>
@required
-(void)userIdDidParsing;
@end

@protocol downloadSmallPreviewsDelegate<NSObject>
@required
-(void)parsingPathesForSmallPreviews;
-(void)imagesDidLoad;
@end

@protocol downloadImageDetails<NSObject>
@required
-(void)imageDetailsDidParsing;
-(void)imageDidLoad;
@end
