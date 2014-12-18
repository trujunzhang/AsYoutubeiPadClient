//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsThirdVideoRowNode.h"
#import "UIColor+iOS8Colors.h"


@interface YTAsThirdVideoRowNode () {
   ASTextNode * _channelTitleNode;
   ASDisplayNode * _divider;
}
@end


@implementation YTAsThirdVideoRowNode {

}


- (void)makeRowNode {
   _channelTitleNode = [ASTextNode initWithAttributedString:
    [[NSAttributedString alloc] initWithString:[YoutubeParser getVideoSnippetChannelTitle:self.nodeInfo]
                                    attributes:[self textStyleForChannelTitle]]];
   [self addSubnode:_channelTitleNode];

   // hairline cell separator
   _divider = [[ASDisplayNode alloc] init];

   _divider.backgroundColor =
    [UIColor iOS8lightGrayColor];
//    [UIColor lightGrayColor];
   [self addSubnode:_divider];
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


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   return self.cellRect.size;
}


- (void)layout {
   CGFloat titleLeftX = 2.0f;
   CGFloat titleWidth = 180.0f;
   _channelTitleNode.frame = CGRectMake(titleLeftX, self.cellRect.size.height-18, titleWidth, 20);

   CGFloat pixelHeight = 1.0f / [[UIScreen mainScreen] scale];
   _divider.frame =
    CGRectMake(0.0f, self.cellRect.size.height - pixelHeight, self.cellRect.size.width, pixelHeight);
}


@end