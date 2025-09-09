
update: 
	sudo nix flake update
	
nix:
	sudo nixos-rebuild switch --flake . --impure

macos:
	sudo darwin-rebuild switch --flake .#

gc: 
	# run garbage collection
	nix-collect-garbage --delete-older-than 5d

fmt:
	# format the nix files in this repo
	nix fmt ./
