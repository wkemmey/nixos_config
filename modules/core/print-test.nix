{
  config,
  lib,
  pkgs,
  host,
  ...
}:
let
  variables = import ../../hosts/${host}/variables.nix;
  # printer identity (network IPP Everywhere / AirPrint printer, via mDNS)
  printerName = "EPSON_ET-4850";
  printerUri = "dnssd://EPSON%20ET-4850%20Series._ipp._tcp.local/";
  # PostScript test page converted to PDF at build time. ghostscript is a
  # build-time-only dependency; CUPS prints the PDF natively, so the target
  # system does not need ghostscript installed.
  testPage = pkgs.runCommand "print-head-test-page.pdf" {
    nativeBuildInputs = [ pkgs.ghostscript ];
  } ''
    ${pkgs.ghostscript}/bin/ps2pdf ${./print-test-page.ps} "$out"
  '';
in
{
  config = lib.mkIf (variables.enablePrintMaintenance or false) {
    # Declaratively define the printer queue so the weekly job has a stable,
    # known target that survives rebuilds.
    hardware.printers.ensurePrinters = [
      {
        name = printerName;
        deviceUri = printerUri;
        model = "everywhere"; # IPP Everywhere / AirPrint (driverless)
        description = "Epson ET-4850 (network)";
      }
    ];

    systemd.services.print-head-maintenance = {
      description = "Print a weekly color test page to keep inkjet heads from drying";
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        set -u
        # clear any previously queued maintenance pages, then queue a fresh one
        ${pkgs.cups}/bin/cancel -a ${printerName} 2>/dev/null || true
        ${pkgs.cups}/bin/lp -d ${printerName} ${testPage}
      '';
    };

    systemd.timers.print-head-maintenance = {
      description = "Weekly print head maintenance";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "Mon 20:00";
        Persistent = true;
        RandomizedDelaySec = "30min";
      };
    };
  };
}
