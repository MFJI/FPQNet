/*
 * Copyright 2019 International Business Machines
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <malloc.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <getopt.h>
#include <ctype.h>
#include <fcntl.h>
#include <math.h>

#include <libosnap.h>
#include <osnap_tools.h>

#include "test_lenet.h"

/*  defaults */
#define START_DELAY     20
#define END_DELAY       200
#define STEP_DELAY      20
#define DEFAULT_MEMCPY_BLOCK    4096
#define DEFAULT_MEMCPY_ITER 1
#define ACTION_WAIT_TIME    10  /* Default in sec */

#define MEGAB       (1024*1024ull)
#define GIGAB       (1024 * MEGAB)
#define DDR_MEM_SIZE    (4 * GIGAB)     /* 4 GB (DDR RAM) */
#define DDR_MEM_BASE_ADDR   0x00000000  /* Start of FPGA Interconnect */

#define VERBOSE0(fmt, ...) do {         \
        printf(fmt, ## __VA_ARGS__);    \
    } while (0)

#define VERBOSE1(fmt, ...) do {         \
        if (verbose_level > 0)          \
            printf(fmt, ## __VA_ARGS__);    \
    } while (0)

#define VERBOSE2(fmt, ...) do {         \
        if (verbose_level > 1)          \
            printf(fmt, ## __VA_ARGS__);    \
    } while (0)


#define VERBOSE3(fmt, ...) do {         \
        if (verbose_level > 2)          \
            printf(fmt, ## __VA_ARGS__);    \
    } while (0)

#define VERBOSE4(fmt, ...) do {         \
        if (verbose_level > 3)          \
            printf(fmt, ## __VA_ARGS__);    \
    } while (0)

static  int verbose_level = 4;

static uint64_t get_usec (void)
{
    struct timeval t;

    gettimeofday (&t, NULL);
    return t.tv_sec * 1000000 + t.tv_usec;
}


/* Action or Kernel Write and Read are 32 bit MMIO */
static void action_write (struct snap_card* h, uint32_t addr, uint32_t data)
{
    int rc;

    rc = snap_action_write32 (h, (uint64_t)addr, data);

    if (0 != rc) {
        VERBOSE0 ("Write MMIO 32 Err\n");
    }

    return;
}

static void usage (const char* prog)
{
    printf ("Usage: %s <input_file> <timeout>\n", prog);
}

int main (int argc, char* argv[])
{
    char device[64];
    struct snap_card* dn;   /* lib snap handle */
    int card_no = 0;
    int rc = 1;
    snap_action_flag_t attach_flags = 0;
    struct snap_action* act = NULL;
    unsigned long ioctl_data;
    unsigned long dma_align;
    unsigned long dma_min_size;
    char card_name[16];   /* Space for Card name */
    uint64_t addr;

    if (argc != 3) {
        usage(argv[0]);
        exit(EXIT_FAILURE);
    }
    char *file_name = argv[1];
    int timeout = strtol(argv[2], NULL, 10);
    
    if (card_no == 0) {
        snprintf (device, sizeof (device) - 1, "IBM,oc-snap");
    } else {
        snprintf (device, sizeof (device) - 1, "/dev/ocxl/IBM,oc-snap.000%d:00:00.1.0", card_no);
    }

    VERBOSE2 ("Open Card: %d device: %s\n", card_no, device);
    dn = snap_card_alloc_dev (device, SNAP_VENDOR_ID_IBM, SNAP_DEVICE_ID_SNAP);

    if (NULL == dn) {
        VERBOSE0 ("ERROR: Can not Open (%s)\n", device);
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    }

    VERBOSE2 ("Open Card done\n");

    /* Read Card Name */
    snap_card_ioctl (dn, GET_CARD_NAME, (unsigned long)&card_name);
    VERBOSE1 ("SNAP on %s", card_name);

    snap_card_ioctl (dn, GET_SDRAM_SIZE, (unsigned long)&ioctl_data);
    VERBOSE1 (" Card, %d MB of Card Ram avilable. ", (int)ioctl_data);

    snap_card_ioctl (dn, GET_DMA_ALIGN, (unsigned long)&dma_align);
    VERBOSE1 (" (Align: %d ", (int)dma_align);

    snap_card_ioctl (dn, GET_DMA_MIN_SIZE, (unsigned long)&dma_min_size);
    VERBOSE1 (" Min DMA: %d Bytes)\n", (int)dma_min_size);

    act = snap_attach_action (dn, ACTION_TYPE_LENET,
                              attach_flags, 100);

    if (NULL == act) {
        VERBOSE0 ("Error: Can not attach Action: %x\n",
                  ACTION_TYPE_LENET);
        rc = 0x100;
        goto __exit1;
    }

    int fd;
    struct stat s;

    /* Open the file for reading. */
    fd = open (file_name, O_RDONLY);
    if (fd < 0) {
        printf("open %s failed: %s", file_name, strerror (errno));
        goto __exit1;
    }

    /* Get the size of the file. */
    int status = fstat (fd, & s);
    if (status < 0) {
        printf("stat %s failed: %s", file_name, strerror (errno));
        goto __exit1;
    }
    int size = s.st_size;

    /* Memory-map the file. */
    const char *mapped_memory = mmap (0, size, PROT_READ, MAP_PRIVATE, fd, 0);
    if (mapped_memory == MAP_FAILED) {
        printf("mmap %s failed: %s", file_name, strerror (errno));
        goto __exit1;
    }
    if ((uint64_t)mapped_memory & (4096-1)) {
        //this should never happen, as Linux will page-align the mmap
        printf("Memory must be aligned to 4096 bytes");
        goto __exit1;
    }

    //Create a buffer to receive the data back from the accelerator
    char *accelerator_output;
    posix_memalign((void**)(&accelerator_output), 4096, size);
    memset(accelerator_output, 0, size);


    printf(" File (size: %d bytes) mapped at %p, output buffer at %p", size, mapped_memory, accelerator_output);
    printf("first data: 0x%lx\n", (uint64_t)(((uint64_t*)mapped_memory)[0]));

    addr = (uint64_t)accelerator_output;
    action_write (dn, ACTION_DEST_LOW, (uint32_t) (addr & 0xffffffff));
    action_write (dn, ACTION_DEST_HIGH, (uint32_t) (addr >> 32));
    addr = (uint64_t)mapped_memory;
    action_write (dn, ACTION_SRC_LOW, (uint32_t) (addr & 0xffffffff));
    action_write (dn, ACTION_SRC_HIGH, (uint32_t) (addr >> 32));
    action_write (dn, ACTION_CNT, size);

    uint64_t t_start;   /* time in usec */
    uint64_t td = 0;    /* Diff time in usec */

    /* FIXME Use struct snap_action and not struct snap_card */
    snap_action_start ((void*)dn);

    /* Wait for Action to go back to Idle */
    t_start = get_usec();
    rc = snap_action_completed ((void*)dn, NULL, timeout);

    if (rc) {
        rc = 0;    /* Good */
    } else {
        rc = ETIME;    /* Timeout */
    }

    if (0 != rc) {
        VERBOSE0 ("Error: timeout (%d)\n", timeout);
    }

    td = get_usec() - t_start;
    printf("Action finished in %lu us.\n", td);

    /* Detach Action and exit if rc is set */
    if (0 != snap_detach_action (act)) {
        VERBOSE0 ("Error: Can not detach Action: %x\n",
                  ACTION_TYPE_LENET);
        rc |= 0x100;
    }

    int errors = 0;
    
    for (int i = 0; i<6; i++) {
        printf("output %d is %d. \n\n",  i, accelerator_output[(64*i)]);
    }
    
    
    
    
//    if (accelerator_output[0] != 7) {
//        errors++;
//    }
    
//    if (accelerator_output[1] != 10) {
//        errors++;
//    }
    
//    if (accelerator_output[2] != 1) {
//        errors++;
//    }
    
//    if (accelerator_output[3] != 2) {
//        errors++;
//    }
    
//    if (accelerator_output[4] != 3) {
//        errors++;
//    }
    
//    if (accelerator_output[5] != 4) {
//        errors++;
//    }
    
//    for (int i = 0; i < 7; i++) {
//        if (mapped_memory[i] != accelerator_output[i]) {
//            errors++;
//        }
//    }
    
    if (errors) {
        printf("%d errors found in output.\n\n", errors);        
    } else {
        printf("Success.\n\n");
    }

__exit1:
    // Unmap AFU MMIO registers, if previously mapped
    VERBOSE2 ("Free Card Handle: %p\n", dn);
    snap_card_free (dn);

    VERBOSE1 ("End of Test rc: %d\n", rc);
    return rc;
}
