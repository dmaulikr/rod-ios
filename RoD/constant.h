//
//  constant.h
//  YoVideo
//
//  Created by Huyns89 on 7/3/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEVEL
#define ENDPOINT_URL @"http://app.runordie.run"
#elif defined(STAGING)
#define ENDPOINT_URL @"http://stagingserver:8080/EndPoint"
#else
#define ENDPOINT_URL @"http://app.runordie.run"
#endif

#define base_url  @"http://test.inspius.com/yovideo/api"

#define URL_LOGIN             @"login"
#define URL_LOGIN_FACEBOOK    @"loginFacebook"
#define URL_REGISTER          @"register"
#define URL_FORGOT_PASS       @"forgot_password"
#define URL_CHANGE_PASS       @"change_password"
#define URL_CHANGE_PROFILE    @"change_profile"
#define URL_CHANGE_AVATAR     @"change_avatar"

#define URL_GET_CATEGORIES    @"categories"
#define URL_GET_BY_CATEGORY   @"getListVideoByCategory"
#define URL_GET_HOME_DATA     @"getListVideoForHomepage"
#define URL_GET_WISHLIST      @"getWishlist"
#define URL_GET_BY_KEYWORD    @"getListVideoByKeyword"
#define URL_UPDATE_STATISTIC  @"updateStatistics"
#define URL_ADD_TO_WISHLIST   @"addToWishlist"
#define URL_GET_RECENT_VIDEO  @"getListRecentVideo"
#define URL_GET_LASTEST_VIDEO @"getListVideoLasted"
#define URL_GET_MOST_VIEW     @"getListVideoMostView"
#define URL_GET_BY_SERIES     @"getVideosBySeries"
#define URL_

#define URL_UPLOAD_VIDEO    @"uploadVideo"

#define URL_TOS             @"http://inspius.com"
#define URL_ABOUT_US        @"http://inspius.com/about-us"

#define kRatingURL          @"itms-apps://itunes.apple.com/app/id979212354"
#define kRatingURL_HTTP     @"https://itunes.apple.com/app/id979212354"

#define kParseApplicationId @"0QLX1Otjgf0Tbqie0Ur7P3w2ZPlRkybuPXVPeb3v"
#define kParseClientId      @"ZzJDCXI7ducISZgs8QBwJUiIJsCr8LfJb1OsdRVS"

#define kNotificationUserDidLoggedOut   @"user_did_logged_out"
#define kNotificationUserReadOnline     @"user_read_online"

#define kSearchKey                      @"search"
#define PRINT_LOG_LEVEL 1

#if (PRINT_LOG_LEVEL == 1)
#define DLog(...) NSLog(__VA_ARGS__)
#elif (PRINT_LOG_LEVEL == 0)
#define DLog(...) while(0)
#endif

#pragma mark api feed URL

#pragma mark define messages

#define kMessageServerError                  @"Cannot connect to server"
#define kInterErrorMessage                   @"Please check your internet connection and try again!"
#define kSpecialCharacters                   @"!#$%^&*()-+\"\'"
#define kMessageContainSpecialCharacters     @"Special characters are not accepted: !@#$%^&*()-+\"\'"
#define kMessageContainEmoji                 @"Do not use Emoji characters"
#define kMessageUserNameNotValid            @"Username must contain only alphanumeric, number and _ or -"

#define kDefaultDateTimeFormat  @"dd-MM-yyyy"

#define kDefaultDateAndTimeFormat @"dd-MM-yyyy HH:mm:ss"
typedef enum : NSUInteger {
    SOCIAL_FACEBOOK = 1,
    SOCIAL_TWITER = 2,
    SOCIAL_GOOGLE = 3,
    SOCIAL_YAHOO = 4,
    LOGIN_NORMAL = 5
} LOGIN_TYPE;

/**
 *  use to define the current status of user: loggedout, using app by login, using app by non-login feature
 */
#define kUserInfo  @"user_info_model"

#define kUserToken  @"user_token"
#define kUserName   @"user_name"
#define kUserEmail  @"user_email"
#define kUserAvatar @"user_image"

#define kLIST_CATEGOIES @"list_categories"

#define kTimeIntervalForAds 180

#define kDateTimePicked    @"picker_status"
#define kUserLoginStatus    @"user_login_status"
#define kLastTimeGetBookCategory    @"last_time_get_book_categories"
#define kLastTimeGetMangaCategory   @"last_time_get_manga_categories"
#define kLastTimeShowFullAds        @"lasttimeshowfullads"

#define kFirstPage  1
#define kPageSize   10

typedef enum : NSUInteger {
    USER_STATUS_LOGGEDOUT = -1,
    USER_STATUS_LOGGEDIN = 1,
    USER_STATUS_NON_LOGIN = 2
} LOGIN_STATUS;

FOUNDATION_EXPORT NSString *const SubMenuTypeSach;
FOUNDATION_EXPORT NSString *const SubMenuTypeTruyen;
FOUNDATION_EXPORT NSString *const StringPublishActionPermission;

typedef enum : NSUInteger {
    DATETIME_PICKED = -1,
    DATETIME_NOT_PICKED = 1
} DATETIME_PICKER;

@interface constant : NSObject

@end
