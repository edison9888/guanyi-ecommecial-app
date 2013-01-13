/*
 *  IPAdress.h
 *
 *
 */

#define MAXADDRS	32

extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];

// Function prototypes

void InitAddresses(void);
void FreeAddresses(void);
void GetIPAddresses(void);
void GetHWAddresses(void);