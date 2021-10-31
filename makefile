#
TARGET = 'ubuntu'

# Paths 
BUILD_PATH = './Build'

# Cross Compler
CC = gcc


all : $(TARGET) 

$(TARGET) :
	@echo 'Create Executabel:'
	@mkdir -p $(BUILD_PATH)
	gcc -v -o $(BUILD_PATH)/$(TARGET) main.c 

run : all
	@echo 'Run Application'
	$(BUILD_PATH)/$(TARGET)

clean :
	@echo 'Clean Build Directory'
	rm -fr $(BUILD_PATH)
