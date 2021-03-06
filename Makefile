GAME_NAME = deeper

GODOT = godot-headless

all: linux html5 windows osx

build_dir:
	@mkdir -p build/$(GAME_NAME)-linux
	@mkdir -p build/$(GAME_NAME)-windows
	@mkdir -p build/$(GAME_NAME)-html5
	@mkdir -p build/$(GAME_NAME)-osx

icon.ico: icon.png
	convert -background transparent icon.png -define icon:auto-resize=16,32,64,256 icon.ico

linux: build_dir
	$(GODOT) --export "Linux/X11" build/$(GAME_NAME)-linux/$(GAME_NAME)

windows: build_dir icon.ico
	$(GODOT) --export "Windows Desktop" build/$(GAME_NAME)-windows/$(GAME_NAME).exe

osx: build_dir
	$(GODOT) --export "Mac OSX" build/$(GAME_NAME)-osx/$(GAME_NAME)-osx.zip

html5: build_dir
	$(GODOT) --export "HTML5" build/$(GAME_NAME)-html5/index.html

itch:
	butler push build/$(GAME_NAME)-linux/ seebass22/$(GAME_NAME):linux-x86_64
	butler push build/$(GAME_NAME)-windows/ seebass22/$(GAME_NAME):windows-x86_64
	butler push build/$(GAME_NAME)-html5/ seebass22/$(GAME_NAME):html5
	butler push build/$(GAME_NAME)-osx/ seebass22/$(GAME_NAME):osx
