/**
 * @file
 * @brief
 *
 * @author  Anton Kozlov
 * @date    08.07.2015
 */

#ifndef HTTPD_LOG_
#define HTTPD_LOG_

#ifdef __EMBUILD_MOD__

#include <util/log.h>
#define httpd_error log_error
#define httpd_warning log_warning
#define httpd_info log_info
#define httpd_debug log_debug

#else /* __EMBUILD_MOD__ */

#include <stdio.h>
#define httpd_error(fmt, ...) printf("error: " fmt "\n", ##__VA_ARGS__)
#define httpd_warning(fmt, ...) printf("warning: " fmt "\n", ##__VA_ARGS__)
#define httpd_info(fmt, ...) printf("info: " fmt "\n", ##__VA_ARGS__)
#define httpd_debug(fmt, ...) printf("debug: " fmt "\n", ##__VA_ARGS__)

#endif /* __EMBUILD_MOD__ */

#endif /* HTTPD_LOG_ */


