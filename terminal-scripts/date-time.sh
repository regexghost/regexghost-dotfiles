#!/bin/sh

TZ="America/Los_Angeles" date +"Los Angeles:    %H:%M:%S - %a, %b %d (%Z)"
TZ="America/New_York" date +"New York:       %H:%M:%S - %a, %b %d (%Z)"
date -u +"UTC:            %H:%M:%S - %a, %b %d (%Z)"
TZ="Europe/London" date +"London:         %H:%M:%S - %a, %b %d (%Z)"
TZ="Europe/Paris" date +"Paris:          %H:%M:%S - %a, %b %d (%Z)"
TZ="Asia/Seoul" date +"Seoul:          %H:%M:%S - %a, %b %d (%Z)"
TZ="Australia/Sydney" date +"Sydney:         %H:%M:%S - %a, %b %d (%Z)"
