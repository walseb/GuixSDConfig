(use-modules (gnu) (gnu system nss) (gnu packages disk) (gnu packages admin) (gnu packages linux) (gnu packages glib) (gnu packages gl)(gnu packages libunwind)(gnu packages nettle) (gnu packages multiprecision) (gnu packages mpd) (gnu packages gnupg) (gnu packages pdf) (gnu packages compression) (gnu packages xdisorg) (gnu packages fonts) (gnu packages xorg) (gnu packages imagemagick) (gnu packages code))

(use-service-modules networking ssh)

(use-package-modules 
                     certs
                     version-control
                     xorg
                     emacs
                     aspell
                     wget
                     ssh
                     pulseaudio
                     )

(operating-system
 (host-name "guix-VM")
 (timezone "Europe/Stockholm")
 (locale "en_US.utf8")

 
 ;; Mount disk
 (file-systems (cons (file-system
                      (device (file-system-label "my-root"))
                      (mount-point "/")
                      (type "ext4"))
		     (cons (file-system
			    (device "/dev/vda1/")
			    (mount-point "/boot/efi/")
			    (type "vfat"))
			   %base-file-systems)))
 
 
 ;; (file-systems (file-system
 ;; (device "/dev/vda1/")
 ;; (mount-point "/boot/efi/")
 ;; (type "vfat")))

 ;; Use UEFI
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (target "/boot/efi")))

 ;; Use BIOS
 ;;(bootloader (bootloader-configuration
 ;;              (bootloader grub-bootloader)
 ;;              ;; VM disk
 ;;              (target "/dev/sda")))

 ;; VM support
 (initrd-modules (append (list "virtio_blk" "virtio_pci")
                         %base-initrd-modules))

 ;; Setup user
 (users (cons (user-account
               (name "admin")
               (comment "")
               (group "users")
               (supplementary-groups '("wheel" "netdev"
                                       "audio" "video"))
               (home-directory "/home/admin"))
              %base-user-accounts))

 ;; This is where we specify system-wide packages.
 (packages (cons* nss-certs         ;for HTTPS access
		  ;; Xorg
		  xorg-server
		  xinit
		  xrandr
		  xf86-input-evdev
                  setxkbmap
		  ;; Dependencies
		  dbus
		  libdrm
		  libepoxy
		  ;;libgl
		  libpciaccess
		  libunwind
		  libxfont
		  libxshmfence
		  nettle
		  pixman
		  xf86-input-libinput
		  ;; Xinit dependencies
		  inetutils
		  libx11
		  xauth
		  xmodmap
		  xrdb

                  pulseaudio
                  pavucontrol
                  emacs
		  openssh
		  imagemagick
		  the-silver-searcher
		  ;;mono
		  lm-sensors
		  poppler
		  gnupg
		  pinentry
		  redshift
		  mpd
		  mpc
		  ;;		  amixer
		  atool
		  htop
		  dosfstools
                  git
                  wget
                  aspell
                  aspell
                  aspell-dict-en
                  aspell-dict-sv
                  unzip
                  rxvt-unicode
		  ;; Xorg needs this
		  xterm
		  ;; Fonts
                  font-inconsolata
                  font-gnu-freefont-ttf
                  %base-packages))
 
 ;; Use the "desktop" services, which
 ;; include the X11 log-in service, networking with
 ;; NetworkManager, and more.
 ;; (services (cons* (gnome-desktop-service)
 ;;                  (xfce-desktop-service)
 ;;                  %desktop-services))
 ;; (services (cons*
 ;;            (dhcp-client-service)
 ;;          %desktop-services))

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
