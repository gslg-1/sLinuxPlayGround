# Executable 
TARGET = app

# Paths 
BUILDDIR = ./Build
RLSDIR = $(BUILDDIR)/release
DBGDIR = $(BUILDDIR)/debug

# Flags
DBGFLAGS += -g -DDEBUG
RLSFLAGS += -O3
CFLAGS += -v -Wall

# Files
SRCS = $(shell find ./ -type f -name *.c)
OBJS = $(notdir $(SRCS:.c=.o))

# Target
DBGOBJS = $(addprefix $(DBGDIR)/,$(OBJS))
RLSOBJS = $(addprefix $(RLSDIR)/,$(OBJS))
DBGTARGET = $(DBGDIR)/$(TARGET)
RLSTARGET = $(RLSDIR)/$(TARGET)
LOGFILE = $(DBGDIR)/log
LOG1FILE = $(DBGDIR)/log1

# Includes
#LIBS +=  Enable if needed

# Cross Compler
CC = gcc

all : release

debug : $(DBGTARGET)

$(DBGTARGET) : $(DBGOBJS)
	@echo " #######################"
	@echo " Debug Link Objects"
	@echo " #######################"
	$(CC) $(CFLAGS) $(DBGFLAGS) -o $(DBGTARGET) $^ 2 >>$(LOGFILE)
	@cat $(LOGFILE)
	@cat $(LOGFILE) | grep -i 'warning\|error\|note' >$(LOG1FILE) 

$(DBGDIR)/%.o: %.c
	@echo " #######################"
	@echo " Debug Compile Objects"
	@echo " #######################"
	@mkdir -p $(DBGDIR)
	@touch $(LOGFILE) $(LOG1FILE) 
	@> $(LOGFILE)
	@> $(LOG1FILE)
	$(CC) -c $(CFLAGS) $(DBGFLAGS) -o $@ $< 2>> $(LOGFILE)

release : $(RLSDIR)/$(TARGET) 

$(RLSTARGET): $(RLSOBJS)
	@echo " #######################"
	@echo " Release Link Objects:"
	@echo " #######################"
	$(CC) $(CFLAGS) $(RLSFLAGS) -o $(RLSTARGET) $^ 

$(RLSDIR)/%.o : %.c
	@echo " #######################"
	@echo " Release Compile Objects"
	@echo " #######################"
	@mkdir -p $(RLSDIR)
	$(CC) -c $(CFLAGS) $(RLSFLAGS) -o $@ $<

run : all
	@echo " #######################"
	@echo " Start Application"
	@echo " #######################"
	$(RLSTARGET)

clean all:
	@echo ''
	@echo 'Clean Build Directory'
	rm -fr $(BUILDDIR)
