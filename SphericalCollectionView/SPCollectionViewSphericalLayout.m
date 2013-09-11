//
//  SPCollectionViewSphericalLayout.m
//  SphericalCollectionView
//
//  Created by Shunji Li on 9/8/13.
//  Copyright (c) 2013 Shunji Li. All rights reserved.
//

#import "SPCollectionViewSphericalLayout.h"
#import <QuartzCore/QuartzCore.h>
@implementation SPCollectionViewSphericalLayout


- (id)init
{
    self = [super init];
    if (self) {
        _originAxis.x = 1;
        _originAxis.y = 0;
        _originAxis.z = 0;
    }
    return self;
}

- (CGSize)collectionViewContentSize
{
    return self.collectionView.bounds.size;
}


- (CGPoint) centerForIndex: (NSUInteger) index withMaxIndex: (NSUInteger) max
{
    CGFloat radius = MIN(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height)/2 - 20;
    CGFloat angle = (index + 0.01f)/ max * M_PI *2;
    CGFloat xOffSet = cosf(angle) *radius;
    CGFloat yOffSet = sinf(angle) *radius;
    CGPoint point = self.collectionView.center;
    point.x +=  xOffSet;
    point.y += yOffSet;
    return point;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes =  [super layoutAttributesForElementsInRect:rect];
    NSUInteger count = [attributes count];
    
    [attributes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *attr = (UICollectionViewLayoutAttributes*) obj;

        CGPoint center = self.collectionView.center;

        SPCoordinate coordinate = [[SPCoordinateManager sharedManager] coordinateForIndex:(idx+1) withMaximumIndex:count originAxis:_originAxis];
        CGFloat radius = 100;
        CGFloat shrinkFactor =(coordinate.z + 1)*0.2 + 0.6;;
        center.x += coordinate.x *radius;
        center.y += coordinate.y *radius;
        attr.center = center;
        //NSLog(@"coodinate: %f, %f, %f", coordinate.x, coordinate.y, coordinate.z);
        //attr.transform3D = CATransform3DRotate(CATransform3DMakeScale(shrinkFactor, shrinkFactor, 1.0), (1-fabs(coordinate.z)*M_PI_4), coordinate.y, coordinate.x, 0.0);
    
        attr.transform3D = CATransform3DTranslate(CATransform3DMakeScale(shrinkFactor, shrinkFactor, 1.0), coordinate.x *radius/shrinkFactor, coordinate.y*radius/shrinkFactor, coordinate.z*radius/shrinkFactor);
        attr.alpha = (coordinate.z + 1)*0.4 + 0.2;
    }];
    
    return attributes;
}

- (void)setOriginAxis:(SPCoordinate)originAxis
{
    _originAxis = originAxis;
    [self invalidateLayout];
}


@end
