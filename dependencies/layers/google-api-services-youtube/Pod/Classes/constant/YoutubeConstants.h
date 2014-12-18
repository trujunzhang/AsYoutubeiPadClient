#ifdef __OBJC__


//================================================================================================
// Google-client-api
//================================================================================================
// module
#import "GTLYouTubeChannel.h"
#import "GTLYouTubeSubscription.h"
#import "GTLYouTubeSubscriptionSnippet.h"
#import "GTLYouTubeThumbnailDetails.h"
#import "GTLYouTubeThumbnail.h"
#import "GTLYouTubeChannelSnippet.h"
#import "GTLYouTubeVideo.h"
#import "GTLYouTubeVideoSnippet.h"
#import "GTLYouTubeVideoStatistics.h"
#import "GTLYouTubePlaylistItem.h"
#import "GTLYouTubePlaylistItemContentDetails.h"
#import "GTLYouTubeChannelBrandingSettings.h"
#import "GTLYouTubeImageSettings.h"

//
#import "GTLUtilities.h"
#import "GTMHTTPUploadFetcher.h"
#import "GTMHTTPFetcherLogging.h"

#import "GTLQueryYouTube.h"
#import "GTLYouTubeSearchListResponse.h"
#import "GTLYouTubeChannel.h"
#import "GTLYouTubeChannelContentDetails.h"
#import "GTLYouTubeSubscriptionListResponse.h"
#import "GTLYouTubePlaylistItemListResponse.h"
#import "GTLYouTubeChannelListResponse.h"
#import "GTLYouTubeSearchResult.h"
#import "GTLYouTubeResourceId.h"
#import "GTLYouTubePlaylistItem.h"


//
#import "GTLServiceYouTube.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"

//

//================================================================================================
// YouTubeAPI3-Objective-C-wrapper
//================================================================================================
#import "MABYT3_APIRequest.h"

// module
#import "MABYT3_Video.h"
#import "MABYT3_Thumbnail.h"
#import "MABYT3_ThumbnailDetails.h"
#import "MABYT3_SearchItem.h"
#include "MABYT3_Activity.h"
#import "MABYT3_Channel.h"
#import "MABYT3_ActivityContentDetails.h"
#import "MABYT3_ResourceId.h"
#import "MABYT3_PlayList.h"
#import "MABYT3_PlayListItem.h"
#import "MABYT3_ChannelBrandingSettings.h"

// common
#import <AsyncDisplayKit/AsyncDisplayKit.h>

// other
#import "YoutubeVideoCache.h"
#import "MABYT3_TranscriptList.h"
#import "MABYT3_Transcript.h"
#import "MABYT3_Track.h"

#endif


//#define hasShowLeftMenu NO
#define hasShowLeftMenu YES


#define SUBSCRIPTION_LIST_MAX 2
#define subscriptionIndex  0
//#define debugLeftMenuTapSubscription NO
#define debugLeftMenuTapSubscription YES

#define debugCollectionViewToDetail  NO
//#define debugCollectionViewToDetail  YES

#define debugCollectionViewToDetail_local  NO
//#define debugCollectionViewToDetail_local  YES


// module

//#define YTYouTubeVideo  GTLYouTubeVideo
//#define YTYouTubeVideo  MABYT3_Video

#define YTYouTubeVideoCache  YoutubeVideoCache

#define YTYouTubePlayList  MABYT3_PlayList
#define YTYouTubePlaylistItem  GTLYouTubePlaylistItem

// Channel for author
#define YTYouTubeAuthorChannel  GTLYouTubeChannel

// Channel for other request
#define YTYouTubeChannel  MABYT3_Channel

#if debugLeftMenuTapSubscription == YES
#define YTYouTubeSubscription  MABYT3_Subscription
#elif debugLeftMenuTapSubscription == NO
#define YTYouTubeSubscription  GTLYouTubeSubscription
#endif

#define YTYouTubeMABThumbmail  MABYT3_Thumbnail

//
#define YTServiceYouTube  GTLServiceYouTube
#define YTOAuth2Authentication  GTMOAuth2Authentication




//
#define YTQueryYouTube  GTLQueryYouTube


// different
//#define YTYouTubeSearchResult  GTLYouTubeSearchResult
#define YTYouTubeSearchResult  MABYT3_SearchItem

#define YTYouTubeActivity  MABYT3_Activity
#define YTYouTubeActivityContentDetails  MABYT3_ActivityContentDetails
#define YTYouTubeResourceId  MABYT3_ResourceId


















