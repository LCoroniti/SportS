//
// Created by laura on 03.02.2024.
//
#include <stdio.h>
#include <windows.h>
#include <mmsystem.h>
#include "sound.h"

void whistle() {
    PlaySound(TEXT("whistle.wav"), NULL, SND_FILENAME);
}