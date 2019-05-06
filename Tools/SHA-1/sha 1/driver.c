/*
 *  sha1test.c
 *
 *  Description:
 *      This file will exercise the SHA-1 code performing the three
 *      tests documented in FIPS PUB 180-1 plus one which calls
 *      SHA1Input with an exact multiple of 512 bits, plus a few
 *      error test checks.
 *
 *  Portability Issues:
 *      None.
 *
 */

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "sha1.h"

/*
 *  Define patterns for testing
 */
#define TEST1   "abc"
#define TEST2a  "abcdbcdecdefdefgefghfghighijhi"
#define TEST2b  "jkijkljklmklmnlmnomnopnopq"
#define TEST2   TEST2a TEST2b
#define TEST3   "a"
#define TEST4a  "01234567012345670123456701234567"
#define TEST4b  "01234567012345670123456701234567"
/* an exact multiple of 512 bits */
#define TEST4   TEST4a TEST4b
#define TEST5 ""
#define TEST6 "message digest"
#define TEST7 "abcdefghijklmnopqrstuvwxyz"
#define TEST8 "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define TEST9 "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl"
#define TEST10 "12345678901234567890123456789012345678901234567890123456789012345678901234567890"

char* testarray[10] =
    {
        TEST1,
        TEST2,
        TEST3,
        TEST4,
        TEST5,
        TEST6,
        TEST7,
        TEST8,
        TEST9,
        TEST10,
    };
long int repeatcount[10] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
char* resultarray[10] =
    {
        "A9 99 3E 36 47 06 81 6A BA 3E 25 71 78 50 C2 6C 9C D0 D8 9D",
        "84 98 3E 44 1C 3B D2 6E BA AE 4A A1 F9 51 29 E5 E5 46 70 F1",
        "86 F7 E4 37 FA A5 A7 FC E1 5D 1D DC B9 EA EA EA 37 76 67 B8",
        "E0 C0 94 E8 67 EF 46 C3 50 EF 54 A7 F5 9D D6 0B ED 92 AE 83",
        "DA 39 A3 EE 5E 6B 4B 0D 32 55 BF EF 95 60 18 90 AF D8 07 09",
        "C1 22 52 CE DA 8B E8 99 4D 5F A0 29 0A 47 23 1C 1D 16 AA E3",
        "32 D1 0C 7B 8C F9 65 70 CA 04 CE 37 F2 A1 9D 84 24 0D 3A 89",
        "76 1C 45 7B F7 3B 14 D2 7E 9E 92 65 C4 6F 4B 4D DA 11 F9 40",
        "93 24 9D 4C 2F 89 03 EB F4 1A C3 58 47 31 48 AE 6D DD 70 42",
        "50 AB F5 70 6A 15 09 90 A0 8B 2C 5E A4 0F A0 E5 85 55 47 32",
    };


int main() {
    SHA1Context sha;
    int i, j, err;
    uint8_t Message_Digest[20];

    /*
     *  Perform SHA-1 tests
     */
    for (j = 0; j < 10; ++j) {
        printf("\nTest %d: %d, '%s'\n",
               j + 1,
               repeatcount[j],
               testarray[j]);

        err = SHA1Reset(&sha);
        if (err) {
            fprintf(stderr, "SHA1Reset Error %d.\n", err);
            break; /* out of for j loop */
        }

        for (i = 0; i < repeatcount[j]; ++i) {
            err = SHA1Input(&sha,
                            (const unsigned char *)testarray[j],
                            strlen(testarray[j]));
            if (err) {
                fprintf(stderr, "SHA1Input Error %d.\n", err);
                break; /* out of for i loop */
            }
        }

        err = SHA1Result(&sha, Message_Digest);
        if (err) {
            fprintf(stderr,
                    "SHA1Result Error %d, could not compute message digest.\n",
                    err);
        } else {
            printf("\t");
            for (i = 0; i < 20; ++i) {
                printf("%02X ", Message_Digest[i]);
            }
            printf("\n");
        }
        printf("Should match:\n");
        printf("\t%s\n", resultarray[j]);
    }

    /* Test some error returns */
    err = SHA1Input(&sha, (const unsigned char *)testarray[1], 1);
    printf("\nError %d. Should be %d.\n", err, shaStateError);
    err = SHA1Reset(0);
    printf("\nError %d. Should be %d.\n", err, shaNull);
    return 0;
}
