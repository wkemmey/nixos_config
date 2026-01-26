{ pkgs, lib, ... }:

{
  # ruby development environment with common tools and gems
  
  languages.ruby = {
    enable = true;
    # use latest stable ruby by default
    version = "3.3.6";
  };

  # common ruby development packages
  packages = with pkgs; [
    # ruby tools
    rubyPackages.solargraph  # ruby language server
    rubyPackages.rubocop     # linter and formatter
    rubyPackages.reek        # code smell detector
    rubyPackages.brakeman    # security scanner
    rubyPackages.bundler-audit  # check for vulnerable gems
    
    # testing tools
    rubyPackages.rspec       # testing framework
    rubyPackages.guard       # file watcher for tests
    
    # database tools
    sqlite                   # lightweight database
    
    # additional tools
    nodejs                   # needed for some gems
  ];

  # pre-commit hooks for code quality
  pre-commit.hooks = {
    rubocop.enable = true;   # ruby linter and formatter
  };

  # environment variables
  env = {
    # ensure gems are installed in project directory
    GEM_HOME = "./.gem";
    # add gem binaries to PATH
    PATH = "./.gem/bin:$PATH";
  };

  # scripts for common tasks
  scripts = {
    # install dependencies
    setup.exec = ''
      bundle install
    '';
    
    # run with auto-reload
    dev.exec = ''
      bundle exec guard
    '';
    
    # run tests
    test.exec = ''
      bundle exec rspec
    '';
    
    # run linter
    lint.exec = ''
      bundle exec rubocop
    '';
    
    # fix linting issues
    lint-fix.exec = ''
      bundle exec rubocop -a
    '';
    
    # security audit
    audit.exec = ''
      bundle exec bundle-audit check --update
    '';
  };
}
