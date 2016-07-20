//
//  MathController.m
//  RunMaster
//
//  Created by Matt Luedke on 5/20/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import "MathController.h"

static bool const isMetric = YES;
static float const metersInKM = 1000;
static float const metersInMile = 1609.344;
static const int idealSmoothReachSize = 33; // about 133 locations/mi

@implementation MathController

+ (NSString *)stringifyDistance:(float)meters {
    
    float unitDivider;
    NSString *unitName;
    
    // metric
    if (isMetric) {
        
        unitName = @"km";
        
        // to get from meters to kilometers divide by this
        unitDivider = metersInKM;
        
        // U.S.
    } else {
        
        unitName = @"mi";
        
        // to get from meters to miles divide by this
        unitDivider = metersInMile;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", (meters / unitDivider), unitName];
}

+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat {
    
    int remainingSeconds = seconds;
    
    int hours = remainingSeconds / 3600;
    
    remainingSeconds = remainingSeconds - hours * 3600;
    
    int minutes = remainingSeconds / 60;
    
    remainingSeconds = remainingSeconds - minutes * 60;
    
    if (longFormat) {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%ihr %imin %isec", hours, minutes, remainingSeconds];
            
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%imin %isec", minutes, remainingSeconds];
            
        } else {
            return [NSString stringWithFormat:@"%isec", remainingSeconds];
        }
    } else {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, remainingSeconds];
            
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%02i:%02i", minutes, remainingSeconds];
            
        } else {
            return [NSString stringWithFormat:@"00:%02i", remainingSeconds];
        }
    }
}

+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds
{
    if (seconds == 0 || meters == 0) {
        return @"0";
    }
    
    float avgPaceSecMeters = seconds / meters;
    
    float unitMultiplier;
    NSString *unitName;
    
    // metric
    if (isMetric) {
        
        unitName = @"min/km";
        
        // to get from meters to kilometers divide by this
        unitMultiplier = metersInKM;
        
        // U.S.
    } else {
        
        unitName = @"min/mi";
        
        // to get from meters to miles divide by this
        unitMultiplier = metersInMile;
    }
    
    int paceMin = (int) ((avgPaceSecMeters * unitMultiplier) / 60);
    int paceSec = (int) (avgPaceSecMeters * unitMultiplier - (paceMin*60));
    
    return [NSString stringWithFormat:@"%02i:%02i", paceMin, paceSec];
}

+ (float) speedWithDistance:(float) distance andDuration:(int)duration {
    
    float secAvg = (float)duration/3600;
    
    NSLog(@"distancia:%f, duracao:%i speed:%f",distance,duration,(distance/secAvg));

    
    return (distance/secAvg);
}

+ (NSString*) speedBadge:(float)speed {
    
    NSString *badge;
    
    NSLog(@"velocidade ->%f",speed);
    
    if (speed >= 17.1 ){
        badge = @"falcon";
    } else if (speed >= 15 && speed < 17.1) {
        badge = @"eagle";
    } else if (speed >= 13.3 && speed < 15) {
        badge = @"cheetah";
    } else if (speed >= 12 && speed < 13.3) {
        badge = @"ostrish";
    } else if (speed >= 10.9 && speed < 12) {
        badge = @"longhorn";
    } else if (speed >= 10 && speed < 10.9) {
        badge = @"bull";
    } else if (speed >= 9.2 && speed < 10) {
        badge = @"hare";
    } else if (speed >= 8.6 && speed < 9.2) {
        badge = @"fox";
    } else if (speed >= 7.5 && speed < 8.6) {
        badge = @"horse";
    } else if (speed < 7.5 && speed > 0) {
        badge = @"mamba";
    }
    
    return badge;
}
@end