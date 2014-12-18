//
//  TarBarItemNode.m
//  Example
//
//  Created by djzhang on 12/6/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import "TarBarItemNode.h"


@interface TarBarItemNode () {
   ASTextNode * _textNode;
   ASImageNode * _backgroundNode;
}
@end


static const float fontSize = 12.0f;


@implementation TarBarItemNode

- (id)initWithCellSize:(CGSize)cellSize withTitle:(id)title isSelected:(BOOL)isSelected {
   self = [super init];
   if (self) {
      self.cellSize = cellSize;

      _backgroundNode = [[ASImageNode alloc] init];
      _backgroundNode.contentMode = UIViewContentModeScaleAspectFill;
      [self addSubnode:_backgroundNode];

      _textNode = [[ASTextNode alloc] init];

      NSDictionary * attrs = @{
       NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:fontSize],
       NSForegroundColorAttributeName : [UIColor blackColor],
       NSParagraphStyleAttributeName : [self justifiedParagraphStyleForLeftMenuSubscriptionTitle]
      };
      NSAttributedString * string = [[NSAttributedString alloc] initWithString:title
                                                                    attributes:attrs];
      _textNode.attributedString = string;

      [self addSubnode:_textNode];

      [self layoutByCellSize:self.cellSize];
   }

   return self;
}


- (NSParagraphStyle *)justifiedParagraphStyleForLeftMenuSubscriptionTitle {
   NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
   style.alignment = NSTextAlignmentCenter;

   return style;
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   return self.cellSize;
}


- (void)layout {
   CGSize cgSize = self.cellSize;
   [self layoutByCellSize:cgSize];
}


- (void)layoutByCellSize:(CGSize)cgSize {
   CGFloat dY = (cgSize.height - fontSize) / 2;
   _textNode.frame = CGRectMake(0, dY, cgSize.width, fontSize + 4);

   _backgroundNode.frame = CGRectMake(0, 0, cgSize.width, cgSize.height);
}


- (void)setNodeSelected {
   CGRect rect = _backgroundNode.frame;
   _backgroundNode.image = [UIImage imageNamed:@"tab_titles_button_selected"];
}


- (void)resetNodeSelected {

}
@end
