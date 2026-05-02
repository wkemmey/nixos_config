# TODO

- [ ] Print test page once a week
- [ ] keyboard command to shutdown
- microphone not working
- 1password
- way to set credentials on google, etc
- are all files in hosts still useful
- clean up variables
- clean up comments
- make some webapps
- install helix
- install ai tools
- install dropbox (can i put it on different drive)
- set up rust and python dev environments
- get steam working
- setup AGENTS.md
- check each file in /etc/profiles/per-user/whit/bin -- do i want it?
- ensure xbox controller is working
- nordvpn
- mtg arena
- distrobox
- slack app
- what else from windows install?
- bluetooth headphones
- connect to ntfs hard drives
- godot & vscode plugins, mcp?
- plymouth start up graphics--maria?

- create rust directory merger project

- dev shell for python, ruby, ruby on rails, rust



 ---

 i need to theme firefox and everything else


 do i want to use any of the templates from the matugen themes github

 i need to see why fixes didn't resolve boot errors




 Looking at your system, here are some good candidates for matugen integration:

Already Integrated ✅
Noctalia (shell/bar)
Niri (compositor borders/focus)
Foot (terminal)
Fuzzel (launcher - via emoji picker)
VS Code
Fastfetch (system info)
Firefox (via Pywalfox)
gtk (thunar, gedit)

Worth Integrating

Helix - Your helix editor could match
Yazi - File manager colors
Btop/Bottom/Htop - System monitors
Bat - Code viewer
Starship - Prompt colors (though it already has some theming)

Lower Priority:

Lazygit - Git TUI colors

The most effective way to hide an app from Noctalia (and almost any other launcher like Fuzzel or Rofi) is to set NoDisplay=true in its .desktop file. On NixOS, you don't edit these files directly in /usr/share/applications/; you use Home Manager or a Nix override.  

Using Home Manager (Recommended)

You can use xdg.desktopEntries to "shadow" an existing app and hide it:
Nix

xdg.desktopEntries = {
  "program-name-to-hide" = {
    name = "Program Name";
    noDisplay = true; # This is the magic line
  };
};

Note: The attribute name (e.g., "program-name-to-hide") must match the filename of the original .desktop file without the extension.





troubleshoot errors:
journalctl -b -1 -t niri -t noctalia


software that i currently use in windows:
epic games
slack
gog
battle.net
wmware
calibre
mtg arena
calculator
anki
epson printer software
adobe
imazing
turbotax
davinci or similar

don't forget to save my wallpaper dump from pictures





Developing Rust on NixOS for Windows is actually quite streamlined because of how Nix handles toolchains. You'll be **cross-compiling**, meaning you build the `.exe` file on Linux and then just move it to Windows to run.

The easiest way to do this is using the **MinGW** target (`x86_64-pc-windows-gnu`), which doesn't require a Windows-specific linker.

---

### 1. Create a Development Shell

Instead of installing Rust globally, create a `shell.nix` in your project folder. This ensures you have the cross-compiler and the correct Rust target every time you enter that folder.

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    rustup
    # The MinGW cross-compiler for Windows
    pkgsCross.mingwW64.stdenv.cc
  ];

  shellHook = ''
    # Add the Windows target if you don't have it
    rustup target add x86_64-pc-windows-gnu
  '';
}

```

### 2. Configure the Linker

Rust needs to know which linker to use for Windows. Create a `.cargo/config.toml` file in your project root:

```toml
[target.x86_64-pc-windows-gnu]
linker = "x86_64-w64-mingw32-gcc"
ar = "x86_64-w64-mingw32-ar"

```

### 3. Build the Program

Now, simply enter your shell and build for the Windows target:

1. Open your terminal and type `nix-shell`.
2. Run the build command:
```bash
cargo build --target x86_64-pc-windows-gnu --release

```



### 4. Locate and Run

Your Windows executable will be waiting for you at:
`target/x86_64-pc-windows-gnu/release/your_program_name.exe`

You can now copy this `.exe` to any Windows machine (via your newly synced **Dropbox**!) and it will run natively.

---

### Why not the MSVC target?

You might see `x86_64-pc-windows-msvc` mentioned online. **Avoid this for cross-compilation.** The MSVC target requires proprietary Microsoft linkers and libraries that are very difficult to legally or technically package on Linux. The `gnu` target (MinGW) produces high-performance binaries that work perfectly on standard Windows installs.

---

### Pro-Tip: Static Linking

If your program uses external C libraries, Windows might complain about missing `.dll` files. To bake everything into a single "portable" `.exe`, add this to your `.cargo/config.toml`:

```toml
[target.x86_64-pc-windows-gnu]
rustflags = ["-C", "target-feature=+crt-static"]

```

**Would you like me to help you set up a Nix Flake for this instead, if you prefer the modern Nix approach over `nix-shell`?**

[Rust Cross-Compilation Tutorial](https://www.youtube.com/watch?v=YWh06kGvxjo)
This video provides a visual walkthrough of setting up cross-compilation for various platforms including Windows, which can help clarify the workflow.


consider replacing dropbox with https://www.hetzner.com/storage/storage-share/ and cryptomator

but for now, once we move to other machine, let's try maestro instead of dropbox

make sure the style guide is applied to all files

i want to make it so only a few wallpapers are stored in my nixos config, but noctalia looks in my dropbox folder if it's present. this is so the repo doesn't get polluted with hundreds of large files, and so not all my wallpaper choices are public.  the ones in the repo are just there if the dropbox isn't ready yet, or someone else is using my repo






for project with maria:

Since you are a programmer and want to mentor your friend in **VS Code** using **GitHub Copilot**, you should aim for a stack that minimizes "boilerplate friction" while still teaching the mental model of how the web works.

For 2026, the best "Vibe Coding" stack for a beginner on Linux is **Python + FastAPI + SQLite + Tailwind CSS**.

### Why this stack?

* **FastAPI > Flask:** Copilot is *much* better at FastAPI because the **Type Hints** give the AI clear context. In Flask, Copilot often guesses what's in a request; in FastAPI, it *knows* because of Pydantic models.
* **SQLite:** It’s just a file. No `sudo apt install postgres` or managing services. It’s perfect for a beginner's mental model: "The data is in this file."
* **Tailwind via CDN:** No NPM, no Webpack, no build steps. You just drop a `<script>` tag in the HTML and start "vibing" with CSS classes.

---

### The Setup (Inside VS Code)

#### 1. The Essential Extensions

Make sure these are installed to give your friend the best feedback loop:

* **GitHub Copilot & Copilot Chat:** The "brains."
* **SQLite Viewer:** Allows your friend to click the `.db` file and see the tables visually inside VS Code.
* **Python (Microsoft):** For linting and environment management.

#### 2. The Project Structure

Keep it dead simple. One file for logic, one folder for templates.

```text
my-vibe-app/
├── main.py          # The Backend & API
├── database.db      # The SQLite file (auto-generated)
└── templates/
    └── index.html   # The Frontend (Jinja2 + Tailwind)

```

---

### How to "Vibe Code" this together

Since you're the mentor, guide them to use **Copilot Chat (Ctrl+Shift+I)** to generate the "scaffold."

**The Starter Prompt:**

> "I want to build a dynamic website using FastAPI, SQLite (SQLAlchemy), and Jinja2 templates. Create a simple 'Wishlist' app where I can add items and descriptions. Use Tailwind CSS for the UI via CDN. Keep everything in a simple structure."

#### Why this is great for a non-programmer:

1. **Readability:** FastAPI code looks like plain English (`@app.get("/")`).
2. **Instant Docs:** Tell them to go to `localhost:8000/docs`. Their eyes will light up when they see the interactive API explorer that FastAPI builds automatically.
3. **The "CSS Vibe":** Because you’re using Tailwind, they can tell Copilot: *"Make the cards look like glassmorphism with a purple glow,"* and it will just work without them touching a `.css` file.

### One "Pro" Tip for Linux

Since you're on Linux, show them **`uv`**. It’s the 2026 standard for Python tooling (fast, single-binary).
Instead of teaching them `venv` and `pip`, just run:
`uv run main.py`
It will handle the environment and dependencies automatically in the background.

---

**Would you like me to generate a one-file "Starter Template" for this stack that you can paste into VS Code right now?**





need to get dropbox working, or change to maestral
set up plymouth (try again to get rid of errors first)
set up godot, plus godot vscode extensions
create devenv for godot
update rust devenv
set noctalia to change wallpaper only, not call hook
set fuzzel to change theme, one of which is material via mutagen (old hook), set hot key, maybe include mutagen styles (like fruit salad)
just include a few wallpapers in git repo, but discover wallpapers on disk in dropbox if there