/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <fcntl.h>
#include <linux/input.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <android-base/logging.h>

#define AUDIO_SERVICE_SET_STREAM_VOLUME 33

int read_tristate() {
    int fd = open("/proc/tristatekey/tri_state", O_RDONLY);
    if (fd < 0) {
        LOG(ERROR) << "Failed to open tristate node";
        return -1;
    }
    char p[16];
    int ret = read(fd, p, sizeof(p) - 1);
    close(fd);
    if (ret <= 0) {
        LOG(ERROR) << "Failed to read tristate node";
        return -1;
    }
    p[ret] = 0;
    return atoi(p);
}

int set_audio_mode(int mode) {
    char cmd[128];
    snprintf(cmd, sizeof(cmd), "service call audio %d i32 %d s16 android", AUDIO_SERVICE_SET_STREAM_VOLUME, mode);
    int ret = system(cmd);
    if (ret != 0) {
        LOG(ERROR) << "Failed to set audio mode: " << mode;
    }
    return ret;
}

int main() {
    int fd = -1;
    for (int i = 0; i < 255; i++) {
        char path[256];
        snprintf(path, sizeof(path), "/dev/input/event%d", i);
        fd = open(path, O_RDWR);
        if (fd == -1) continue;
        char name[256];
        ioctl(fd, EVIOCGNAME(sizeof(name)), name);
        LOG(INFO) << "Got input name: " << name;
        if (strcmp(name, "oplus,hall_tri_state_key") == 0) {
            break;
        }
        close(fd);
        fd = -1;
    }
    if (fd == -1) {
        LOG(ERROR) << "Failed to find alert slider input device";
        return 1;
    }

    if (ioctl(fd, EVIOCGRAB, 1) < 0) {
        LOG(ERROR) << "Failed to grab input device";
        close(fd);
        return 1;
    }

    struct input_event ev;
    while (read(fd, &ev, sizeof(ev)) == sizeof(ev)) {
        if (!(ev.code == 61 && ev.value == 0)) continue;
        int state = read_tristate();
        if (state < 0) continue;
        LOG(INFO) << "Alert slider state: " << state;
        if (state == 1) {
            set_audio_mode(0);
        } else if (state == 2) {
            set_audio_mode(1);
        } else if (state == 3) {
            set_audio_mode(2);
        }
    }

    LOG(ERROR) << "Input device read failed";
    close(fd);
    return 1;
}
