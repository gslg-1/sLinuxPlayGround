# Executable 
TARGET = app

# Paths 
BUILDDIR = out
RLSDIR = $(BUILDDIR)/release
DBGDIR = $(BUILDDIR)/debug

# Includes
LIBS += -lbluetooth

# Flags
LFLAGS += -Wl,-Map,$(DBGTARGET).map
AFLAGS +=
PFLAGS += 
CFLAGS += -Wall -pedantic
DBGFLAGS +=-g3
RLSFLAGS +=-O3 -Werror 

# Files
INCS = $(dir $(shell find . -type f -name *.h))
SRCS = $(shell find . -type f -name *.c)
PCCS = $(notdir $(SRCS:.c=.e))
OBJS = $(notdir $(PCCS:.e=.o))

# Target
BAREOBJS = $(basename $(OBJS))
DBGOBJS = $(addprefix $(DBGDIR)/,$(OBJS))
DBGPCCS = $(addprefix $(DBGDIR)/,$(PCCS))
RLSOBJS = $(addprefix $(RLSDIR)/,$(OBJS))
DBGTARGET = $(DBGDIR)/$(TARGET)
RLSTARGET = $(RLSDIR)/$(TARGET)


# Cross Compler
CC = gcc

all : release

debug : $(DBGTARGET)

test: 
	@echo "Target:    $(DBGTARGET)"
	@echo "DBG Objs:  $(DBGOBJS)"
	@echo "SRC:       $(SRCS)"
	@echo "INC:       $(INCS)"
	@echo "-I$(INCS)"
	@echo "OBJS:      $(OBJS)"
	@echo "LIBS:      $(LIBS)"
	@echo "Check" 		$(DBGDIR)/%.o
	@echo "basename" 	$(BAREOBJS)


$(DBGDIR)/%.e: $(SRCS)
	@echo "Pre-process:" $^
	mkdir -p $(DBGDIR)
	$(CC) $(DBGFLAGS) -I$(INCS) $< -o $@ -E
	
%.s : $(SRCS)
	@echo "Compile:" $^
	mkdir -p $(DBGDIR)
	$(CC) $(DBGFLAGS) $(LIBS) -I$(INCS) $< -o $@ -S $(CFLAGS)

%.o : %.s
	@echo "Asseble:" $^
	$(CC) $(DBGFLAGS) $< -o $@ -c 

$(DBGTARGET) : $(DBGOBJS)
	@echo "Link:" $^
	$(CC) $(DBGFLAGS) $(LIBS) $^ -o $@ $(LFLAGS)

	
release : $(RLSDIR)/$(TARGET) 

$(RLSTARGET): $(RLSOBJS)
	@echo "\nRelease Link Objects:\n"
	$(CC) $(CFLAGS) $(RLSFLAGS) $^ -o $@ 

$(RLSOBJS) : $(SRCS)
	@echo "\nRelease Compile Objects\n"
	@mkdir -p $(RLSDIR)
	$(CC) -c $(CFLAGS) $(RLSFLAGS) $^ -o $@ 

run : all
	@echo "\nStart Application\n"
	$(RLSTARGET)

clean all:
	@echo ''
	@echo 'Clean Build Directory'
	rm -fr $(BUILDDIR)
