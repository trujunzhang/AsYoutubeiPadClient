//
//  YTGridMoreCellNode.m
//  IOSTemplate
//
//  Created by djzhang on 11/17/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTGridMoreCellNode.h"


@interface YTGridMoreCellNode () {
   CGSize _kittenSize;

}
@end


@implementation YTGridMoreCellNode


- (instancetype)initWithCellNodeOfSize:(CGSize)size { //242,242
   if (!(self = [super init]))
      return nil;

   _kittenSize = size;

   [self setupUI];

   return self;
}


- (void)setupUI {


}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   return _kittenSize;
}


- (NSDictionary *)textStyleForVideoTitle {
   NSString * fontName = @"HelveticaNeue";
//   fontName = @"ChalkboardSE-Regular";
   UIFont * font = [UIFont fontWithName:fontName size:12.0f];

   NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
   style.paragraphSpacing = 0.5 * font.lineHeight;
   style.hyphenationFactor = 1.0;
//   style.lineBreakMode = NSLineBreakByTruncatingTail;


   return @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
}


- (NSDictionary *)textStyleForChannelTitle {
   UIFont * font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];

   NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
   style.paragraphSpacing = 0.5 * font.lineHeight;
   style.hyphenationFactor = 1.0;
   style.lineBreakMode = NSLineBreakByTruncatingTail;

   return @{
    NSFontAttributeName : font,
    NSParagraphStyleAttributeName : style,
    NSForegroundColorAttributeName : [UIColor lightGrayColor]
   };
}


- (void)layout {

//   UIActivityIndicatorView *

}


@end
