//
//  UIImageViewAsyncLoad.m
//  H3GSelfcare
//
//  Created by luca on 28/02/14.
//
//

#import "Data_Loader.h"

#import "Globals.h"

@implementation Data_Loader

-(void)dealloc{
    if ([self.actionName isEqualToString:@"WidgetAction 0"]) {
        LOG(@"dealloc Data_Loader for %@", self.actionName);
    }
    if ([self.actionName isEqualToString:@"reachURL_available"]) {
        LOG(@"dealloc Data_Loader for %@", self.actionName);
    }
    self.loadedDictionary = nil;
    //    self.loadedBean = nil;
    self.myResponse = nil;
    self.delegate = nil;
    [self.connection cancel];
    self.responseData = nil;
    self.connection = nil;
    self.downloadError = nil;
    self.currentUrl = nil;
    self.actionName = nil;
    self.aTarget = nil;
    self.object = nil;
    self.parameter = nil;
    self.infoDictionary = nil;
    self.startDate = nil;
    
}

#pragma mark -

-(void)loadAsyncRequest:(NSMutableURLRequest *)request{
    [self.connection cancel];
    self.connection = nil;
    self.responseData = nil;
    
    self.downloadError = nil;

    if (self.sendPerformanceReport) {
        self.startDate = [NSDate date];
    }
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    LOG(@"connection: %@", _connection);
    
    [_connection start];
    
}

- (id)init {
    if((self = [super init])) {
        [self originalSettings];
    }
    return self;
}


-(void)originalSettings{
    self.checkOnlyAvailableURL_then_exit = NO;
    self.myResponse = nil;
    self.timeOut = 20.0;
}

-(void)checkConnectionDuration{
//    if (self.sendPerformanceReport) {
//        NSDate* endDate = [NSDate date];
//        LOG(@"01.startDate: %@", _startDate);
//        LOG(@"02.endDate: %@", endDate);
//        NSTimeInterval delta = [endDate timeIntervalSinceDate:_startDate];
//
//        LOGM(@"file loading: end: for delegate: %@ \n for url:%@", _delegate.class, self.currentUrl);
//        LOGM(@"000.delta (in secondi): %f", delta);
//        self.startDate = nil;
//    }
}

#pragma mark - NSURLConnection delegate

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data{
    LOG(@"+++++ > > > 1.dataLoader: connection:didReceiveData LENGHT: %lu", (unsigned long) data.length);

    [_responseData appendData:data];
}

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse*)response {
    LOG(@"1.dataLoader response.statusCode: %li", (long)response.statusCode);
    if (self.checkOnlyAvailableURL_then_exit){
        self.myResponse = response;
        if ([_delegate respondsToSelector:@selector(dataLoaderGotConnectionResponse:)]) {
            [_delegate dataLoaderGotConnectionResponse:self];
        }
        [self.connection cancel];
        self.connection = nil;
        return;
    }

    if (response.statusCode != 200) {
        //        LOGM(@"UIImageViewAsync response.statusCode self: %@ ", self);
        NSError* error = [[NSError alloc] initWithDomain:_currentUrl code:response.statusCode
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"generic error", NSLocalizedDescriptionKey, nil]] ;

        self.downloadError = error;
        [self.connection cancel];
        self.connection = nil;
        // NON IN CASO DI ERRORE: // [self checkConnectionDuration];
        if ([_delegate respondsToSelector:@selector(dataLoaderDidFailToLoad:)]) {
            [_delegate dataLoaderDidFailToLoad:self];
        }
        return;
    }
    self.myResponse = response;
    self.responseData = [NSMutableData new];
}

- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
    self.downloadError = error;
    LOG(@" +++++++ > > > error code: %ld", (long)error.code);

    if (error.code == -1002 || !_currentUrl) {
        if ([_delegate respondsToSelector:@selector(dataLoaderDidFailToLoad:)]) {
            [_delegate dataLoaderDidFailToLoad:self];
        }
        self.connection = nil;
        return;
    }
    
    
    // NON IN CASO DI ERRORE:
    //     [self checkConnectionDuration];
    if ([_delegate respondsToSelector:@selector(dataLoaderDidFailToLoad:)]) {
        [_delegate dataLoaderDidFailToLoad:self];
    }
    self.connection = nil;
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection{
    self.downloadError = nil;
    self.connection = nil;
    if (! [self.currentUrl containsString: @"pubsub.googleapis.com"]) {
        LOG(@">>>> connectionDidFinishLoading dataLoader : %@", self);
    }
    
    [self checkConnectionDuration];
    if ([_delegate respondsToSelector:@selector(dataLoaderDidFinishToLoad:)]) {
        //        [_delegate dataLoaderDidFinishToLoad:self];
        //            if ([_delegate.class isSubclassOfClass:CampaignLoader.class]) {
        if (! [self.currentUrl containsString: @"pubsub.googleapis.com"]) {
            LOG(@"dataloader _delegate:: %@", _delegate);
        }
        //   NSData *data = self.responseData;
        //        if (data) {
        //            NSDictionary* returnedDictionary = [MosaicoWidgetManager getDictionaryByData:data];
        //            if (returnedDictionary) {
        //                if (returnedDictionary && [returnedDictionary.class isSubclassOfClass:NSDictionary.class]) {
        //                    LOG(@"--** OK ** --> DataLoadr: Got Data: Returned CALL: %@", self.currentUrl);
        //                    LOG(@"--** OK ** --> DataLoadr: with DICTIONARY: %@", returnedDictionary);
        //                    self.loadedDictionary = returnedDictionary;
        //
        //                    //                    W0_MosaicoMatrice* retMosaico = [W0_MosaicoMatrice modelObjectWithDictionary:returnedDictionary];
        //                    CP_Widget * retBean = [CP_Widget modelObjectWithDictionary:returnedDictionary];
        //                    //                    LOG(@"Cell_Widget????? :%@", returnedDictionary);
        //
        //                    if (retBean && [retBean.class isSubclassOfClass:CP_Widget.class]) {
        //                        self.loadedBean = retBean;
        //
        //                        retBean.urlString = self.currentUrl;
        //                        BOOL criticalError = [HTMLActions checkIfCriticalError:nil withCP_Widget:retBean];
        //                        if (criticalError) {
        //                            //[(NSObject*)_delegate performSelector:@selector(dataLoaderDidFailToLoad:) withObject:self afterDelay:0];
        //                            self.delegate = nil;
        //                            [self.connection cancel];
        //                            return;
        //                        }
        //                    }
        //                }
        //            }
        //        }
        [(NSObject*)_delegate performSelector:@selector(dataLoaderDidFinishToLoad:) withObject:self afterDelay:0];
    }
}

#pragma mark -

+(NSDictionary*)getDictionaryByData:(NSData*)data{
    NSError *e = nil;
    id returnedObj = [NSJSONSerialization JSONObjectWithData:data
                                                     options: 0
                                                       error: &e];
    if(e){
        NSLog(@"%s: ERROR:%@",__PRETTY_FUNCTION__,[e description]);
        return nil;
    }
    
    NSDictionary* returnedDictionary = (NSDictionary*)returnedObj;
    if ([returnedDictionary.class isSubclassOfClass:NSDictionary.class]) {
        return returnedDictionary;
    }
    return nil;
}



/*
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    LOG(@"willSendRequestForAuthenticationChallenge: %@", @"");
    [[EnvManager getSharedInstance] handle_certificate_for_connection:connection willSendRequestForAuthenticationChallenge:challenge];
}


- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection{
    LOG(@"xxxx Text: %@", self);
    BOOL should = [[EnvManager getSharedInstance] handle_connectionShouldUseCredentialStorage:(NSURLConnection *)connection];
    return should;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    BOOL should = [[EnvManager getSharedInstance] handle_connection:connection canAuthenticateAgainstProtectionSpace:protectionSpace];
    return should;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    [[EnvManager getSharedInstance] handle_certificate_for_connection:connection willSendRequestForAuthenticationChallenge:challenge];
    LOG(@"Text: %@", @"");
}
*/
 
@end



