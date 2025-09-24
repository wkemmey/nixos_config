
update: 
	sudo nix flake update
	
nix:
	sudo nixos-rebuild switch --flake . --impure

whit:
	sudo nixos-rebuild switch --flake /etc/nixos#whit_2022

macos:
	sudo darwin-rebuild switch --flake .#

gc: 
	# run garbage collection
	nix-collect-garbage --delete-older-than 5d

fmt:
	# format the nix files in this repo
	nix fmt ./



git add file1 file2 (etc..) to stage commits
git commit -m "commit message" to commit changes
git push remote-name branch-name to push to the remote


https://github.com/cideM/dotfiles