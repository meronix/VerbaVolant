//
//  UIImageViewAsyncLoad.h
//  H3GSelfcare
//
//  Created by luca on 28/02/14.
//
//

#import <UIKit/UIKit.h>

@class Data_Loader;

@protocol DataLoaderProtocol <NSObject>

@optional

-(void)dataLoaderDidFinishToLoad:(Data_Loader*)aDataLoader;

-(void)dataLoaderDidFailToLoad:(Data_Loader*)aDataLoader;
-(void)dataLoaderDidFailToLoad:(Data_Loader*)aDataLoader withInfo:(NSMutableDictionary*)userInfo;

-(void)dataLoaderGotConnectionResponse:(Data_Loader*)aDataLoader;

@end


@interface Data_Loader : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, assign) id <DataLoaderProtocol> delegate;

//@property (nonatomic, retain) NSMutableDictionary* userInfo;
@property (nonatomic, retain) NSMutableData * responseData;
@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic, retain) NSError* downloadError;
@property (nonatomic, retain) NSString* currentUrl;

@property (nonatomic, assign) NSTimeInterval timeOut;



@property (nonatomic, retain) NSString* actionName;
//@property (nonatomic, retain) NSData *data;
//@property (nonatomic, retain) NSError *error;
//@property (nonatomic, retain) NSString* url;
@property (nonatomic, assign) BOOL returnData;
@property (nonatomic, retain) id aTarget;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) id parameter;
@property (nonatomic, assign) SEL sel;
@property (nonatomic, retain) NSMutableDictionary* infoDictionary;

@property (nonatomic, retain) NSDate* startDate;
@property (nonatomic) BOOL sendPerformanceReport;

@property (nonatomic) BOOL checkOnlyAvailableURL_then_exit;
@property (nonatomic, retain) NSHTTPURLResponse* myResponse;


// @property (nonatomic, retain) CP_Widget * loadedBean;
@property (nonatomic, retain) NSDictionary* loadedDictionary;

@property (nonatomic) BOOL avoidPopUp_withError;

-(void)loadAsyncRequest:(NSMutableURLRequest *)request;
-(void)originalSettings;

+(NSDictionary*)getDictionaryByData:(NSData*)data;

@end

