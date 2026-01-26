{ pkgs, lib, ... }:

{
  # python development environment with common tools and packages
  
  languages.python = {
    enable = true;
    # use latest stable python by default
    version = "3.12";
    
    # use venv for package isolation
    venv.enable = true;
    venv.requirements = ''
      # common development dependencies
      pytest>=7.4.0
      pytest-cov>=4.1.0
      pytest-asyncio>=0.21.0
      black>=23.7.0
      ruff>=0.0.285
      mypy>=1.5.0
      ipython>=8.14.0
      ipdb>=0.13.13
      
      # common utility libraries
      requests>=2.31.0
      python-dotenv>=1.0.0
      
      # add your project-specific requirements here
    '';
  };

  # common python development packages
  packages = with pkgs; [
    # python tools
    python312Packages.pylint     # linter
    python312Packages.autopep8   # formatter
    ruff                         # fast linter/formatter
    
    # language servers
    pyright                      # python LSP
    
    # debugging and profiling
    python312Packages.debugpy    # debugger for vscode
    
    # system dependencies commonly needed by python packages
    libffi
    openssl
    zlib
  ];

  # pre-commit hooks for code quality
  pre-commit.hooks = {
    black.enable = true;         # python formatter
    ruff.enable = true;          # python linter
    mypy.enable = true;          # type checker
  };

  # environment variables
  env = {
    # make sure venv python is used
    VIRTUAL_ENV = ".venv";
    # add venv binaries to PATH
    PATH = ".venv/bin:$PATH";
    # python unbuffered output
    PYTHONUNBUFFERED = "1";
  };

  # scripts for common tasks
  scripts = {
    # install dependencies
    setup.exec = ''
      pip install -r requirements.txt
    '';
    
    # run tests with coverage
    test.exec = ''
      pytest --cov
    '';
    
    # run tests with watching
    test-watch.exec = ''
      pytest-watch
    '';
    
    # format code
    fmt.exec = ''
      black .
      ruff check --fix .
    '';
    
    # lint code
    lint.exec = ''
      ruff check .
      mypy .
    '';
    
    # type check
    typecheck.exec = ''
      mypy .
    '';
    
    # interactive python shell
    shell.exec = ''
      ipython
    '';
    
    # freeze requirements
    freeze.exec = ''
      pip freeze > requirements.txt
    '';
  };
}
