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

# Includes
#LIBS +=  Enable if needed

# Cross Compler
CC = gcc

all : release

debug : $(DBGTARGET)

$(DBGTARGET) : $(DBGOBJS)
	@echo " #######################"
	@echo " Compile Objects"
	@echo " #######################"
	$(CC) $(CFLAGS) $(DBGFLAGS) -o $(DBGDIR)/$(TARGET) 

$(DBGDIR)/%.o: %.c
	@echo " #######################"
	@echo " Compile Objects"
	@echo " #######################"
	@mkdir -p $(DBGDIR)
	$(CC) -c $(CFLAGS) $(DBGFLAGS) -o $@ $<

release : $(RLSDIR)/$(TARGET) 

$(RLSTARGET): $(RLSOBJS)
	@echo " #######################"
	@echo " Link Objects:"
	@echo " #######################"
	$(CC) $(CFLAGS) $(RLSFLAGS) -o $(RLSDIR)/$(TARGET) $^

$(RLSDIR)/%.o : %.c
	@echo " #######################"
	@echo " Compile Objects"
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
	rm -fr $(BUILD_PATH)
