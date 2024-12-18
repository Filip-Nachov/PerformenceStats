#include <bits/stdc++.h>


int main(int argc, char* argv[]) {
    // ERROR HANDALING
    if (argc < 2) {
        printf("ERROR: No Arguments provided\n");
        return 0;
    } 
    if (std::string(argv[1]) == "-NoDelay") {
        printf("ERROR: Incorrect usage\nCorrect Usage:\nServer <OS> < -NoDelay (optional)>");
        return 0;
    }


    // WIN SCENARIO
    if (std::string(argv[1]) == "Windows" || std::string(argv[1]) == "Win") {
        if (argc >= 3 && std::string(argv[2]) == "-NoDelay") {
            int result = system("powershell ./src/WinServerPerformanceNoDelay.ps1");
            if (result != 0) {
                printf("ERROR: Failed to execute script.\n");
            }
            return 0;
        }
        int result = system("./src/WinServerPerformance.ps1");
        if (result != 0) {
                printf("ERROR: Failed to execute script.\n");
            }
        return 0;
    }

   // LINUX SCENARIO
    if (std::string(argv[1]) == "Linux" || std::string(argv[1]) == "Lin") {
        if (argc >= 3 && std::string(argv[2]) == "-NoDelay") {
            int result = system("./src/LinuxServerPerformanceNoDelay.sh");
            if (result != 0) {
                printf("ERROR: Failed to execute script.\n");
            }
            return 0;
        }
        int result = system("./src/LinuxServerPerformance.sh");
        if (result != 0) {
                printf("ERROR: Failed to execute script.\n");
        }
        return 0;
    } 

    printf("ERROR: Invalid OS provided.\nCorrect Usage:\nServer <Windows/Unix> < -NoDelay (optional)>\n");
    return 0;
}
