//
//  PAColorPaletteView.h
//  PAColorPicker
//
//  Created by David Shakhbazyan on 11/10/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAColorPaletteView;

@protocol PAColorPaletteDelegate <UIScrollViewDelegate>

- (void)colorPalette:(PAColorPaletteView *)palette didSelectColor:(UIColor *)color;
- (void)colorPalette:(PAColorPaletteView *)palette didAddColor:(UIColor *)color;

@end

@interface PAColorPaletteView : UIScrollView

@property (strong, nonatomic) UIColor *choosedColor;

@property (readonly, nonatomic) CGFloat cellSize;
@property (readonly, nonatomic) NSMutableArray *colors;

@property (weak, nonatomic) id <PAColorPaletteDelegate> delegate;

@end
