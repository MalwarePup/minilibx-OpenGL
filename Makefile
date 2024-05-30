# Variable Definitions
SHELL := /bin/sh
NAME := libmlx.a

srcdir := ./src
bindir := ./bin
incdir := ./include

SRCS_C := mlx_shaders.c \
          mlx_xpm.c \
          mlx_png.c \
          mlx_int_str_to_wordtab.c
SRCS_M := mlx_new_window.m \
          mlx_init_loop.m \
          mlx_new_image.m \
          mlx_mouse.m

OBJS_C := $(patsubst %.c,$(bindir)/%.o,$(SRCS_C))
OBJS_M := $(patsubst %.m,$(bindir)/%.o,$(SRCS_M))
OBJS := $(OBJS_C) $(OBJS_M)
DEPS := $(OBJS_C:.o=.d) $(OBJS_M:.o=.d)

# Compilation Flags
CFLAGS += -Wall -Wextra -MMD -MP -O3 -DSTRINGPUTX11 -DGL_SILENCE_DEPRECATION
CPPFLAGS += -I$(incdir)

# Phony Targets
.PHONY: all clean fclean re directories

# Default Target
all: $(NAME)

# Directory Creation
directories: $(bindir)

$(bindir):
	@mkdir -p $@

# Object File Compilation
$(bindir)/%.o: $(srcdir)/%.c | directories
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(bindir)/%.o: $(srcdir)/%.m | directories
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# Archive Creation
$(NAME): $(OBJS)
	$(AR) -rcs $@ $^

# Cleaning Targets
clean:
	$(RM) -r $(bindir)

fclean: clean
	$(RM) $(NAME)

re: fclean all

# Include Dependency Files
-include $(DEPS)

# Suffixes Declaration
.SUFFIXES:
.SUFFIXES: .c .m .o
