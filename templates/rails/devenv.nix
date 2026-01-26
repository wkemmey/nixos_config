{ pkgs, lib, config, ... }:

{
  # rails development environment with postgresql, redis, and all the trimmings
  
  languages.ruby = {
    enable = true;
    # use latest stable ruby by default
    version = "3.3.6";
  };

  languages.javascript = {
    enable = true;
    npm.enable = true;
  };

  # postgresql database
  services.postgres = {
    enable = true;
    listen_addresses = "127.0.0.1";
    initialDatabases = [
      { name = "app_development"; }
      { name = "app_test"; }
    ];
  };

  # redis for caching and background jobs
  services.redis = {
    enable = true;
  };

  # common rails development packages
  packages = with pkgs; [
    # ruby tools
    rubyPackages.solargraph     # ruby language server
    rubyPackages.rubocop        # linter and formatter
    rubyPackages.rubocop-rails  # rails-specific rubocop rules
    rubyPackages.reek           # code smell detector
    rubyPackages.brakeman       # rails security scanner
    rubyPackages.bundler-audit  # check for vulnerable gems
    
    # testing tools
    rubyPackages.rspec-rails    # testing framework for rails
    rubyPackages.guard          # file watcher for tests
    
    # database tools
    postgresql                  # postgresql client tools
    
    # frontend tools
    nodejs                      # javascript runtime
    yarn                        # package manager
    
    # system dependencies commonly needed by gems
    libxml2
    libxslt
    pkg-config
    zlib
    libyaml
  ];

  # pre-commit hooks for code quality
  pre-commit.hooks = {
    rubocop.enable = true;      # ruby linter and formatter
  };

  # environment variables
  env = {
    # ensure gems are installed in project directory
    GEM_HOME = "./.gem";
    # add gem binaries to PATH
    PATH = "./.gem/bin:./node_modules/.bin:$PATH";
    # database URL
    DATABASE_URL = "postgresql://localhost/${config.services.postgres.initialDatabases[0].name}";
    # redis URL
    REDIS_URL = "redis://localhost:6379/0";
    # rails environment
    RAILS_ENV = "development";
  };

  # scripts for common rails tasks
  scripts = {
    # initial setup
    setup.exec = ''
      bundle install
      yarn install
      bin/rails db:create db:migrate db:seed
    '';
    
    # start rails server
    server.exec = ''
      bin/rails server
    '';
    
    # start rails console
    console.exec = ''
      bin/rails console
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
      bundle exec brakeman -q &&
      bundle exec bundle-audit check --update
    '';
    
    # database tasks
    db-reset.exec = ''
      bin/rails db:drop db:create db:migrate db:seed
    '';
    
    # asset compilation
    assets.exec = ''
      bin/rails assets:precompile
    '';
  };

  # devenv processes - run multiple services together
  processes = {
    rails.exec = "bin/rails server";
    # uncomment if using esbuild/webpack/vite
    # assets.exec = "bin/rails assets:watch";
  };
}
