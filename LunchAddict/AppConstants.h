//
//  AppConstants.h
//  LunchAddict
//
//  Created by SPEROWARE on 30/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>

//FOOD TRUCK ICON

#define FOOD_TRUCK_YELLOW_ICON      @"YELLOW"
#define FOOD_TRUCK_BLUE_ICON        @"BLUE"
#define FOOD_TRUCK_RED_ICON         @"RED"
#define FOOD_TRUCK_BLACK_ICON       @"BLACK"
#define FOOD_TRUCK_WHITE_ICON       @"WHITE"
#define FOOD_TRUCK_GREEN_ICON       @"GREEN"





#define PASTADDRESS                  @"Past Address"

#define APP_DB_DATE_FORMATE          @"yyyy-MM-dd HH:mm:ss"

#define FACEBOOK                     @"FACEBOOK"
#define TWITTER                      @"TWITTER"

#define APP_YES                      @"YES"
#define APP_NO                       @"NO"

#define POST_REQ                     @"POST"
#define GET_REQ                      @"GET"

#define REQ_HEADER_DEVICEID          @"deviceID"
#define REQ_HEADER_USERID            @"userid"


#define REGISTRATION_REQ            100
#define SETTINGS_REQ                101
#define FOODTRUCK_LIST_REQ          102
#define FD_DETAILS_BY_TWITTER_REQ   103
#define ADDFOODTRUCK_REQ            104
#define UPDATE_FOODTRUCK_REQ        105
#define CACHE_TWEETS_REQ            106
#define LIVE_TWEETS_REQ             107
#define FT_CONFIRM_REQ              108

#define APP_TOKEN_STATUS_REQ        109
#define IS_MERCHANT_REQ             110
#define APP_FD_BY_TWITTER_REQ       111

#define ADD_USER_TOKEN_REQ          112
#define LOGOUT_TOKEN_REQ            113

#define CHECK_IN_REQ                114
#define CHECK_OUT_REQ               115

#define OPEN_CLOSE_TIME_REQ         116



#define POP_UP_CONFIRM_SHOW_DELAY  3.0
#define POP_UP_CONFIRM_HIDE_DELAY  5.0




#define REQ_REGISTRATION_TAG            @"App registration tag"
#define REQ_SETTINGS_TAG                @"App settings tag"
#define REQ_FOODTRUCK_LIST_TAG          @"food truck list tag"
#define REQ_FD_DETAILS_BY_TWITTER_TAG   @"food truck details by twitter tag"
#define REQ_ADD_FOODTRUCK_TAG           @"add food truck tag"
#define REQ_UPDATE_FOODTRUCK_TAG           @"add food truck tag"
#define REQ_CACHE_TWEETS_FOODTRUCK_TAG     @"cache tweets tag"
#define REQ_LIVE_TWEETS_FOODTRUCK_TAG      @"live tweets tag"
#define REQ_FT_CONFIRM_TAG                 @"ft confirm tag"

#define REQ_APP_TOKEN_STATUS_TAG            @"app token status tag"
#define REQ_IS_MERCHANT_TAG                 @"is merchant tag"
#define REQ_APP_FD_BY_TWITTER_TAG           @"app food truck by twitter tag"

#define REQ_ADD_USER_TOKEN_TAG              @"add user token tag"
#define REQ_LOGOUT_TOKEN_TAG                @"log out token tag"

#define REQ_CHECK_IN_TAG                    @"chekin tag"
#define REQ_CHECK_OUT_TAG                   @"checkout tag"

#define OPEN_CLOSE_TIME_TAG                 @"Open close time tag"

#define GPS_SINGLE_UPDATE                101
#define GPS_CONTINUOUS_UPDATE            102

#define APP_DEFAULT                     -100

#define USER_LOCATION                    200
#define ADD_FOODTRUCK                    201
#define REFRESH_TWEETS                   202
#define FD_TRACK_LOCATION                203
#define GPS_IS_NOT_AVALIBLE              204
#define CHECKIN_USER_LOCATION            450


#define ONE_MILE_IN_METERS               1609.34


#define LAST_PINNED_LOCATION_IS_GPS        205
#define LAST_PINNED_LOCATION_IS_ADDRESS    206


#define ADDRESS_FOR_ADDFOODTRUCK         300
#define ADDRESS_FOR_REFRESH_LOCATION     301
#define ADDRESS_FOR_CHECKIN_LOCATION     302


#define TRUCK_INFO_TAB                   400
#define TWITTER_INFO_TAB                 401
#define FACEBOOK_INFO_TAB                402
#define YELP_INFO_TAB                    403
#define WEB_INFO_TAB                     404

#define FD_CNFM_DIALOG_DISTANCE_IN_METERS 10  

#define LUNCH_ADDICT_SUPPORT_EMAILID            @"support@lunchaddict.com"
#define LUNCH_ADDICT_SUPPORT_SUBJECT            @"Lunch Addict Error"

#define LUNCH_ADDICT_SHARED_EMAILID         @""
#define LUNCH_ADDICT_SHARED_SUBJECT         @""
#define LUNCH_ADDICT_SHARED_MSG_BODY        @""


#define TWITTER_CONSUMER_KEY                    @"edKemDSp8AyzGWVjcuz3YrJw4"
#define TWITTER_CONSUNER_SCRETE_KEY             @"YAAWm90xjO5gwRJ7NpCrrbysaN4nuRcLV5ZVGvRmr4LSZlSgWm"
#define TWITTER_CALLBACK                        @"http://www.lunchaddict.com"


#define FACEBOOK_APPID                    @"1536881266532137"

#define FACEBOOK_HANDLER_TYPE                   600
#define TWITTER_HANDLER_TYPE                    700

#define TWITTER_TOKEN_VALIDATION                  333
#define TWITTER_TOKEN_LOGIN_VALIDATION            444

#define SERVICE_TIME_INTERVAL                     300

#define TOKEN_ACTIVE                     @"ACTIVE"


#define LOGOUT_FROM_FACEBOOK            1000
#define LOGOUT_FROM_TWITTER             1001
#define LOGOUT_FROM_LOGOUTBTN           1002

#define YES_LOGIN_CHECKIN_STATE         1300
#define YES_LOGIN_STATE                 1301


#define ADD_CHECKIN_OUT_DEATLS         1400
#define EDIT_CHECKIN_OUT_DETAILS       1401


#define TIME_PICKER         22
#define DATE_PICKER         33

#define CHECK_IN_DATE_FORMATE   @"MMM dd yyyy"
#define CHECK_IN_TIME_FORMATE   @"hh:mm a"

#define FROM_TIME   250
#define UNTIL_TIME  260

#define APP_TIME_FORMATE   @"hh:mm a"

#define TRUCKS_RECORDS  500
#define HISTORY_RECORDS 501

#define HTTP_PROTOCAL  @"http://"
#define YELIP_PROTOCAL @"http://"

#define OPEN_CLOSE_DATE_FORMATE    @"yyyy-MM-dd HH:mm:ss"


#define FACEBOOK_SHARE_ADDFOODTRUCK             700
#define FACEBOOK_SHARE_CHECKIN                  701
#define TWITTER_SHARE_ADDFOODTRUCK              702
#define TWITTER_SHARE_CHECKIN                   703

#define ERROR_DIALOG                            50

#define SHARE_TWITER_TITLE          @"Share Twitter"
//#define SHARE_FACEBOOK_TITLE        @"Share Facebook"


#define LOGGED_FACEBOOK_HASHTAG_USER        @"#foodtruck #lunch"
#define LOGGED_TWITTER_HASHTAG_USER         @"#foodtruck #lunch"
#define LOGGED_FACEBOOK_HASHTAG_MAR         @"#foodtruck #lunch"
#define LOGGED_TWITTER_HASHTAG_MAR          @"#foodtruck #lunch"

#define AT_RATE_OF_LUNCHADDICT          @"@lunchaddict"

#define GOOGLE_MAP_LINKS                @"https://www.google.com/maps?q=@"

#define GOOGLE_MAPS_LINKS_TWITTER_LENGTH     23

#define EMPTY_STRING  @""

#define HASH_TAG_REGULAR_EXP @"[$&+:;=?@#|<>.^*()%!~{}/]+"

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789#_"


#define ADD_FD_SOCIAL_SHARE_MSG       @"I love my lunch @%@ at %@."


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define TEXT_FIELD_UNTIL_DATE_ADD_FD            500
#define TEXT_FIELD_LATER_DATE_ADD_FD            600









