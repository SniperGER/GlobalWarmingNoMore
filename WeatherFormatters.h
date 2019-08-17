#include <Foundation/Foundation.h>

@interface WeatherPrecipitationFormatter : NSObject
+ (id)convenienceFormatter;
- (NSInteger)precipitationUnit;
- (id)stringFromCentimeters:(CGFloat)arg1;
- (id)stringFromDistance:(CGFloat)arg1 isDataMetric:(BOOL)arg2;
- (id)stringFromInches:(CGFloat)arg1;
@end

@interface WeatherPressureFormatter : NSObject
+ (id)convenienceFormatter;
- (int)pressureUnit;
- (id)stringFromPressure:(float)arg1 isDataMetric:(BOOL)arg2;
@end

@interface WeatherVisibilityFormatter : NSObject
+ (id)convenienceFormatter;
- (id)stringFromDistance:(CGFloat)arg1 isDataMetric:(BOOL)arg2;
- (id)stringFromKilometers:(CGFloat)arg1;
- (id)stringFromMiles:(CGFloat)arg1;
@end

@interface WeatherWindSpeedFormatter : NSObject
+ (id)convenienceFormatter;
- (CGFloat)speedByConvertingToUserUnit:(CGFloat)arg1;
- (id)stringForWindDirection:(float)arg1;
- (id)stringForWindSpeed:(float)arg1;
@end

@interface WFTemperatureFormatter : NSObject
+ (id)temperatureFormatterWithInputUnit:(int)arg1 outputUnit:(int)arg2;
- (id)formattedStringFromTemperature:(id)arg1;
@end
