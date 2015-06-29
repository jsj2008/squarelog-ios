#ifdef _DEBUG
#define _NSLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define _NSLog(format, ...)
#endif