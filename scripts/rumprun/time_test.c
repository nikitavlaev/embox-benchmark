#include <stdio.h>
#include <unistd.h>
#include <sys/time.h>

int main()
{
    struct timeval stop;
    gettimeofday(&stop, NULL);
    printf("time: %lu us\n", (stop.tv_sec * 1000000 + stop.tv_usec));
    return 0;
}
