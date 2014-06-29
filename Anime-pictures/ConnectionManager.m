//
//  ConnectionManager.m
//  Anime-pictures
//
//  Created by iButs on 10.04.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "ConnectionManager.h"

#define URL_POST_LOGINIG @"http://anime-pictures.net/login/submit"
#define URL_FAVORITES_PATHES_P_1 @"http://anime-pictures.net/pictures/view_posts/"
#define URL_FAVORITES_PATHES_P_2 @"?lang=en&type=json&favorite_by="
#define URL_TAG_PATHES_P_1 @"http://anime-pictures.net/pictures/view_posts/"
#define URL_TAG_PATHES_P_2 @"?lang=en&posts_per_page=200&type=json&search_tag="
//&denied_tags=erotic
#define URL_TAG_PATHES_P_3 @"&res_x="
#define URL_TAG_PATHES_P_4 @"&res_y="
#define URL_TAG_PATHES_P_5 @"&order_by="
#define URL_TAG_PATHES_P_6 @"&ldate="
#define URL_PATH_FOR_IMAGE_ID_P_1 @"http://anime-pictures.net/pictures/view_post/"
#define URL_PATH_FOR_IMAGE_ID_P_2 @"?lang=en&type=json&"
#define URL_POST_SET_RAITING @"http://anime-pictures.net/pictures/vote"
#define URL_POST_FAVORITE_FOLDER_P_1 @"http://anime-pictures.net/pictures/set_favorites/"
#define URL_POST_FAVORITE_FOLDER_P_2_DELETE_FROM_FAVORITE @"?favorite_folder=Null"
#define URL_POST_FAVORITE_FOLDER_P_2_ADD_TO_FAVORITE @"?favorite_folder=default"
#define NOTE_RAITING_STRING @"post=%@&vote=%@"
#define NOTE_LOGINING_STRING @"login=%@&password=%@"

@implementation ConnectionManager

@synthesize userID;
@synthesize isFavoriteImage;
@synthesize isVotedImage;
@synthesize imagesTags;

-(ConnectionManager*)init{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    self = [super init];
    imagesIDS = [[NSMutableArray alloc]init];
    imagesPathes = [[NSMutableArray alloc]init];
    images = [[NSMutableArray alloc]init];
    imageID = [[NSMutableString alloc]init];
    imagePathForBigPreview = [[NSMutableString alloc]init];
    imagePathForMediumPreview =  [[NSMutableString alloc]init];
    imagePathForFullSize = [[NSMutableString alloc]init];
    authorName = [[NSMutableString alloc]init];
    image = [[UIImage alloc]init];
    self.isVotedImage = 0;
    self.isFavoriteImage = 0;
    return self;
    
}

//ADD FUNCTION LOAD ALL FAVORITES ON MY IPAD
 

-(ConnectionManager*)initForLoginController{
    self = [super init];
    return self;
}

-(ConnectionManager*)initForDetailsController{
    self = [super init];
    imageID = [[NSMutableString alloc]init];
    imagePathForBigPreview = [[NSMutableString alloc]init];
    imagePathForMediumPreview =  [[NSMutableString alloc]init];
    imagePathForFullSize = [[NSMutableString alloc]init];
    authorName = [[NSMutableString alloc]init];
    image = [[UIImage alloc]init];
    self.isVotedImage = 0;
    self.isFavoriteImage = 0;
    return self;
}

-(ConnectionManager*)initForSearchingAndFavoritesConrollers{
    self = [super init];
    imagesIDS = [[NSMutableArray alloc]init];
    imagesPathes = [[NSMutableArray alloc]init];
    return self;
}

-(NSURLSession*)currentSession{
    return [NSURLSession sharedSession];
}


-(void)authorizedUser{
    
}
#pragma-mark -----main functions-----

-(void)newURLDataTaskWithRequest:(NSURLRequest*) request andParsingMethodWithName:(NSString*)name{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"request is:%@",request);
    if (request){
        NSURLSessionDataTask *media = [self.currentSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([name isEqualToString:@"login"])
                [self parsingUserIDFromDictionary:dict];
            else if ([name isEqualToString:@"favorites"])
                [self parsingPathesForSmallPreviewsFromDictionary:dict];
            else if ([name isEqualToString:@"details_image"])
                [self parsingPathForImageFromDictionary:dict];
        }];
        [media resume];
    }
}

-(void)setImageID:(NSNumber*)imageTag{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    imageID = [NSMutableString stringWithFormat:@"%@",imageTag];
    NSLog(@"%@",imageID);
}

-(UIImage*)getImage{
    return image;
}

-(NSArray*)getImagesIDs{
    return imagesIDS;
}

-(NSString*)getAuthorName{
    return authorName;
}

-(NSArray*)getTagsArray{
    return imagesTags;
}

-(void)reloadImagesArray{
    imagesPathes = nil;
    images = [[NSMutableArray alloc]init];
    imagesIDS = [[NSMutableArray alloc]init];
}
#pragma mark -----images downloading-----

-(UIImage*)downloadFullSizeImage{
    image = [self downloadImageFromPath:imagePathForFullSize];
    return image;
}

-(UIImage*)downloadBigPreviewImage{
    image = [self downloadImageFromPath:imagePathForBigPreview];
    
    // [self.imageDetailsDelegate imageDidLoad];
    
    [self.delegate imageDidLoad];
    return image;
}

-(UIImage*)downloadMediumPreviewImage{
    image = [self downloadImageFromPath:imagePathForMediumPreview];
    
    // [self.imageDetailsDelegate imageDidLoad];
    
    [self.delegate imagesDidLoad];
    return image;
}

-(void)downloadSmallPreviewsImagesForPage:(int)pageNumber{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (imagesPathes){
        for (NSString* path in imagesPathes){

            [images addObject:[self downloadImageFromPath:path]];
            NSLog(@"Images is %@",images);
            NSLog(@"Path is:%@",path);
            if ([path isEqualToString:[imagesPathes lastObject]])
               // [self.smallPreviewsDelegate imagesDidLoad];
                [self.delegate imagesDidLoad];
        }
    }
}

-(NSArray*)returnSmallPreviews{
    return images;
}

-(UIImage*)downloadImageFromPath:(NSString*)path{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    image = 0;
    NSString *url = [path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *crrnturl = [NSURL URLWithString:url];
    NSData *data = [NSData dataWithContentsOfURL:crrnturl];
    image = [UIImage imageWithData:data];
    return image;
}

#pragma mark -----logining request-----

-(void)loginUserWithName:(NSString*)nick andPassword:(NSString*)password{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSURL *url = [NSURL URLWithString:URL_POST_LOGINIG];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *noteDataString = [NSString stringWithFormat:NOTE_LOGINING_STRING,nick,password];
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [self newURLDataTaskWithRequest:request andParsingMethodWithName:@"login"];
}

#pragma mark -----downloading pathes-----

-(void)downloadingPathesForDetailsForImage{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSString *urlRequest = [NSString stringWithFormat:@"%@%@%@",URL_PATH_FOR_IMAGE_ID_P_1,imageID,URL_PATH_FOR_IMAGE_ID_P_2];
    NSURL *url = [NSURL URLWithString:urlRequest];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [self newURLDataTaskWithRequest:request andParsingMethodWithName:@"details_image"];
}

-(void)downloadingPathesForFavoritesWithPageNumber:(int) number{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSString *numberString = [NSString stringWithFormat:@"%d",number];
    NSString *urlRequest = [NSString stringWithFormat:@"%@%@%@%@",URL_FAVORITES_PATHES_P_1, numberString, URL_FAVORITES_PATHES_P_2,self.userID];
    NSURL *url = [NSURL URLWithString:urlRequest];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [self newURLDataTaskWithRequest:request andParsingMethodWithName:@"favorites"];
}

-(void)downloadingPathesForImagesFromSearchTag:(NSString*)searchTag forPageWithNumber:(int) pageNumber withHeight:(NSString*)height andWeight:(NSString*) weight withOrderBY:(NSString*) orderBy andRecentBy:(NSString*) recentBy{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSString *numberString = [NSString stringWithFormat:@"%d",pageNumber];
    NSString *urlRequest = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",URL_TAG_PATHES_P_1,numberString,URL_TAG_PATHES_P_2,searchTag,URL_TAG_PATHES_P_3,weight,URL_TAG_PATHES_P_4,height,URL_TAG_PATHES_P_5,orderBy,URL_TAG_PATHES_P_6,recentBy];
    NSURL *url = [NSURL URLWithString:urlRequest];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [self newURLDataTaskWithRequest:request andParsingMethodWithName:@"favorites"];
}

#pragma - mark -----parsing pathes-----

-(void)parsingPathForImageFromDictionary:(NSDictionary*) imageDict{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"Image JSOn :%@", imageDict);
    imagePathForBigPreview = [imageDict valueForKey:@"big_preview"];
    imagePathForFullSize = [imageDict valueForKey:@"file_url"];
    imagePathForMediumPreview = [imageDict valueForKey:@"medium_preview"];
    authorName = [imageDict valueForKey:@"user_name"];
    self.isVotedImage = [[imageDict valueForKey:@"star_it"]intValue];
    self.isFavoriteImage = [[imageDict valueForKey:@"is_favorites"]boolValue];
    self.imagesTags = [imageDict valueForKey:@"tags"];
    
   // [self.imageDetailsDelegate imageDetailsDidParsing];
    
    [self.delegate imageDetailsDidParsing];
}

-(void)parsingUserIDFromDictionary:(NSDictionary *)ids{

    self.userID = [ids valueForKey:@"user_id"];
    NSLog(@"user id is%@", self.userID);
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    [self.loginDelegate userIdDidParsing];
}

-(void)parsingPathesForSmallPreviewsFromDictionary:(NSDictionary *)pathes{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    imagesPathes = [[pathes valueForKey:@"posts"]valueForKey:@"small_preview"];
    imagesIDS =[[pathes valueForKey:@"posts"]valueForKey:@"id"];
    
   // [self.smallPreviewsDelegate parsingPathesForSmallPreviews];
    
    [self.delegate parsingPathesForSmallPreviews];
}

#pragma-mark ------actions with image-----

-(BOOL)addImageToFavourites{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSString *favFolder;
    if (!self.isFavoriteImage){
        favFolder = URL_POST_FAVORITE_FOLDER_P_2_ADD_TO_FAVORITE;
    } else if (self.isFavoriteImage){
        favFolder = URL_POST_FAVORITE_FOLDER_P_2_DELETE_FROM_FAVORITE;
    }
    NSMutableString *urlRequest = [[NSMutableString alloc]initWithFormat:@"%@%@%@",URL_POST_FAVORITE_FOLDER_P_1,imageID,favFolder];
    NSURL *url = [NSURL URLWithString:urlRequest];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [self newURLDataTaskWithRequest:request andParsingMethodWithName:nil];
    return !self.isFavoriteImage;
}

-(BOOL)voteFromImage{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSString *raiting;
    if (!self.isVotedImage){
        raiting = @"9";
    } else {
        raiting = @"0";
    }
    NSURL *url = [NSURL URLWithString:URL_POST_SET_RAITING];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *noteDataString = [NSString stringWithFormat:NOTE_RAITING_STRING,imageID,raiting];
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [self newURLDataTaskWithRequest:request andParsingMethodWithName:nil];
    return !self.isVotedImage;
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"Here we go");
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"Here we go");
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Here we go");
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    if (challenge.previousFailureCount == 0)
    {
        NSLog(@"HERE");
    }
    else
    {
        // handle the fact that the previous attempt failed
        NSLog(@"%s: challenge.error = %@", __FUNCTION__, challenge.error);
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    {
        if (challenge.previousFailureCount == 0)
        {
            NSLog(@"HERE");
        }
        else
        {
            NSLog(@"%s; challenge.error = %@", __FUNCTION__, challenge.error);
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
        
    }
}
@end
