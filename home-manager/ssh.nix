{
  pkgs,
  config,
  lib,
  onePassPath,
  ...
}:
let
  onePassPath = "~/.1password/agent.sock";

in
{

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ${onePassPath}
      Host git
        Hostname github.com
        User git
        IdentityFile ~/.ssh/git.pub
      Host jdsgit
        Hostname github.com
        User git
        IdentityFile ~/.ssh/jdsgit.pub
      Host csportal
        Hostname portal.cs.virginia.edu
        User chk6aa
        IdentityFile ~/.ssh/csportal.pub
      Host stoicdrive
        Hostname stoic-driveway
        User root
        IdentityFile ~/.ssh/stoicdrive.pub
      Host testbench
        Hostname 192.168.1.83
        User testbencher
        IdentityFile ~/.ssh/testbench.pub
      Host pwnc
        Hostname dojo.pwn.college
        User hacker
        IdentityFile ~/.ssh/pwnc.pub
      Host ctfbox
        Hostname 10.0.0.100
        User ctf
        IdentityFile ~/.ssh/ctfbox.pub
      Host devosmp
        Hostname minecraft.devhackers.com
        User jjd
        IdentityFile ~/.ssh/devosmp.pub
      Host micro
        Hostname microserver
        User dragonhuntr
        Port 2222
        IdentityFile ~/.ssh/micro.pub
      Host exa
        Hostname exadelic
        User coherence
        Port 2323
        IdentityFile ~/.ssh/exa.pub
      Host home
        Hostname home
        User casaos
        IdentityFile ~/.ssh/home.pub
      Host remarkable
        Hostname 10.11.99.1
        User root
        IdentityFile ~/.ssh/remarkable.pub
      Host storm
        Hostname storm
        Port 51073
        User thunder
        IdentityFile ~/.ssh/storm.pub
      Host workshop
        Hostname workshop
        Port 2222
        User artisan
        IdentityFile ~/.ssh/workshop.pub
    '';
  };

  home.file.".ssh/exa.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1CRcQpkQ6XX6LKMq+Y66iphCUCC6rnOItOIVcrVXAr coherence";

  home.file.".ssh/home.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNLjqwrhMEHClWTeXJvTHp0cIfkahzj9tuLMY7aiX0Q";

  home.file.".ssh/remarkable.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZRK2CCWmsw38r6gE8kayisrao5OdApFOYnOCv2P+GY";

  home.file.".ssh/storm.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyJpKtTFcrq3lJJDD/nWKwHBQW8BIIbQ1bLc1KzsHMx";

  home.file.".ssh/workshop.pub".text =
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDnQUkWrr+LgByJdBu2CAd/unpBLXzQS24CyWT35A+QKsJAWsbzW2Q8pGYtq925vrSaOXg2j1wlfUXHV+d7tUcNNLJvrx7ijhdnWbYM552YYXXStfONviCW2erjeQpJUxHgtmsDNEaYEyuamgP845zZaU13veMCh3aPFg2ma7O/xYBHTthMSko49nDvAxWBltz2XujdyU3iLj91X62yt0DECA2aR0/v43ybA1GFeDNczfn6A3vcmMTEj+i/ICub+FC2W9gv0B0/b0K1WOwfKjk5aGck633PTKjuPJBoojQLImG9ZbPd+bICQZtf+D/VB5Bc9QnM9PWmKQueUAImsH0ss3ML2k+sy3R0SCFpgcZPuuRl4OJ2Ayzfx472KVjFBaZbRn5XcxKGy1/PHA9qg0gRLRrpvhVOJJIM8XpMyQzd1ezaZYVq2/+sKU00wBzRkCQPgdwNyDB95P7wmI3TPd9y6te0WaEn3Kn0MmM7YNdTcofwBvKDOG2oVVoHOipsjpkLUARfOArEcRIfoiBlARVZuO+i7uCY0+1RQjzMWlV7g+i75YrX2AYU9S6+M+4GdHTz1nvq0pU+VLDb32zXXwoUwv8btCMzrp5rLTZTgOneXOIbQ6A7gWcACLI4caCcmYjNtzYY7ddrWPLEMohICCmcPb2WbVCccZNIbHecgnLTiw==";

}
