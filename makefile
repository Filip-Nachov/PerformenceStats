CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = Server
SRC = Server.cpp
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET)
	
install:
	install -m 755 $(TARGET) $(BINDIR)

clean:
	rm -f $(TARGET)

.PHONY: all clean install

