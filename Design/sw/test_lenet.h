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

#ifndef __SNAP_FW_EXA__
#define __SNAP_FW_EXA__

/*
 * This makes it obvious that we are influenced by HLS details ...
 * The ACTION control bits are defined in the following file.
 */
#include <osnap_hls_if.h>

/* Header file for SNAP Framework example code */
#define ACTION_TYPE_LENET       0x10142008	/* Action Type */

#define ACTION_CONFIG           0x30 //JJH not used anymore

#define ACTION_SRC_LOW          0x34	/* LBA for 0A, 1A, 0B and 1B */
#define ACTION_SRC_HIGH         0x38
#define ACTION_DEST_LOW         0x3c	/* LBA for 0A, 1A, 0B and 1B */
#define ACTION_DEST_HIGH        0x40
#define ACTION_CNT              0x44    /* Count Register or # of 512 Byte Blocks for NVME */

#endif	/* __SNAP_FW_EXA__ */
