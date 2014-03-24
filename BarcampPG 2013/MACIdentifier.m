#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if_dl.h>
#import <net/if.h>
#import "MACIdentifier.h"

//#import <netdb.h>
//#import <errno.h>
//#import <arpa/inet.h>
//#import <unistd.h>
//#import <ifaddrs.h>

#if !defined(IFT_ETHER)
#define IFT_ETHER 0x6
#endif

@implementation MACIdentifier

+ (NSString*)MACAddress {
    //old implementation
//  NSMutableString* result = [NSMutableString string];
//    
//	BOOL success;
//	struct ifaddrs* addrs;
//	const struct ifaddrs* cursor;
//	const struct sockaddr_dl* dlAddr;
//	const uint8_t * base;
//	int i;
//    
//	success = (getifaddrs(&addrs) == 0);
//	if(success)
//	{
//		cursor = addrs;
//		while(cursor != NULL)
//		{
//			if((cursor->ifa_addr->sa_family == AF_LINK) && (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER))
//			{
//				dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
//                
//				base = (const uint8_t *) &dlAddr->sdl_data[dlAddr->sdl_nlen];
//                
//				for(i=0; i < dlAddr->sdl_alen; i++)
//				{
//					if(i != 0)
//					{
//						[result appendString:@":"];
//					}
//					[result appendFormat:@"%02x", base[i]];
//				}
//			}
//			cursor = cursor->ifa_next;
//		}
//		freeifaddrs(addrs);
//	}
//    
//	return result;
    
	int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    //NSLog(@"Mac Address: %@", macAddressString);
    // Release the buffer memory
    free(msgBuffer);
    return macAddressString;
}

@end