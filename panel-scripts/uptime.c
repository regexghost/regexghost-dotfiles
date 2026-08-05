#include <sys/sysinfo.h>
#include <stdio.h>
#include <time.h>

int main() {
	struct sysinfo info;

	if (sysinfo(&info) != 0) {
		printf("Error");
		return 1;
	}

	int hours = info.uptime/3600;
	int minutes = (info.uptime - hours * 3600)/60;

	printf("%02d:%02d\n", hours, minutes);

	return 1;
}
