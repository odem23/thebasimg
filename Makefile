
# --- Configuration --------------- #
NAME = paho.mqtt.c
PAHO_URL = "https://github.com/eclipse/paho.mqtt.c.git"


# --- Default targets --------------- #
.PHONY: all clean pull build install uninstall
default: all

# --- Setup targets --------------- #
clean:
	sudo rm -rf $(NAME)

all: build

pull:
ifeq ($(wildcard $(NAME)/*),)
	git clone $(PAHO_URL)
endif

build: pull
	make -C $(NAME)/ build

install:
	sudo make -C $(NAME)/ install

uninstall: pull
	sudo make -C $(NAME)/ uninstall

