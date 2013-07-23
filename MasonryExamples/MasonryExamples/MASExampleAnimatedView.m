//
//  MASExampleAnimatedView.m
//  MasonryExamples
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "MASExampleAnimatedView.h"

@interface MASExampleAnimatedView ()

@property (nonatomic, strong) NSMutableArray *animatableConstraints;
@property (nonatomic, assign) int padding;

@end

@implementation MASExampleAnimatedView

- (id)init {
    self = [super init];
    if (!self) return nil;

    UIView *view1 = UIView.new;
    view1.backgroundColor = UIColor.greenColor;
    view1.layer.borderColor = UIColor.blackColor.CGColor;
    view1.layer.borderWidth = 2;
    [self addSubview:view1];

    UIView *view2 = UIView.new;
    view2.backgroundColor = UIColor.redColor;
    view2.layer.borderColor = UIColor.blackColor.CGColor;
    view2.layer.borderWidth = 2;
    [self addSubview:view2];

    UIView *view3 = UIView.new;
    view3.backgroundColor = UIColor.blueColor;
    view3.layer.borderColor = UIColor.blackColor.CGColor;
    view3.layer.borderWidth = 2;
    [self addSubview:view3];

    UIView *superview = self;
    int padding = self.padding = 10;
    UIEdgeInsets paddingInsets = UIEdgeInsetsMake(self.padding, self.padding, self.padding, self.padding);

    self.animatableConstraints = NSMutableArray.new;

    [view1 mas_buildConstraints:^(MASConstraintBuilder *constrain) {
        [self.animatableConstraints addObjectsFromArray:@[
            constrain.edges.equal(superview).insets(paddingInsets).priorityLow(),
            constrain.bottom.equal(view3.mas_top).offset(-padding),
            constrain.right.equal(view2.mas_left).offset(-padding),
        ]];

        constrain.size.equal(view2);
        constrain.height.equal(view3.mas_height);
    }];

    [view2 mas_buildConstraints:^(MASConstraintBuilder *constrain) {
        [self.animatableConstraints addObjectsFromArray:@[
            constrain.edges.equal(superview).insets(paddingInsets).priorityLow(),
            constrain.left.equal(view1.mas_right).offset(padding),
            constrain.bottom.equal(view3.mas_top).offset(-padding),
        ]];

        constrain.size.equal(view1);
        constrain.height.equal(view3.mas_height);
    }];

    [view3 mas_buildConstraints:^(MASConstraintBuilder *constrain) {
        [self.animatableConstraints addObjectsFromArray:@[
            constrain.edges.equal(superview).insets(paddingInsets).priorityLow(),
            constrain.top.equal(view1.mas_bottom).offset(padding),
        ]];

        //TODO or pass an array
        //constraints.height.equal(superview.subviews);
        constrain.height.equal(view1.mas_height);
        constrain.height.equal(view2.mas_height);
    }];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapWithGestureRecognizer:)];
    [self addGestureRecognizer:tapGestureRecognizer];

    return self;
}

- (void)didTapWithGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    self.padding += 20;
    UIEdgeInsets paddingInsets = UIEdgeInsetsMake(self.padding, self.padding, self.padding, self.padding);
    for (id<MASConstraint> constraint in self.animatableConstraints) {
        constraint.insets(paddingInsets);
    }

    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
