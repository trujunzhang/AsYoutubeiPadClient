//
//  VITabBar.m
//  Vinoli
//
//  Created by Nicolas Goles on 6/6/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import "GGLayoutCollectionViewTabBar.h"
#import "GGTabBarAppearanceKeys.h"
#import "TabBarCollectionView.h"


@interface GGLayoutCollectionViewTabBar () {
   UILabel * _selectedButton;
}
@property(nonatomic, strong) NSArray * viewControllers;
@property(nonatomic, strong) NSMutableArray * buttons;
@property(nonatomic, strong) NSMutableArray * separators; // Between-buttons separators
@property(nonatomic, strong) NSMutableArray * marginSeparators; // Start/End Separators

// Appearance
@property(nonatomic, assign) CGFloat tabBarHeight;
@property(nonatomic, strong) UIColor * tabBarBackgroundColor;
@property(nonatomic, strong) UIColor * tabBarTintColor;

// References to Constraints
@property(nonatomic, weak) NSLayoutConstraint * heightConstraint;
@end


@implementation GGLayoutCollectionViewTabBar

#pragma mark - Public API


- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers appearance:(NSDictionary *)appearance inTop:(BOOL)inTop selectedIndex:(NSInteger)selectedIndex {
   self = [super initWithFrame:frame];
   if (self) {
      self.inTop = inTop;
      _buttons = [[NSMutableArray alloc] init];
      _separators = [[NSMutableArray alloc] init];
      _marginSeparators = [[NSMutableArray alloc] init];
      _viewControllers = viewControllers;
      self.tabBarHeight = 51;
      self.translatesAutoresizingMaskIntoConstraints = NO;
//      [self initSubViewsWithControllers:_viewControllers];

      NSMutableArray * array = [self getCollectionData];
      self.collectionView = [[TabBarCollectionView alloc] initWithTitleArray:array withViewHeight:self.tabBarHeight];

      [self addSubview:self.collectionView.view];

      [self addHeightConstraints];
   }
   return self;
}


- (NSMutableArray *)getCollectionData {
   NSMutableArray * dataArray = [[NSMutableArray alloc] init];
   for (UIViewController * viewController in _viewControllers) {
      NSString * title = viewController.title;
      [dataArray addObject:title];
   }

   return dataArray;
}


- (void)setSelectedButton:(UILabel *)selectedButton {
   NSUInteger oldButtonIndex = [_buttons indexOfObject:_selectedButton];
   NSUInteger newButtonIndex = [_buttons indexOfObject:selectedButton];

   if (oldButtonIndex != NSNotFound) {
      _selectedButton.backgroundColor = [UIColor whiteColor];
      [_selectedButton setTextColor:[UIColor blueColor]];
   }

   if (newButtonIndex != NSNotFound) {

      UIImage * img = [UIImage imageNamed:@"tab_titles_button_selected.png"];

      CGFloat tabBarItemWidth = [self getTabBarItemWidth:_buttons.count];

      CGSize cgSize = CGSizeMake(tabBarItemWidth, self.tabBarHeight);
      CGSize imgSize = cgSize;

      UIGraphicsBeginImageContext(imgSize);
      [img drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
      UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();

      selectedButton.backgroundColor = [UIColor colorWithPatternImage:newImage];

//      selectedButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_titles_button_selected"]];
//      selectedButton.backgroundColor = [UIColor blueColor];
      [selectedButton setTextColor:[UIColor redColor]];
   }

   _selectedButton = selectedButton;

   [self paintDebugViews];
}


- (void)setAppearance:(NSDictionary *)appearance {
   if (appearance[kTabBarAppearanceBackgroundColor]) {
      self.backgroundColor = self.tabBarBackgroundColor = appearance[kTabBarAppearanceBackgroundColor];
   }

   if (appearance[kTabBarAppearanceHeight]) {
      self.tabBarHeight = [appearance[kTabBarAppearanceHeight] floatValue];
   }

   if (appearance[kTabBarAppearanceTint]) {
      // Do something with the tint here.
   }
}


- (void)startDebugMode {
   [self paintDebugViews];
   [self addDebugConstraints];
   [self updateConstraints];
}


#pragma mark - UIView


- (void)didMoveToSuperview {
   // When the app is first launched set the selected button to be the first button
   [self setSelectedButton:[_buttons firstObject]];
}


#pragma mark - Delegate


- (void)tabButtonPressed:(id)sender {
   UITapGestureRecognizer * tapGestureRecognizer = sender;
   NSInteger buttonIndex = tapGestureRecognizer.view.tag;
   NSLog(@"buttonIndex = %i", buttonIndex);

//   NSUInteger buttonIndex = [_buttons indexOfObject:object];
   [self.delegate tabBar:self didPressButton:_buttons[buttonIndex] atIndex:buttonIndex];
}


#pragma mark - Subviews


/** takes an array of ViewControllers to internally instanciate
* it's Subview structure. (buttons, separators & margins).
* note: will not lay it out right away.
*/
- (void)initSubViewsWithControllers:(NSArray *)viewControllers {
   // Add Buttons
   NSUInteger tagCounter = 0;

   for (UIViewController * viewController in viewControllers) {

      UIView * barView;
      UIView * button = [self getButtonView:tagCounter viewController:viewController];
      barView = button;

      [self addSubview:barView];
      [_buttons addObject:barView];

      tagCounter++;
   }

   // Add Separators
   NSInteger limit = [self.subviews count] - 1;

   for (int i = 0; i < limit; ++i) {
//      UIView * separator = [[UIView alloc] init];
      UIView * separator = nil;
      UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_separator"]];
      separator = imageView;

      separator.translatesAutoresizingMaskIntoConstraints = NO;
      separator.tag = i + kSeparatorOffsetTag;

      [self addSubview:separator];
      [_separators addObject:separator];
   }

   // Add Margin Separators (we always have two margins)
   for (int i = 0; i < 2; ++i) {
      UIView * marginSeparator = [[UIView alloc] init];

      marginSeparator.translatesAutoresizingMaskIntoConstraints = NO;
      marginSeparator.tag = i + kMarginSeparatorOffsetTag;

      [self addSubview:marginSeparator];
      [_marginSeparators addObject:marginSeparator];
   }
}


- (UIView *)getButtonView:(NSUInteger)tagCounter viewController:(UIViewController *)viewController {
   UILabel * titleLabel = [[UILabel alloc] init];
   NSString * title = viewController.title;

   titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
   titleLabel.tag = tagCounter;

   titleLabel.text = title;
   titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
   titleLabel.textAlignment = NSTextAlignmentCenter;

   [titleLabel sizeToFit];

   UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tabButtonPressed:)];
   tapGestureRecognizer.numberOfTapsRequired = 1;
   tapGestureRecognizer.view.tag = tagCounter;
   [titleLabel addGestureRecognizer:tapGestureRecognizer];
   titleLabel.userInteractionEnabled = YES;


   return titleLabel;
}


#pragma mark - Layout -


- (void)layoutSubviews {
   [super layoutSubviews];

   CGRect rect = self.bounds;
   self.collectionView.view.frame = rect;
}


- (void)layoutSubviews123 {
   [super layoutSubviews];

   CGRect rect = self.bounds;

   NSUInteger integer = _separators.count;
   NSUInteger count = _buttons.count;
   [self layoutTabBarItems];
}


- (void)layoutTabBarItems {
   CGFloat tabBarHeight = self.frame.size.height;
   NSUInteger buttonCount = _buttons.count;

   CGFloat tabBarItemWidth = [self getTabBarItemWidth:buttonCount];

   CGFloat startX = tabBarPadding;
   for (int i = 0; i < buttonCount; i++) {
      UILabel * label = _buttons[i];
      label.frame = CGRectMake(startX, 0, tabBarItemWidth, tabBarHeight);
      startX = startX + tabBarItemWidth;

      if (i != buttonCount - 1) {// last item
         UIView * seperatorView = _separators[i];
         seperatorView.frame = CGRectMake(startX, 0, seperatorWidth, tabBarHeight);
         startX = startX + seperatorWidth;
      }
   }
}


- (CGFloat)getTabBarItemWidth:(NSUInteger)buttonCount {
   CGFloat totalWidth = (self.frame.size.width - tabBarPadding * 2);
   CGFloat allSeperatorWidth = seperatorWidth * _separators.count;

   CGFloat tabBarItemWidth = (totalWidth - allSeperatorWidth) / buttonCount;
   return tabBarItemWidth;
}


#pragma mark - Constraints -


- (void)removeSubViews {
   while ([self.subviews count] > 0)
      [[self.subviews lastObject] removeFromSuperview];
}


- (void)reloadTabBarButtons {
   [self removeConstraints:[self constraints]];
   [self removeSubViews];
   [self initSubViewsWithControllers:_viewControllers];
}


#pragma mark Add


- (void)addHeightConstraints {
   // Adjust the constraint multiplier and item depending if there's a custom tabBarHeight
   CGFloat multiplier = self.tabBarHeight == CGFLOAT_MIN ? 1.5 : 0.0;

   id item = self.tabBarHeight == CGFLOAT_MIN ? [_buttons firstObject] : nil;
   CGFloat layoutConstant = item ? 0.0 : self.tabBarHeight;

   if (_heightConstraint) {
      [self removeConstraint:_heightConstraint];
      _heightConstraint = nil;
   }

   _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                    attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:item
                                                    attribute:NSLayoutAttributeHeight
                                                   multiplier:multiplier
                                                     constant:layoutConstant];

   [self addConstraint:_heightConstraint];
}


- (void)addDebugConstraints {
   [self addConstraints:[self heightConstraintsWithSeparators:_separators]];
   [self addConstraints:[self heightConstraintsWithSeparators:_marginSeparators]];
}


#pragma Creation


- (NSArray *)heightConstraintsWithSeparators:(NSArray *)separators {
   NSMutableArray * constraints = [[NSMutableArray alloc] init];

   for (UIView * separator in separators) {
      NSLayoutConstraint * constraint;
      constraint = [NSLayoutConstraint constraintWithItem:separator
                                                attribute:NSLayoutAttributeHeight
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:nil
                                                attribute:NSLayoutAttributeNotAnAttribute
                                               multiplier:1.0
                                                 constant:10.0];
      [constraints addObject:constraint];
   }

   return constraints;
}


#pragma mark - Debug


- (void)paintDebugViews {
   self.backgroundColor = [UIColor blueColor];

   for (UIView * button in _buttons) {
      button.backgroundColor = [UIColor whiteColor];
   }

   for (UIView * separator in _separators) {
      separator.backgroundColor = [UIColor redColor];
   }

   for (UIView * marginSeparator in _marginSeparators) {
      marginSeparator.backgroundColor = [UIColor greenColor];
   }
}

@end
