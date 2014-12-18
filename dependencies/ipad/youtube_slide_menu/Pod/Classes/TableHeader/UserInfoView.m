//
//  UserInfoView.m
//  NIBMultiViewsApp
//
//  Created by djzhang on 10/27/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "UserInfoView.h"
#import <Business-Logic-Layer/YoutubeAuthInfo.h>
#import "CacheImageConstant.h"


@implementation UserInfoView

- (UIView *)bind:(YoutubeAuthInfo *)authInfo {
   NSString * title = authInfo.title;
   NSString * email = authInfo.email;
   NSString * thumbnailUrl = authInfo.thumbnailUrl;

   // 1
   [YTCacheImplement CacheWithImageView:self.userHeader withUrl:thumbnailUrl
                        withPlaceholder:[UIImage imageNamed:@"account_default_thumbnail.png"]];

   self.userTitle.text = title;
   self.userEmail.text = email;

   // 2 UIImageView Touch event
   UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(tapSignOut)];
   singleTap.numberOfTapsRequired = 1;
   [self.logOutImage setUserInteractionEnabled:YES];
   [self.logOutImage addGestureRecognizer:singleTap];

   return self;
}


- (void)tapSignOut {
   [self.delegate signingOutTapped];
}
@end
