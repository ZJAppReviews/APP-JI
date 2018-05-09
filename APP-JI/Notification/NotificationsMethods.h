#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NotificationsMethods : NSObject

- (void)setupNotifications:(NSString *)question;
- (void)presentNotificationNow:(NSString *)question andHour:(NSString *)hour minute:(NSString *)minute;

@end
