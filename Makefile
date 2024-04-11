SRC_DIR := ./src_cuda
APP_DIR := ./apps
MAIN_SRC := $(APP_DIR)/reprlearn/reprlearnmain.cpp  # Path to the main source file

DEPS 		:= $(SRC_DIR)/Pop.h $(SRC_DIR)/Prj.h $(SRC_DIR)/Globals.h $(SRC_DIR)/Pats.h $(SRC_DIR)/Parseparam.h $(SRC_DIR)/Logger.h
OBJS 		:= $(SRC_DIR)/Pop.o $(SRC_DIR)/Prj.o $(SRC_DIR)/Globals.o $(SRC_DIR)/Pats.o $(SRC_DIR)/Parseparam.o $(SRC_DIR)/Logger.o

MAIN_OBJ := $(MAIN_SRC:.cpp=.o)  # Converts .cpp to .o for the main program

NVCC := nvcc
CXX := g++
MPICXX := mpicxx

INCLUDES := -I$(SRC_DIR) -I/usr/include/x86_64-linux-gnu/mpich
FLAGS	:= -O3
NVCCFLAGS := -x cu -std=c++11 -g
CXXFLAGS :=
LDFLAGS := -L/usr/local/cuda/lib64 -lcudart -lcublas -lcurand

# Add a compilation rule for the main program source file
$(MAIN_OBJ): $(MAIN_SRC)
	$(MPICXX) -c $< -o $@ $(INCLUDES)

# Compile other .cpp files with C++
%.o: %.cpp $(DEPS)
	$(NVCC) $(NVCCFLAGS) -c $< -o $@ $(INCLUDES) $(FLAGS)

# Linking
reprlearn:$(APP_DIR)/reprlearn/reprlearnmain.o $(OBJS)
	$(MPICXX) -o $(APP_DIR)/reprlearn/reprlearnmain $^ $(LDFLAGS) $(INCLUDE) $(FLAGS)

.PHONY: all clean

all: reprlearn

clean:
	rm -f *.o *.bin *.log *.png *.gif *.out out.txt err.txt *~ core reprlearnmain
	rm -f $(SRC_DIR)/*.o $(SRC_DIR)/*.bin $(SRC_DIR)/*~
	rm -f $(APP_DIR)/reprlearn/*.o $(APP_DIR)/reprlearn/*~ $(APP_DIR)/reprlearn/reprlearnmain