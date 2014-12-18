//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsSecondVideoRowNode.h"


@interface YTAsSecondVideoRowNode () {
   ASTextNode * _videoTitleNode;
}
@end


@implementation YTAsSecondVideoRowNode {

}

- (void)makeRowNode {
   // 2.2
   _videoTitleNode = [ASTextNode initWithAttributedString:
    [[NSAttributedString alloc] initWithString:[YoutubeParser getVideoSnippetTitle:self.nodeInfo]
                                    attributes:[self textStyleForVideoTitle]]];
   [self addSubnode:_videoTitleNode];
}


- (NSDictionary *)textStyleForVideoTitle {
   NSString * fontName = @"HelveticaNeue";
//   fontName = @"ChalkboardSE-Regular";
//   UIFont * font = [UIFont fontWithName:fontName size:12.0f];
   UIFont * font = [UIFont fontWithName:fontName size:13.0f];

   NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//   style.paragraphSpacing = 1.5 * font.lineHeight;
//   style.paragraphSpacing = 20;
//   style.hyphenationFactor = 1.0;
//   style.lineBreakMode = NSLineBreakByTruncatingTail;


   return @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   return self.cellRect.size;
}


- (void)layout {
   CGFloat titleLeftX = 2.0f;
   _videoTitleNode.frame = CGRectMake(titleLeftX, 8, self.cellRect.size.width - titleLeftX * 2, 36);
}


@end