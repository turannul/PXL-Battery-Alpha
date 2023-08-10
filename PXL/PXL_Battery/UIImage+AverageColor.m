#include "UIImage+AverageColor.h"

@implementation UIImage (AverageColor)
- (UIColor *)averageColorOfImage:(UIImage *)image {
    CGImageRef imageRef = [image CGImage];
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    NSUInteger bytesPerPixel = 4; // RGBA
    NSUInteger bytesPerRow = bytesPerPixel * imageSize.width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger totalBytes = bytesPerRow * imageSize.height;
    
    unsigned char *rawData = malloc(totalBytes);
    if (!rawData) {
        return nil;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rawData, imageSize.width, imageSize.height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageSize.width, imageSize.height), imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    CGFloat totalRed = 0.0;
    CGFloat totalGreen = 0.0;
    CGFloat totalBlue = 0.0;
    
    for (NSUInteger y = 0; y < imageSize.height; y++) {
        for (NSUInteger x = 0; x < imageSize.width; x++) {
            NSUInteger byteIndex = (bytesPerRow * y) + (bytesPerPixel * x);
            CGFloat red = (CGFloat)rawData[byteIndex] / 255.0;
            CGFloat green = (CGFloat)rawData[byteIndex + 1] / 255.0;
            CGFloat blue = (CGFloat)rawData[byteIndex + 2] / 255.0;
            
            totalRed += red;
            totalGreen += green;
            totalBlue += blue;
        }
    }
    
    free(rawData);
    
    NSUInteger pixelCount = imageSize.width * imageSize.height;
    CGFloat averageRed = totalRed / (CGFloat)pixelCount;
    CGFloat averageGreen = totalGreen / (CGFloat)pixelCount;
    CGFloat averageBlue = totalBlue / (CGFloat)pixelCount;
    
    return [UIColor colorWithRed:averageRed green:averageGreen blue:averageBlue alpha:1.0];
}
@end