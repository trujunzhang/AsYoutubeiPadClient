

#import <Foundation/Foundation.h>

@interface ABReport : NSObject

@property (assign) int reportID;
@property (assign) int locationID;
@property (strong) NSMutableArray* locations;
@property (copy) NSString* status;

@end
