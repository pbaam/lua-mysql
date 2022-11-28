CC := gcc

ifeq ($(debug), y)
    CFLAGS := -g
else
    CFLAGS := -O2 -DNDEBUG
endif

LIBS := $(LIBS) -llua -lmysqlclient -lm -ldl
CFLAGS := $(CFLAGS) -Wl,-E -Wall -Werror -fPIC

.PHONY: all clean
all: luamysql.so

luamysql: luamysql.o host.o
	$(CC) $(LIBS) -o $@ $^
luamysql.so: luamysql.o
	$(CC) -shared $(LIBS) -o $@ $<

clean:
	rm -f *.o *.so luamysql
