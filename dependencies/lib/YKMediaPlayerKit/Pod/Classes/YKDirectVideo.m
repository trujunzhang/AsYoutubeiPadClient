//
//  YKDirectVideo.m
//  YKMediaHelper
//
//  Created by Yas Kuraishi on 3/13/14.
//  Copyright (c) 2014 Yas Kuraishi. All rights reserved.
//

#import "YKDirectVideo.h"
#import "MPMoviePlayerController+Subtitles.h"
#import "SDSRTParserHelper.h"
#import "SRTParserHelper.h"
#import "SOSRTParserHelper.h"

CGFloat const kDirectThumbnailLocation = 1.0;


@interface YKDirectVideo ()
@property (nonatomic, strong) MPMoviePlayerViewController *player;
@end


@implementation YKDirectVideo

#pragma mark - YKVideo Protocol


- (instancetype)initWithContent:(NSURL *)contentURL {
    self = [super init];
    if(self) {
        self.contentURL = contentURL;
    }
    return self;
}


- (void)parseWithCompletion:(void (^)(NSError *error))callback {
    NSAssert(self.contentURL, @"Direct URLs to natively supported formats such as MP4 do not require calling this method.");
}


- (void)thumbImage:(YKQualityOptions)quality completion:(void (^)(UIImage *thumbImage, NSError *error))callback {
    NSAssert(callback, @"usingBlock cannot be nil");

    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                                      object:self.player
                                                       queue:[NSOperationQueue currentQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      MPMoviePlayerController *newPlayer = note.object;

                                                      if([newPlayer.contentURL.absoluteString isEqualToString:[self videoURL:quality].absoluteString]) {
                                                          UIImage *thumb = note.userInfo[@"MPMoviePlayerThumbnailImageKey"];
                                                          NSError *error = note.userInfo[@"MPMoviePlayerThumbnailErrorKey"];

                                                          if(thumb) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if(callback) callback(thumb, error);
                                                              });
                                                          }

                                                          //TODO: check callback might not happen if thumb could not be loaded
                                                      }
                                                  }];

    self.player = [[MPMoviePlayerViewController alloc] initWithContentURL:[self videoURL:quality]];
    [self.player.moviePlayer setShouldAutoplay:NO];
    [self.player.moviePlayer prepareToPlay];
    [self.player.moviePlayer requestThumbnailImagesAtTimes:@[@(kDirectThumbnailLocation)]
                                                timeOption:MPMovieTimeOptionExact];
}


- (NSURL *)videoURL:(YKQualityOptions)quality {
    return self.contentURL;
}


#pragma warning Move to Parent class


- (MPMoviePlayerViewController *)movieViewController:(YKQualityOptions)quality {
    self.player = [[MPMoviePlayerViewController alloc] initWithContentURL:[self videoURL:quality]];
    [self.player.moviePlayer setShouldAutoplay:NO];
    [self.player.moviePlayer prepareToPlay];

    return self.player;
}


- (void)playInView:(UIView *)pView withQualityOptions:(YKQualityOptions)quality {
    if(!self.player) [self movieViewController:quality];

    self.player.moviePlayer.view.frame = pView.bounds;// used
    self.player.moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;


    [pView addSubview:self.player.moviePlayer.view];
    [self.player.moviePlayer play];
}


- (void)play:(YKQualityOptions)quality {
    if(!self.player) [self movieViewController:quality];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentMoviePlayerViewControllerAnimated:self.player];
    [self.player.moviePlayer play];
}


- (void)play:(YKQualityOptions)quality subtitlesPathStr:(NSString *)localSRTPath {
    if(!self.player) [self movieViewController:quality];

    BOOL myPathIsDir;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:localSRTPath isDirectory:&myPathIsDir];
    if(fileExists == NO || localSRTPath == nil) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentMoviePlayerViewControllerAnimated:self.player];
        [self.player.moviePlayer play];
        return;
    }

    // Create MoviePlayer
    [self.player.moviePlayer openSRTFileAtPath:localSRTPath
//                                  parserHelper:[[SDSRTParserHelper alloc] init]
                                  parserHelper:[[SOSRTParserHelper alloc] init]
                                    completion:^(BOOL finished) {

                                        // Activate subtitles
                                        [self.player.moviePlayer showSubtitles];

                                        // Show video
                                        [[UIApplication sharedApplication].keyWindow.rootViewController presentMoviePlayerViewControllerAnimated:self.player];
                                        [self.player.moviePlayer play];

                                    } failure:^(NSError *error) {
                NSLog(@"Error: %@", error.description);
            }];

}

@end
