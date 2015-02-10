#import <Foundation/Foundation.h>
#import "ABReport.h"

typedef void(^ReportResultsBlock)(NSArray* reports);
typedef void(^LocationResultsBlock)(NSArray* locations);


@interface MobileDB : NSObject


#pragma mark - Base
+ (MobileDB*) dbInstance;

- (id) initWithFile: (NSString*) filePathName;
- (void) close;


#pragma mark - Reports
-(void) saveReport:(ABReport*) report;
-(void) allReports:(ReportResultsBlock) reportsBlock;
-(void) allReportsWithLocations:(ReportResultsBlock) reportsBlock;

#pragma mark - Preferences
- (NSString*) preferenceForKey: (NSString*) key;
- (void) setPreference: (NSString*) value  forKey: (NSString*) key;

#pragma mark - Utilities
-(NSString *)uniqueID;

@end


