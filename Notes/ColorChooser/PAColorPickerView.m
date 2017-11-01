//
//  PAColorPickerView.m
//  PAColorPicker
//
//  Created by David Shakhbazyan on 11/5/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import "PAColorPickerView.h"
#import "PACircleColorPicker.h"
#import "PAColorPaletteView.h"
#import "PASliderColorView.h"

#import "SCColorPicker.h"

typedef NS_ENUM(NSUInteger, PAColorModel) {
    PAColorModelHSB,
    PAColorModelRGB,
};

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SCDeviceSystemVersion() compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface PAColorPickerView () <PACircleColorPickerDelegate, PAColorPaletteDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *paletteButton;
@property (weak, nonatomic) IBOutlet UIButton *pipetteButton;

@property (weak, nonatomic) IBOutlet UIView *colorRectsContainer;
@property (weak, nonatomic) IBOutlet UIView *currentColorRect;
@property (weak, nonatomic) IBOutlet UIView *previousColorRect;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorModelsSegmentedControl;

//Sliders
@property (weak, nonatomic) IBOutlet UIView *sliderContentView;

//Red Slider
@property (weak, nonatomic) IBOutlet UILabel *redTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *redValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet PASliderColorView *redSliderColorView;

//Green Slider
@property (weak, nonatomic) IBOutlet UILabel *greenTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet PASliderColorView *greenSliderColorView;

//Blue Slider
@property (weak, nonatomic) IBOutlet UILabel *blueTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet PASliderColorView *blueSliderColorView;

@property (weak, nonatomic) IBOutlet PACircleColorPicker *colorPicker;
@property (weak, nonatomic) IBOutlet PAColorPaletteView *paletteView;

@property (assign, nonatomic) PAColorModel currentColorModel;

@property (strong, nonatomic) UIColor *previousColor;

@end

@implementation PAColorPickerView

- (instancetype)initFromNib {
    NSString *nibName = NSStringFromClass([PAColorPickerView class]);
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    
    if ((nib != nil) && (nib.count > 0)) {
        self = [nib firstObject];
        [self _init];
        return self;
    }
    return nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init {
    _colorPicker.delegate = self;
    _paletteView.delegate = self;
    
    self.paletteButton.selected = YES;
    self.pipetteButton.hidden = !self.pipetteEnabled;
    
    self.currentColorModel = PAColorModelHSB;
    self.previousColor = [UIColor blackColor];// colorWithHue:160 / 360.0f saturation:60 / 100.0f brightness:70.0f / 100.0f alpha:1.0];
    [self setActiveColor:_previousColor];
    
    [self setupAppearance];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self.paletteButton isSelected]) {
        [self showPaletteView];
    }
}

- (void)setupAppearance {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    
    _colorRectsContainer.layer.borderWidth = 1.0;
    _colorRectsContainer.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0].CGColor;
    
    _colorPicker.layer.shadowOpacity = 0.5f;
    _colorPicker.layer.shadowOffset = CGSizeMake(3, 3);
    
    //Customizing segmented control
    NSDictionary *attributes = @ { NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                   NSFontAttributeName: [UIFont boldSystemFontOfSize:14] };
    
    [_colorModelsSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [_colorModelsSegmentedControl setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    _colorModelsSegmentedControl.tintColor = [UIColor clearColor];
    
    //Customizing sliders
    UIImage *clearImage = [UIImage new];
    [_redSlider setThumbImage:nil forState:UIControlStateNormal];
    [_redSlider setMinimumTrackImage:clearImage forState:UIControlStateNormal];
    
    [_greenSlider setThumbImage:nil forState:UIControlStateNormal];
    [_greenSlider setMinimumTrackImage:clearImage forState:UIControlStateNormal];
    
    [_blueSlider setThumbImage:nil forState:UIControlStateNormal];
    [_blueSlider setMinimumTrackImage:clearImage forState:UIControlStateNormal];
    
    //Setting slider's track tint colors in iOS8
    //to hide horizontal line in center of slider.
    //This brings slider to stuck in iOS7.0
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.3")) {
//        UIColor *clearColor = [UIColor clearColor];
//        [_redSlider setMinimumTrackTintColor:clearColor];
//        [_redSlider setMaximumTrackTintColor:clearColor];
//
//        [_blueSlider setMinimumTrackTintColor:clearColor];
//        [_blueSlider setMaximumTrackTintColor:clearColor];
//
//        [_greenSlider setMinimumTrackTintColor:clearColor];
//        [_greenSlider setMaximumTrackTintColor:clearColor];
//
//    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.1")) {
//        UIColor *clearImageColor = [UIColor colorWithPatternImage:clearImage];
//        [_redSlider setMaximumTrackImage:clearImage forState:UIControlStateNormal];
//        [_redSlider setMinimumTrackTintColor:clearImageColor];
//        [_redSlider setMaximumTrackTintColor:clearImageColor];
//
//        [_greenSlider setMaximumTrackImage:clearImage forState:UIControlStateNormal];
//        [_blueSlider setMinimumTrackTintColor:clearImageColor];
//        [_blueSlider setMaximumTrackTintColor:clearImageColor];
//
//        [_blueSlider setMaximumTrackImage:clearImage forState:UIControlStateNormal];
//        [_greenSlider setMinimumTrackTintColor:clearImageColor];
//        [_greenSlider setMaximumTrackTintColor:clearImageColor];
//    }
}

- (void)setColor:(UIColor *)color {
    [self setActiveColor:color];
    self.previousColor = color;
}

- (void)setActiveColor:(UIColor *)color {
    [self setColor:color updatePicker:YES updateSliders:YES updateCurrentColor:YES];
}

- (void)setPreviousColor:(UIColor *)previousColor {
    _previousColor = previousColor;
    self.previousColorRect.backgroundColor = previousColor;
}

- (void)setColor:(UIColor *)color
    updatePicker:(BOOL)updatePicker
   updateSliders:(BOOL)updateSliders
updateCurrentColor:(BOOL)updateCurrentColor {
    
    _color = color;
    
    if (updatePicker) {
        self.colorPicker.color = color;
    }
    if (updateSliders) {
        [self updateSliderValuesWithColor:color];
    }
    if (updateCurrentColor) {
        [self updateCurrentColor:color];
    }
}

- (void)setCurrentColorModel:(PAColorModel)currentColorModel {
    _currentColorModel = currentColorModel;
    
    if (currentColorModel == PAColorModelHSB) {
        _redTitleLabel.text = @"H";
        _greenTitleLabel.text = @"S";
        _blueTitleLabel.text = @"B";
        
        _redSliderColorView.type = PAColorSliderTypeHue;
        _greenSliderColorView.type = PAColorSliderTypeSaturation;
        _blueSliderColorView.type = PAColorSliderTypeBrightness;
        
        _redSlider.maximumValue = 360;
        _greenSlider.maximumValue = 100;
        _blueSlider.maximumValue = 100;
    }
    else if (currentColorModel == PAColorModelRGB) {
        _redTitleLabel.text = @"R";
        _greenTitleLabel.text = @"G";
        _blueTitleLabel.text = @"B";
        
        _redSliderColorView.type = PAColorSliderTypeRed;
        _greenSliderColorView.type = PAColorSliderTypeGreen;
        _blueSliderColorView.type = PAColorSliderTypeBlue;
        
        _redSlider.maximumValue = 255;
        _greenSlider.maximumValue = 255;
        _blueSlider.maximumValue = 255;
    }
    
    [self updateSliderValuesWithColor:self.color];
}

- (void)setPipetteEnabled:(BOOL)pipetteEnabled {
    self.pipetteButton.hidden = !pipetteEnabled;
}

#pragma mark - UI Updates

- (void)updateSliderValuesWithColor:(UIColor *)color {
    CGFloat firstComponent = 0.0;
    CGFloat secondComponent = 0.0;
    CGFloat thirdComponent = 0.0;
    CGFloat alpha = 1.0;
    
    if (_currentColorModel == PAColorModelRGB) {
        [color getRed:&firstComponent
                green:&secondComponent
                 blue:&thirdComponent
                alpha:&alpha];
    }
    else {
        [color getHue:&firstComponent
           saturation:&secondComponent
           brightness:&thirdComponent
                alpha:&alpha];
    }
    
    [self updateSliderValuesWithColorFirstComponent:firstComponent
                                    secondComponent:secondComponent
                                     thirdComponent:thirdComponent];
}

- (void)updateSliderValuesWithColorFirstComponent:(CGFloat)firstComponent
                                  secondComponent:(CGFloat)secondComponent
                                   thirdComponent:(CGFloat)thirdComponent {
    
    [_redSlider setValue:roundf(firstComponent * _redSlider.maximumValue) animated:NO];
    [_greenSlider setValue:roundf(secondComponent * _greenSlider.maximumValue) animated:NO];
    [_blueSlider setValue:roundf(thirdComponent * _blueSlider.maximumValue) animated:NO];
    
    [self updateSliderValueLabels];
    [self updateSliderBackgroundColors];
}

- (void)updateSliderValueLabels {
    _redValueLabel.text = [NSNumber numberWithInteger:_redSlider.value].stringValue;
    _greenValueLabel.text = [NSNumber numberWithInteger:_greenSlider.value].stringValue;
    _blueValueLabel.text = [NSNumber numberWithInteger:_blueSlider.value].stringValue;
}

- (void)updateSliderBackgroundColors {
    _redSliderColorView.firstOtherComponentValue = _greenSlider.value / _greenSlider.maximumValue;
    _redSliderColorView.secondOtherComponentValue = _blueSlider.value / _blueSlider.maximumValue;
    [_redSliderColorView update];
    
    _greenSliderColorView.firstOtherComponentValue = _redSlider.value / _redSlider.maximumValue;
    _greenSliderColorView.secondOtherComponentValue = _blueSlider.value / _blueSlider.maximumValue;
    [_greenSliderColorView update];
    
    _blueSliderColorView.firstOtherComponentValue = _redSlider.value / _redSlider.maximumValue;
    _blueSliderColorView.secondOtherComponentValue = _greenSlider.value / _greenSlider.maximumValue;
    [_blueSliderColorView update];
}

- (void)updateCurrentColor:(UIColor *)currentColor {
    _currentColorRect.backgroundColor = _color;
    _paletteView.choosedColor = _color;
}

- (void)applyAndClose {
    
    self.previousColor = self.currentColorRect.backgroundColor;
    if ([self.superview isKindOfClass:[SCColorPicker class]]) {
        SCColorPicker *colorPicker = (SCColorPicker *)self.superview;
        [colorPicker.delegate colorPicker:colorPicker didFinishPickColor:self.color];
        [colorPicker close:YES];
    }
}

#pragma mark - Actions

- (IBAction)choosePrevoiusColor:(UITapGestureRecognizer *)sender {
    [self setActiveColor:self.previousColorRect.backgroundColor];
}

- (IBAction)selectPipetteTool:(UIButton *)sender {
    if ([self.superview isKindOfClass:[SCColorPicker class]]) {
        SCColorPicker *colorPicker = (SCColorPicker *)self.superview;
        
        if ([colorPicker.delegate respondsToSelector:@selector(colorPickerDidSelectPipette:)]) {
                [colorPicker.delegate colorPickerDidSelectPipette:colorPicker];
        }
    }
}

- (IBAction)switchColorModel:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == PAColorModelRGB) {
        self.currentColorModel = PAColorModelRGB;
    }
    else {
        self.currentColorModel = PAColorModelHSB;
    }
}

- (IBAction)showOrHidePalette:(UIButton *)sender {
    if ([sender isSelected]) {
        [sender setSelected:NO];
        [self hidePaletteView];
    }
    else {
        [sender setSelected:YES];
        [self showPaletteView];
    }
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    UIColor *changedColor;
    if (_currentColorModel == PAColorModelRGB) {
        changedColor = [UIColor colorWithRed:self.redSlider.value / _redSlider.maximumValue
                                       green:self.greenSlider.value / _greenSlider.maximumValue
                                        blue:self.blueSlider.value / _blueSlider.maximumValue
                                       alpha:1.0];
        
    } else if (_currentColorModel == PAColorModelHSB) {
        
        CGFloat hue = self.redSlider.value / _redSlider.maximumValue;
        CGFloat saturation = self.greenSlider.value / _greenSlider.maximumValue;
        CGFloat brightness = self.blueSlider.value / _blueSlider.maximumValue;
        
        CGFloat minValue = 0.001f;
        
        changedColor = [UIColor colorWithHue:(hue ? hue : minValue)
                                  saturation:(saturation ? saturation : minValue)
                                  brightness:(brightness ? brightness : minValue)
                                       alpha:1.0];
    }
    [self setColor:changedColor updatePicker:YES updateSliders:NO updateCurrentColor:YES];
    [self updateSliderValueLabels];
    [self updateSliderBackgroundColors];
}

- (IBAction)cancel:(UIButton *)sender {
    if ([self.superview isKindOfClass:[SCColorPicker class]]) {
        SCColorPicker *colorPicker = (SCColorPicker *)self.superview;
        if (colorPicker.delegate && [colorPicker.delegate respondsToSelector:@selector(colorPickerDidCancel:closedByButton:lastChangedColor:)]) {
            [colorPicker.delegate colorPickerDidCancel:colorPicker closedByButton:YES lastChangedColor:self.color];
        }
        [colorPicker close:YES];
    }
    [self setActiveColor:_previousColor];
    
    
}

- (IBAction)done:(UIButton *)sender {
    [self applyAndClose];
}

#define RED_TAG 1
#define GREEN_TAG 2
#define BLUE_TAG 3

- (IBAction)plusButtonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case RED_TAG:
            [self incrementValueForSlider:_redSlider];
            break;
        case GREEN_TAG:
            [self incrementValueForSlider:_greenSlider];
            break;
        case BLUE_TAG:
            [self incrementValueForSlider:_blueSlider];
            break;
    }
}

- (IBAction)minusButtonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case RED_TAG:
            [self decrementSliderValue:_redSlider];
            break;
        case GREEN_TAG:
            [self decrementSliderValue:_greenSlider];
            break;
        case BLUE_TAG:
            [self decrementSliderValue:_blueSlider];
            break;
    }
}

- (void)incrementValueForSlider:(UISlider *)slider {
    CGFloat value = MIN(slider.value + 1, slider.maximumValue);
    [slider setValue:value animated:YES];
    
    [self sliderValueChanged:slider];
}

- (void)decrementSliderValue:(UISlider *)slider {
    CGFloat value = MAX(slider.value - 1, slider.minimumValue);
    [slider setValue:value animated:YES];
    
    [self sliderValueChanged:slider];
}

#pragma mark - Delegate methods

- (void)colorPicker:(PACircleColorPicker *)colorPicker didSelectColor:(UIColor *)color {
    [self setColor:color updatePicker:NO updateSliders:YES updateCurrentColor:YES];
}

- (void)colorPicker:(PACircleColorPicker *)colorPicker didSelectColorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
    
    UIColor *color = [UIColor colorWithHue:hue
                                saturation:saturation
                                brightness:brightness
                                     alpha:1.0];
    
    [self setColor:color updatePicker:NO updateSliders:NO updateCurrentColor:YES];
    
    if (_currentColorModel == PAColorModelHSB) {
        [self updateSliderValuesWithColorFirstComponent:hue secondComponent:saturation  thirdComponent:brightness];
    } else if(_currentColorModel == PAColorModelRGB) {
        CGFloat red = 0;
        CGFloat green = 0;
        CGFloat blue = 0;
        CGFloat alpha = 0;
        
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        [self updateSliderValuesWithColorFirstComponent:red secondComponent:green thirdComponent:blue];
    }
}

- (void)colorPalette:(PAColorPaletteView *)palette didSelectColor:(UIColor *)color {
    [self setActiveColor:color];
}

- (void)colorPalette:(PAColorPaletteView *)palette didAddColor:(UIColor *)color {
}

#pragma mark - Animations

#define DURATION 0.2

- (void)showPaletteView {
    self.paletteView.hidden = NO;
    
    [UIView animateWithDuration:DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.paletteView.frame;
        frame.origin.y = CGRectGetMaxY(self.bounds) - frame.size.height - 10;
        self.paletteView.frame = frame;
        self.sliderContentView.alpha = 0.0;
        self.colorModelsSegmentedControl.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.paletteView.hidden = NO;
    }];
}

- (void)hidePaletteView {
    [UIView animateWithDuration:DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.paletteView.frame;
        frame.origin.y = CGRectGetMaxY(self.bounds);
        self.paletteView.frame = frame;
        self.sliderContentView.alpha = 1.0;
        self.colorModelsSegmentedControl.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.paletteView.hidden = YES;
    }];
}

@end
