/**
 * @file
 * @brief
 *
 * @author  Anton Kozlov
 * @date    08.07.2015
 */

#include <string.h>
#include <unistd.h>

#include "httpd.h"

static int httpd_read_http_header(const struct client_info *cinfo, char *buf, size_t buf_sz) {
	const int sk = cinfo->ci_sock;
	const char *pattern = "\r\n\r\n";
	char pattbuf[strlen("\r\n\r\n")];
	char *pb;

	pb = buf;
	if (0 > read(sk, pattbuf, sizeof(pattbuf))) {
		return -1;
	}
	while (0 != strncmp(pattern, pattbuf, sizeof(pattbuf)) && buf_sz > 0) {
		*(pb++) = pattbuf[0];
		buf_sz--;
		memmove(pattbuf, pattbuf + 1, sizeof(pattbuf) - 1);
		if (0 > read(sk, &pattbuf[sizeof(pattbuf) - 1], 1)) {
			return -1;
		}
	}

	if (buf_sz == 0) {
		return -1;
	}

	memcpy(pb, pattbuf, sizeof(pattbuf));
	return pb + sizeof(pattbuf) - buf;
}

int httpd_build_request(struct client_info *cinfo, struct http_req *hreq, char *buf, size_t buf_sz) {
	int nbyte;

	nbyte = httpd_read_http_header(cinfo, buf, buf_sz - 1);
	if (nbyte < 0) {
		httpd_error("can't read from client socket: %s", strerror(-1));
		return -1;
	}
	buf[nbyte] = '\0';

	memset(hreq, 0, sizeof(*hreq));
	if (NULL == httpd_parse_request(buf, hreq)) {
		httpd_error("can't parse request");
		return -1;
	}

	return nbyte;
}

