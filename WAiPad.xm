#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "fishhook.h"


int (*orig_WAUIDevicesIsDeviceSupported)(void);
int new_WAUIDevicesIsDeviceSupported(void) {
        return 1;
}

int (*orig_WAUIDevicesIsIPad)(void);
int new_WAUIDevicesIsIPad(void) {
    return 0;
}

// iPad

%hook UIDevice

- (BOOL)wa_isDeviceSupported {
    return true;
}

%end

%hook UIApplication

- (BOOL)_isClassic{

    return NO;
}
%end


%hook SBApplication

- (BOOL)_supportsApplicationType:(id)arg1{
    return true;
}

%end


%hook SBApplicationInfo

- (BOOL)wantsFullScreen{
    return true;
}

- (BOOL)wantsExclusiveForeground{
    return true;
}

- (BOOL)disablesClassicMode{
    return true;
}


%end


%ctor {
    struct rebinding binds[2];

    struct rebinding bind1 = {"WAUIDevicesIsDeviceSupported", (void *)new_WAUIDevicesIsDeviceSupported, (void **)&orig_WAUIDevicesIsDeviceSupported};
    struct rebinding bind2 = {"_WAUIDevicesIsIPad", (void *)new_WAUIDevicesIsIPad, (void **)&orig_WAUIDevicesIsIPad};
    binds[0] = bind1;
    binds[1] = bind2;


    rebind_symbols(binds, 2);
}
