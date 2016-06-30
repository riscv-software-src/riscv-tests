#include <stdio.h>
#include <string.h>
#include <stdint.h>

unsigned int crc32a(uint8_t *message, unsigned int size);

char __malloc_start[512];

void rot13(char *buf)
{
    while (*buf) {
        if ((*buf >= 'a' && *buf <= 'm') ||
                (*buf >= 'A' && *buf <= 'M')) {
            *buf += 13;
        } else if ((*buf >= 'n' && *buf <= 'z') ||
                (*buf >= 'N' && *buf <= 'Z')) {
            *buf -= 13;
        }
        buf++;
    }
}

size_t strlen(const char *buf)
{
    int len = 0;
    while (buf[len])
        len++;
    return len;
}

int main()
{
    volatile int i = 0;
    int j = 0;
    char *fox = "The quick brown fox jumps of the lazy dog.";
    unsigned int checksum = 0;

start:
    while (i)
        j++;

    rot13(fox);
    checksum ^= crc32a(fox, strlen(fox));
    rot13(fox);
    checksum ^= crc32a(fox, strlen(fox));

    return checksum;
}
