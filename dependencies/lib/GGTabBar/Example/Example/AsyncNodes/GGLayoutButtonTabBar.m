//
//  VITabBar.m
//  Vinoli
//
//  Created by Nicolas Goles on 6/6/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import "GGLayoutButtonTabBar.h"
#import "GGTabBarAppearanceKeys.h"


@interface GGLayoutButtonTabBar () {
    UIView *_selectedButton;
}
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *separators; // Between-buttons separators
@property (nonatomic, strong) NSMutableArray *marginSeparators; // Start/End Separators

// Appearance
@property (nonatomic, assign) CGFloat tabBarHeight;
@property (nonatomic, strong) UIColor *tabBarBackgroundColor;
@property (nonatomic, strong) UIColor *tabBarTintColor;

// References to Constraints
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@end


@implementation GGLayoutButtonTabBar

#pragma mark - Public API


- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers appearance:(NSDictionary *)appearance inTop:(BOOL)inTop selectedIndex:(NSInteger)selectedIndex {
    self = [super initWithFrame:frame];
    if(self) {
        self.inTop = inTop;
        _buttons = [[NSMutableArray alloc] init];
        _separators = [[NSMutableArray alloc] init];
        _marginSeparators = [[NSMutableArray alloc] init];
        _viewControllers = viewControllers;
        self.tabBarHeight = 50;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self initSubViewsWithControllers:_viewControllers];

        if(appearance) {
            [self setAppearance:appearance];
        }

        [self addHeightConstraints];
    }
    return self;
}


- (void)setSelectedButton:(UIView *)selectedButton {
    NSUInteger oldButtonIndex = [_buttons indexOfObject:_selectedButton];
    NSUInteger newButtonIndex = [_buttons indexOfObject:selectedButton];

    if(oldButtonIndex != NSNotFound) {
//      UIButton * button = [_selectedButton subviews][0];
//      button.titleLabel.textColor = [UIColor blueColor];
    }

    if(newButtonIndex != NSNotFound) {
//      UIButton * button = [selectedButton subviews][0];
//      button.titleLabel.textColor = [UIColor redColor];
    }

    _selectedButton = selectedButton;

//   [self paintDebugViews];
}


//- (void)setSelectedButton:(UIView *)selectedButton {
//   NSUInteger oldButtonIndex = [_buttons indexOfObject:_selectedButton];
//   NSUInteger newButtonIndex = [_buttons indexOfObject:selectedButton];
//
//   if (oldButtonIndex != NSNotFound) {
//      UIButton * button = [_selectedButton subviews][0];
//      button.titleLabel.textColor = [UIColor blueColor];
//   }
//
//   if (newButtonIndex != NSNotFound) {
//      UIButton * button = [selectedButton subviews][0];
//      button.titleLabel.textColor = [UIColor redColor];
//   }
//
//   _selectedButton = selectedButton;
//
////   [self paintDebugViews];
//}


- (void)setAppearance:(NSDictionary *)appearance {
    if(appearance[kTabBarAppearanceBackgroundColor]) {
        self.backgroundColor = self.tabBarBackgroundColor = appearance[kTabBarAppearanceBackgroundColor];
    }

    if(appearance[kTabBarAppearanceHeight]) {
        self.tabBarHeight = [appearance[kTabBarAppearanceHeight] floatValue];
    }

    if(appearance[kTabBarAppearanceTint]) {
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
    UITapGestureRecognizer *tapGestureRecognizer = sender;
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

    NSArray *colorArray = @[
            [UIColor redColor],
            [UIColor greenColor],
            [UIColor blueColor],
    ];

    for (UIViewController *viewController in viewControllers) {

        UIView *barView = [[UIView alloc] init];
        barView.backgroundColor = colorArray[tagCounter];

        UIView *button = [self getButtonView:tagCounter viewController:viewController];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [barView addSubview:button];


        [self addSubview:barView];
        [_buttons addObject:barView];

        tagCounter++;
    }

    // Add Separators
    NSInteger limit = [self.subviews count] - 1;

    for (int i = 0;i < limit;++i) {
//      UIView * separator = [[UIView alloc] init];
        UIView *separator = nil;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_separator"]];
        separator = imageView;

        separator.translatesAutoresizingMaskIntoConstraints = NO;
        separator.tag = i + kSeparatorOffsetTag;

        [self addSubview:separator];
        [_separators addObject:separator];
    }

    // Add Margin Separators (we always have two margins)
    for (int i = 0;i < 2;++i) {
        UIView *marginSeparator = [[UIView alloc] init];

        marginSeparator.translatesAutoresizingMaskIntoConstraints = NO;
        marginSeparator.tag = i + kMarginSeparatorOffsetTag;

        [self addSubview:marginSeparator];
        [_marginSeparators addObject:marginSeparator];
    }
}


- (UIView *)getButtonView:(NSUInteger)tagCounter viewController:(UIViewController *)viewController {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *title = viewController.title;

//   titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.tag = tagCounter;

    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    titleLabel.textAlignment = NSTextAlignmentJustified;

    [titleLabel sizeToFit];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tabButtonPressed:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.view.tag = tagCounter;
    [titleLabel addGestureRecognizer:tapGestureRecognizer];
    titleLabel.userInteractionEnabled = YES;


    return titleLabel;
}


- (UIView *)getButtonView123:(NSUInteger)tagCounter viewController:(UIViewController *)viewController {
    UIButton *uiButton = [UIButton buttonWithType:UIButtonTypeCustom];
//   [uiButton setBackgroundColor:[UIColor blueColor]];

    NSString *title = viewController.title;

    uiButton.tag = tagCounter;

    uiButton.titleLabel.text = title;
    uiButton.titleLabel.textColor = [UIColor redColor];
    uiButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
//   uiButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    [uiButton sizeToFit];


    return uiButton;
}


#pragma mark - Layout -


- (void)layoutSubviews {
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
    for (int i = 0;i < buttonCount;i++) {
        UIView *uiView = _buttons[i];
        uiView.frame = CGRectMake(startX, 0, tabBarItemWidth, tabBarHeight);
        UILabel *button = [uiView subviews][0];
//      button.frame = CGRectMake(startX, 0, tabBarItemWidth, tabBarHeight);
        [button sizeToFit];
        startX = startX + tabBarItemWidth;

        if(i != buttonCount - 1) {// last item
            UIView *seperatorView = _separators[i];
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

    if(_heightConstraint) {
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
    NSMutableArray *constraints = [[NSMutableArray alloc] init];

    for (UIView *separator in separators) {
        NSLayoutConstraint *constraint;
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

    for (UIView *button in _buttons) {
        button.backgroundColor = [UIColor whiteColor];
    }

    for (UIView *separator in _separators) {
        separator.backgroundColor = [UIColor redColor];
    }

    for (UIView *marginSeparator in _marginSeparators) {
        marginSeparator.backgroundColor = [UIColor greenColor];
    }
}

@end
