#include <bits/stdc++.h>


int main(int argc, char* argv[]) {
    // ERROR HANDALING
    if (argc < 2) {
        printf("ERROR: No Arguments provided");
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
            return 0;
        }
        int result = system("./src/WinServerPerformance.ps1");
        return 0;
    }

   // UNIX SCENARIO
    if (std::string(argv[1]) == "Unix") {
        if (argc >= 3 && std::string(argv[2]) == "-NoDelay") {
            int result = system("./src/UnixServerPerformanceNoDelay.sh");
            return 0;
        }
        int result = system("./src/UnixServerPerformance.sh");
        return 0;
    } 

    printf("ERROR: Invalid OS provided.\nCorrect Usage:\nServer <Windows/Unix> < -NoDelay (optional)>\n");
    return 0;
}
