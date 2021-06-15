//#import "Colours.h"
//#import "Utility.h"
//#import "EnvManager.h"
//#import "CountlyManager.h"

// TEST 0 commit PRIMO test cherry-pick
// TEST 1 commit PRIMO b test cherry-pick
// TEST
// TEST 2 commit SECONDO test cherry-pick
//#if TARGET_IPHONE_SIMULATOR
//    #define DEBUG // undefine to suppress debug logs
//#endif

// test branch
// added in "newretrieveEricsson" after copy
// added in TimeToMarket + 2

// added in Contact us (bis)

// test svn from new macBook meronix

#if DEBUG_LOG
#define LOG NSLog
#else
#define LOG(...)
#endif

#if DEBUG_LOG_BIG_DATA
#define LOG_REPORT NSLog
#else
#define LOG_REPORT(...)
#endif

#if DEBUG_MERO
    #define LOGM NSLog
#else
    #define LOGM(...)
#endif

#define kBannerAdUnitID @"ca-app-pub-5952984043381908/6910357584"
