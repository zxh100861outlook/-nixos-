{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  # 防止efi被写爆
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  # 主机名与网络
  networking.hostName = "nixos";                  # 改成你喜欢的
  networking.networkmanager.enable = true;

  # 时区与中文支持
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    useXkbConfig = true;
  };

  # 国内加速（永久生效）
nix.settings = {
  substituters = [
    "https://mirrors.ustc.edu.cn/nix-channels/store"     # 中科大（可优先）
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清华
    "https://cache.nixos.org/"
  ];
  trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
};

  # 普通用户（务必改用户名和初始密码）
  users.users.zxh = {                            # ← 改成你的用户名
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "217578qwe";                 # 登录后立即改密码！
  };
  #字体
  fonts = {
  fontconfig.enable = true;
  fontDir.enable = true;

  packages = with pkgs; [
    jetbrains-mono
    inter
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  fontconfig.defaultFonts = {
    monospace = [ "JetBrains Mono" "Noto Sans Mono CJK SC" ];
    sansSerif = [ "Inter" "Noto Sans CJK SC" "Noto Sans" ];
    serif = [ "Noto Serif CJK SC" "Noto Serif" ];
  };
};

  environment.systemPackages = with pkgs; [
  #基本工具
    gcc			#编译器
    xev			#键值对应
    btop
    htop
    neovim
    git
    wget
    curl
    pkgs.vscode		#IDE
    pkgs.zzz		#晚安玛卡巴卡
    acpi		#电池
    gnome-disk-utility	#磁盘管理器
    vlc			#视频播放器
    baobab		#磁盘分析器器
    ranger		#终端文件管理器
    localsend		#文件传输工具
    tmux		#终端复用器
    xfce.thunar		#文件管理器
    xfce.tumbler        # 生成缩略图
    xfce.thunar-volman	#自动挂载套件
    pkgs.fastfetch	#系统信息
    pkgs.flameshot	#截图
    pkgs.cava		#把音乐/音频实时转成终端里的彩色频谱条/波形图
    #typora		#md文档编辑器
    wineWowPackages.stable	#为运行exe应用
    pkgs.obs-studio		#录屏软件
    spotify		#音乐
    sl			#小火车
    #压缩包
    unzip
    zip
    rar
    unrar
    #互联网
    pkgs. motrix		#种子下载器
    firefox
    pkgs.microsoft-edge
    #gtk
    nwg-look		#gtk管理器
    tela-icon-theme
    papirus-icon-theme	#gtk图标
    (catppuccin-gtk.override { variant = "mocha"; accents = ["yellow"]; }) #gtk组件主题
    bibata-cursors	#光标
    simp1e-cursors
  ];
  # fcitx 输入法
   i18n.inputMethod = {
   type = "fcitx5";
   enable = true;
   fcitx5.addons = with pkgs; [
     qt6Packages.fcitx5-chinese-addons  # 使用拼音输入法
     fcitx5-mozc
     fcitx5-gtk
   ];
 };
  # 桌面环境（根据下载的 ISO 启用一个）
  
  # KDE Plasma
  # services.desktopManager.plasma6.enable = true;
  #i3wm
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi				#rofi程序启动器
        polybar 			#状态栏
        i3blocks			#锁屏
        alacritty			#终端
	picom				#用来调模糊透明度的
	feh				#壁纸
	pavucontrol	  		#音量调节
	xfce.xfce4-power-manager	#亮度控制
     ];
    };
  };

  programs.i3lock.enable = true; #default i3 screen locker
  # 输入法环境变量
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE   = "fcitx";
    XMODIFIERS    = "@im=fcitx";
  };
  #启动U盘自动挂载
  services.udisks2.enable = true;
  # 开启gvf（让 Thunar 能看到设备图标和自动挂载）
  services.gvfs = {
    enable = true;
    # 如果你有 MTP 设备（如安卓手机）或需要更多后端，可以加这些
    # package = pkgs.gvfs;  # 默认就行
  };
  #lightdm
  services.xserver.displayManager.lightdm.enable = true;
  # SSH 服务
  services.openssh.enable = true;
  # 安装非自由软件
  nixpkgs.config.allowUnfree = true;
  # 限制世代数量
  boot.loader.systemd-boot.configurationLimit = 15;  # 只保留最新的 15 个世代
  # 系统版本（当前最新稳定版 25.11）
  system.stateVersion = "25.11";
}
