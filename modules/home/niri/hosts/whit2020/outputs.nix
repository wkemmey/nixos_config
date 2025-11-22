{ host, ... }:
''
  // Host-specific output configuration for whit2020
  // Configure your monitors here

  output "HDMI-A-1" {
    mode "3840x2160"
    scale 2.0
    position x=0 y=0
  }

  // Add more outputs as needed
  // output "HDMI-A-1" {
  //   mode "2560x1440@144.000"
  //   scale 1.0
  //   position x=1920 y=0
  // }
''
