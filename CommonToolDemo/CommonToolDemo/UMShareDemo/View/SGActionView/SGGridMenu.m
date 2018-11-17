//
//  SGGridMenu.m
//  SGActionView
//
//  Created by Sagi on 13-9-6.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import "SGGridMenu.h"
#import <QuartzCore/QuartzCore.h>

#define kMAX_CONTENT_SCROLLVIEW_HEIGHT   400

@interface SGGridItem : UIButton
@property (nonatomic, weak) SGGridMenu *menu;
@end

@implementation SGGridItem

- (id)initWithTitle:(NSString *)title image:(UIImage *)image
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.clipsToBounds = NO;
        
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1] forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    CGRect imageRect = CGRectMake(width * 0.2, width * 0.1, width * 0.6, width * 0.6);
    self.imageView.frame = imageRect;
    
    float labelHeight = height - (imageRect.origin.y + imageRect.size.height);
    CGRect labelRect = CGRectMake(width * 0.05, imageRect.origin.y + imageRect.size.height+5, width * 0.9, labelHeight);
    self.titleLabel.frame = labelRect;
}

@end


@interface SGGridMenu ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) SGButton *cancelButton;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *itemImages;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) void (^actionHandle)(NSInteger);
@end

@implementation SGGridMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseMenuBackgroundColor(self.style);

        _itemTitles = [NSArray array];
        _itemImages = [NSArray array];
        _items = [NSArray array];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1];
        [self addSubview:_titleLabel];
        
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _contentScrollView.contentSize = _contentScrollView.bounds.size;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = YES;
        _contentScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentScrollView];
        
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0,[UIScreen mainScreen].bounds.size.width-20, 1)];
        topLine.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
        [_contentScrollView addSubview:topLine];
        
        
        
        _cancelButton = [SGButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.clipsToBounds = YES;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(tapAction:)
                forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles images:(NSArray *)images
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        NSInteger count = MIN(itemTitles.count, images.count);
        _titleLabel.text = title;
        _itemTitles = [itemTitles subarrayWithRange:NSMakeRange(0, count)];
        _itemImages = [images subarrayWithRange:NSMakeRange(0, count)];
        [self setupWithItemTitles:_itemTitles images:_itemImages];
    }
    return self;
}

- (void)setupWithItemTitles:(NSArray *)titles images:(NSArray *)images
{
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<titles.count; i++) {
        SGGridItem *item = [[SGGridItem alloc] initWithTitle:titles[i] image:images[i]];
        item.menu = self;
        item.tag = i;
        [item addTarget:self
                 action:@selector(tapAction:)
       forControlEvents:UIControlEventTouchUpInside];
        [items addObject:item];
        [_contentScrollView addSubview:item];
    }
    _items = [NSArray arrayWithArray:items];
}

- (void)setStyle:(SGActionViewStyle)style{
    _style = style;
    
    self.backgroundColor = BaseMenuBackgroundColor(style);
    self.titleLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    for (SGGridItem *item in self.items) {
        [item setTitleColor:BaseMenuTextColor(style) forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, 50)};
    
    [self layoutContentScrollView];
    self.contentScrollView.frame = (CGRect){CGPointMake(0, self.titleLabel.frame.size.height), self.contentScrollView.bounds.size};
    
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, _contentScrollView.frame.size.height-1, [UIScreen mainScreen].bounds.size.width-20, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [_contentScrollView addSubview:bottomLine];
    
    
    self.cancelButton.frame = CGRectMake(0, self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height, self.bounds.size.width, 55);
    
    CGFloat tar = [[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0;
    
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height + self.cancelButton.bounds.size.height+tar)};
//    -[[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0
}

- (void)layoutContentScrollView
{
    UIEdgeInsets margin = UIEdgeInsetsMake(0, 10, 15, 10);
    CGSize itemSize = CGSizeMake((self.bounds.size.width - margin.left - margin.right) / 4, 85);
    
    NSInteger itemCount = self.items.count;
    NSInteger rowCount = ((itemCount-1) / 4) + 1;
    self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width, rowCount * itemSize.height + margin.top + margin.bottom);
    for (int i=0; i<itemCount; i++) {
        SGGridItem *item = self.items[i];
        int row = i / 4;
        int column = i % 4;
        CGPoint p = CGPointMake(margin.left + column * itemSize.width, margin.top + row * itemSize.height);
        item.frame = (CGRect){p, itemSize};
        [item layoutIfNeeded];
    }
    
    if (self.contentScrollView.contentSize.height > kMAX_CONTENT_SCROLLVIEW_HEIGHT) {
        self.contentScrollView.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, kMAX_CONTENT_SCROLLVIEW_HEIGHT)};
    }else{
        self.contentScrollView.bounds = (CGRect){CGPointZero, self.contentScrollView.contentSize};
    }
}

#pragma mark - 

- (void)triggerSelectedAction:(void (^)(NSInteger))actionHandle
{
    self.actionHandle = actionHandle;
}

#pragma mark -

- (void)tapAction:(id)sender
{
    if (self.actionHandle) {
        if ([sender isEqual:self.cancelButton]) {
            double delayInSeconds = 0.15;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.actionHandle(0);
            });
        }else{
            double delayInSeconds = 0.15;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.actionHandle([sender tag] + 1);
            });
        }
    }
}

@end
