//
//  PAColorPaletteView.m
//  PAColorPicker
//
//  Created by David Shakhbazyan on 11/10/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import "PAColorPaletteView.h"
#import "NSArray+VLAddition.h"
#import "UIColor+VLAddition.h"

@interface PAColorPickerPalette : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath predefinedPath:(NSString *)path;

@property (nonatomic) NSArray *colors;

- (void)updateColorAtIndex:(NSUInteger)colorIndex withColor:(UIColor *)color;

@end

#define CELL_SIZE 40
#define CELL_INSET 4
#define ROWS 8
#define COLUMNS 6
#define BORDER_WIDTH 0

@interface PAColorPaletteView ()

@property (assign, nonatomic) CGFloat cellSize;
@property (assign, nonatomic) CGFloat rowCount;
@property (assign, nonatomic) CGFloat columnCount;

@property (assign, nonatomic) NSUInteger currentIndex;

@property (strong, nonatomic) UIView *grid;

@property (weak, nonatomic) UIView *cellToRemove;

@property (nonatomic) PAColorPickerPalette *palette;
@end

@implementation PAColorPaletteView

@synthesize delegate = _delegate;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init {
    self.backgroundColor = [UIColor clearColor];
    CGSize size = CGSizeMake(CELL_SIZE * COLUMNS, CELL_SIZE * ROWS);
    self.contentSize = size;
    self.clipsToBounds = YES;
    self.bounces = NO;
    
    self.cellSize = CELL_SIZE;
    self.rowCount = ROWS;
    self.columnCount = COLUMNS;
    
    [self initCells];
    [self loadColors:self.palette.colors];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.grid addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(removeColor:)];
    longPress.allowableMovement = 2 * CELL_SIZE;
    [self.grid addGestureRecognizer:longPress];
}

- (void)initCells {
    CGRect gridFrame = self.bounds;
    gridFrame.size = self.contentSize;
    self.grid = [[UIView alloc] initWithFrame:gridFrame];
    
    for (int i = 0; i < ROWS * COLUMNS; i++) {
        CGFloat originX = (i % COLUMNS) * CELL_SIZE;
        CGFloat originY = (i / (int)COLUMNS) * CELL_SIZE;
        CGPoint origin = CGPointMake(originX, originY);
        UIView *cell = [self createCellWithOrigin:origin];
        [_grid addSubview:cell];
    }
    [self addSubview:_grid];
}

- (UIView *)createCellWithOrigin:(CGPoint)origin {
    CGRect frame = CGRectMake(origin.x, origin.y, CELL_SIZE, CELL_SIZE);
    frame = CGRectInset(frame, CELL_INSET, CELL_INSET);
    UIView *cell = [[UIView alloc] initWithFrame:frame];
    
//    cell.layer.shadowOpacity = 0.3f;
//    cell.layer.shadowOffset = CGSizeMake(2.0, 3.0);
    cell.layer.cornerRadius = 6;
    cell.layer.backgroundColor = [UIColor clearColor].CGColor;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 1.0;
    
    return cell;
}

#pragma mark - Actions

#define EMPTY_CELL_TAG 0

- (void)removeColor:(UILongPressGestureRecognizer *)sender {
    
    CGPoint location = [sender locationInView:self.grid];
    UIView *viewFromHitTest = [self.grid hitTest:location withEvent:nil];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ((viewFromHitTest != self) && (viewFromHitTest.tag != EMPTY_CELL_TAG)) {
            _cellToRemove = viewFromHitTest;
            [UIView animateWithDuration:0.2 animations:^ {
                _cellToRemove.transform = CGAffineTransformMakeScale(1.2, 1.2);
                _cellToRemove.layer.zPosition = 1;
            }];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        [self.palette updateColorAtIndex:[_cellToRemove.superview.subviews indexOfObject:_cellToRemove] withColor:nil];
        [UIView animateWithDuration:0.2 animations:^ {
            _cellToRemove.transform = CGAffineTransformIdentity;
            _cellToRemove.layer.zPosition = 0;
            _cellToRemove.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                _cellToRemove.layer.backgroundColor = [UIColor clearColor].CGColor;
                _cellToRemove.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _cellToRemove.alpha = 1.0;
                _cellToRemove.tag = EMPTY_CELL_TAG;
            }
        }];
    }
}

- (void)tap:(UITapGestureRecognizer *)sender {
    CGPoint touchLocation = [sender locationInView:self];
    UIView *view = [self hitTest:touchLocation withEvent:nil];
    
    if (view != self.grid) {
        if (view.tag != EMPTY_CELL_TAG) {
            UIColor *cellColor = view.backgroundColor;
            [self.delegate colorPalette:self didSelectColor:cellColor];
        }
        else if (_choosedColor) {
            view.backgroundColor = _choosedColor;
            view.layer.borderColor = [UIColor clearColor].CGColor;
            view.tag = 1;
            [self.palette updateColorAtIndex:[view.superview.subviews indexOfObject:view] withColor:_choosedColor];
            [self.delegate colorPalette:self didAddColor:_choosedColor];
        }
    }
}

- (void)loadColors:(NSArray *)colors {
    if (colors) {
        for (int i = 0; i < colors.count; i++) {
            if ([colors[i] isKindOfClass:[UIColor class]]) {
                UIView *cell = self.grid.subviews[i];
                cell.backgroundColor = colors[i];
                cell.layer.borderColor = [UIColor clearColor].CGColor;
                cell.tag = 1;
            }
        }
    }
}

- (void)loadUserPalette {
    [self loadColors:self.palette.colors];
}

@end

@implementation PAColorPickerPalette {
    NSString *_filePath;
    NSString *_predefinedPath;
}

- (instancetype)initWithFilePath:(NSString *)filePath predefinedPath:(NSString *)path {
    self = [super init];
    NSParameterAssert(filePath);
    NSParameterAssert(path);
    _filePath = filePath;
    _predefinedPath = path;
    
    return self;
}

- (NSArray *)colors {
    if (_colors == nil){
        NSString *path = _predefinedPath;
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath isDirectory:NULL]) {
            path = _filePath;
        }
        NSError *e;
        NSArray *colors = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:&e];
        if (e){
            NSLog(@"error reading colors from file %@", e);
            _colors = @[];
        } else {
            _colors = [colors mapObjectsWithBlock:^id(id obj, NSUInteger idx) {
                if (obj == [NSNull null])
                    return obj;
                else {
                    UIColor *color = [UIColor colorWithHexString:obj];
                    return color;
                }
            }];
        }
    }
    return _colors;
}

- (void)updateColorAtIndex:(NSUInteger)colorIndex withColor:(UIColor *)color {
    self.colors = [self.colors mapObjectsWithBlock:^id(id obj, NSUInteger idx) {
        if (idx == colorIndex) {
            return color == nil ? [NSNull null] : color;
        } else {
            return obj;
        }
    }];

    NSArray *objectsToWrite = [self.colors mapObjectsWithBlock:^id(id obj, NSUInteger idx) {
        if (obj == [NSNull null]) {
            return obj;
        } else {
            return [obj hexString];
        }
    }];
    
    NSError *e;
    NSData *data = [NSJSONSerialization dataWithJSONObject:objectsToWrite options:0 error:&e];
    [data writeToFile:_filePath atomically:YES];
}

@end
