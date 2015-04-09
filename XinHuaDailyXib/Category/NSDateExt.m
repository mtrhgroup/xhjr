//
//  NSDateExt.m
//  Youlu
//
//  Created by William on 10-12-9.
//  Copyright 2010 Youlu . All rights reserved.
//

#import "NSDateExt.h"
static NSCalendar *calendar;
static NSDateFormatter *displayFormatter;
static NSDateFormatter* __dateFormate = nil;

@implementation NSDate(Ext)

- (NSString*)formatDateStyle:(HaloDateStyle)style
{
    switch (style) {
        case EDateStyleYMDHM:
        {
            [__dateFormate setDateStyle:NSDateFormatterLongStyle];
            [__dateFormate setTimeStyle:NSDateFormatterShortStyle];
        }
            break;
        case EDateStyleMDHM:
        {
            [__dateFormate setDateFormat:@"M-d ah:mm"];
        }
            break;
        case EDateStyleHM:
        {
            [__dateFormate setDateStyle:NSDateFormatterNoStyle];
            [__dateFormate setTimeStyle:NSDateFormatterShortStyle];  
        }
            break;
        case EDateStyleYMD:
        {
            [__dateFormate setDateStyle:NSDateFormatterLongStyle];
            [__dateFormate setTimeStyle:NSDateFormatterNoStyle];
        }
            break;
        case EDateStyleSmart:
        {
            return [self formatDateSmart];
        }
            break;
        case EDateStyleSmartWithAfter:
        {
            return [self formatDateSmartWithAfter:YES];
        }
            break;
        case EDateStyleSimple:
            return [self formatDateSimple];
            break;
        default:
            break;
    }
	return [__dateFormate stringFromDate:self]; 
}


- (NSString*)formatFullDate
{
    return [self formatDateStyle:EDateStyleYMDHM];
}

- (NSString*)formatDateSimple
{
    NSDate* now = [NSDate date];
	
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *dateComps = [calendar components:unitFlags fromDate:self];
	NSDateComponents *nowComps = [calendar components:unitFlags fromDate:now];
	

	 if (dateComps.year == nowComps.year)
	{
		if (dateComps.month == nowComps.month)
		{
			NSInteger dayDate = dateComps.day;
			NSInteger dayNow = nowComps.day;
			
			if (dayDate == dayNow)
			{
                [self formatDateStyle:EDateStyleHM];
			} 
		}
        return [self formatDateStyle:EDateStyleMDHM];
	}
    return [self formatDateStyle:EDateStyleYMD];

}


- (NSString*)formatDateSmart
{
	NSDate* now = [NSDate date];
	
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *dateComps = [calendar components:unitFlags fromDate:self];
	NSDateComponents *nowComps = [calendar components:unitFlags fromDate:now];
	
	if ([now compare:self] == NSOrderedAscending)
	{
        return [NSString stringWithFormat:NSLocalizedString(@"ago_sec",nil),1];
	}
	else if (dateComps.year == nowComps.year)
	{
		if (dateComps.month == nowComps.month)
		{
			NSInteger dayDate = dateComps.day;
			NSInteger dayNow = nowComps.day;
			
			if (dayDate == dayNow)
			{
				int intval = [now timeIntervalSinceDate:self];
                if (intval < 1)
                {
                    intval = 1;
                }
				if (intval < 3600)
				{
					if (intval < 60)
					{
						return [NSString stringWithFormat:NSLocalizedString(@"ago_sec",nil),intval];
					}
					else 
					{
						return [NSString stringWithFormat:NSLocalizedString(@"ago_min",nil),intval/60];
					}
				} 
				else 
				{
                    return [self formatDateStyle:EDateStyleHM];
				}
			} 
		}
        return [self formatDateStyle:EDateStyleMDHM];
	}
    return [self formatDateStyle:EDateStyleYMD];
}
- (NSString*)formatDateCountdown
{
	NSDate* now = [NSDate date];
	
    
    
    int intval = [self timeIntervalSinceDate:now];
    if (intval < 1)
    {
        intval = 1;
    }
    if (intval < 3600)
    {
        if (intval < 60)
        {
            return [NSString stringWithFormat:NSLocalizedString(@"after_sec",nil),intval];
        }
        else 
        {
            return [NSString stringWithFormat:NSLocalizedString(@"after_min",nil),intval/60];
        }
    } 
    else if(intval < 3600*24)
    {
        return [NSString stringWithFormat:NSLocalizedString(@"after_hour",nil),intval/3600];
        ;
    }
    
    
    return [NSString stringWithFormat:NSLocalizedString(@"after_day",nil),-[self daysAgo]];
    
}

- (NSString*)formatDateSmartWithAfter:(BOOL)after
{
	NSDate* now = [NSDate date];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *dateComps = [calendar components:unitFlags fromDate:self];
	NSDateComponents *nowComps = [calendar components:unitFlags fromDate:now];
	
	if ([now compare:self] == NSOrderedAscending && !after)
	{
        
        return [NSString stringWithFormat:NSLocalizedString(@"ago_sec",nil),1];
	}
	else if (dateComps.year == nowComps.year)
	{
		if (dateComps.month == nowComps.month)
		{
			NSInteger dayDate = dateComps.day;
			NSInteger dayNow = nowComps.day;
			
			if (dayDate == dayNow)
			{
				int intval = [now timeIntervalSinceDate:self];
                if (intval < 0 )
                {
                    if (abs(intval) < 3600)
                    {
                        if (abs(intval) < 60)
                        {
                            return [NSString stringWithFormat:NSLocalizedString(@"after_sec",nil),abs(intval)];
                        }
                        else 
                        {
                            return [NSString stringWithFormat:NSLocalizedString(@"after_min",nil),abs(intval)/60];
                        }
                    }    
                }
                else 
                {
                    if (intval < 3600)
                    {
                        if (intval < 60)
                        {
                            return [NSString stringWithFormat:NSLocalizedString(@"ago_sec",nil),intval];
                        }
                        else 
                        {
                            return [NSString stringWithFormat:NSLocalizedString(@"ago_min",nil),intval/60];
                        }
                    } 
                }
                return [self formatDateStyle:EDateStyleHM];
			} 
		}
        return [self formatDateStyle:EDateStyleMDHM];
	}
    return [self formatDateStyle:EDateStyleYMD];
}


- (NSString*)intervalSince1970
{
    NSString*  timeStr =  [NSString stringWithFormat:@"%f",[self timeIntervalSince1970]];
	Logger(@"timeStr = %@",timeStr);
	
	return timeStr;
}


+ (void)initialize 
{
    if (self == [NSDate class])
    {
        calendar = [[NSCalendar currentCalendar] retain];
        displayFormatter = [[NSDateFormatter alloc] init];
        __dateFormate = [[NSDateFormatter alloc] init];
        [__dateFormate setLocale:[NSLocale currentLocale]];
    }
}

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
- (NSUInteger)daysAgo {
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
											   fromDate:self
												 toDate:[NSDate date]
												options:0];
	return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
    // get a midnight version of ourself:
	NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	[mdf release];
	
	return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
	return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
	NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
	NSString *text = nil;
	switch (daysAgo) {
		case 0:
			text = @"Today";
			break;
		case 1:
			text = @"Yesterday";
			break;
		default:
			text = [NSString stringWithFormat:@"%d days ago", daysAgo];
	}
	return text;
}

- (NSUInteger)weekday {
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
	return [weekdayComponents weekday];
}

+ (NSDate *)dateFromString:(NSString *)string {
	return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:format];
	NSDate *date = [inputFormatter dateFromString:string];
	[inputFormatter release];
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime
{
    /* 
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
	
	NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
													 fromDate:today];
	
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	
	NSString *displayString = nil;
	
    // comparing against midnight
	if ([date compare:midnight] == NSOrderedDescending) {
		if (prefixed) {
			[displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
		} else {
			[displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
		}
	} else {
        // check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
		[componentsToSubtract release];
		if ([date compare:lastweek] == NSOrderedDescending) {
            if (displayTime)
                [displayFormatter setDateFormat:@"EEEE h:mm a"]; // Tuesday
            else
                [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
		} else {
            // check if same calendar year
			NSInteger thisYear = [offsetComponents year];
			
			NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
														   fromDate:date];
			NSInteger thatYear = [dateComponents year];			
			if (thatYear >= thisYear) {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d"];
			} else {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d, yyyy"];
			}
		}
		if (prefixed) {
			NSString *dateFormat = [displayFormatter dateFormat];
			NSString *prefix = @"'on' ";
			[displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
		}
	}
	
    // use display formatter to return formatted date string
	displayString = [displayFormatter stringFromDate:date];
	return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    // preserve prior behavior
	return [self stringForDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
	return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:self];
	[outputFormatter release];
	return timestamp_str;
}

- (NSString *)string {
	return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:dateStyle];
	[outputFormatter setTimeStyle:timeStyle];
	NSString *outputString = [outputFormatter stringFromDate:self];
	[outputFormatter release];
	return outputString;
}

- (NSDate *)beginningOfWeek {
    // largely borrowed from "Date and Time Programming Guide for Cocoa"
    // we'll use the default calendar and hope for the best
	
    NSDate *beginningOfWeek = nil;
	BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
						   interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	} 
	
    // couldn't calc via range, so try to grab Sunday, assuming gregorian style
    // Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	
	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
	 */
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
	[componentsToSubtract release];
	
    //normalize to midnight, extract the year, month, and day components and create a new date from those components.
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate:beginningOfWeek];
	return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
    // Get the weekday component of the current date
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
											   fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
    // Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
	[componentsToAdd setDay:(7 - [weekdayComponents weekday])];
	NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	[componentsToAdd release];
	
	return endOfWeek;
}

+ (NSString *)dateFormatString {
	return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
	return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString {	
	return [NSDate timestampFormatString];
}

@end
