%Title Netctl et des choses
%Description un truc qui va ici
%Keywords un test, ici, encore
%Tags un,truc,qui,pue
%Date 201002231450

Le programme netctl est une solution légère qui peut remplacer avantageusement NetworkManager ou tout autre solution de gestion de réseau. Il ne prend pas de place et fait ce qu'on lui demande de faire. Le fonctionnement de netctl est simple: Il va gérer une liste de profils (ethernet, wifi, VPN) avec la configuration requise (dhcp, adresse statique…). Lorsqu'on active un profil, netctl va générer une unit systemd qui être utilisée pour gérer la connexion via systemd.

L'unit créée est un [template de service systemd](https://ibug.io/blog/2019/07/systemd-service-template/). Très pratique lors de la génération, mais avec un nom parfois très étrange.  

L'interface de netctl est proche de systemd : start, stop, restart, status, enable, disable, is_active, edit...

Comment créer un profil ? Très simple, il y a une multitude de cas dans `/etc/netctl/examples`. Récupérez le profil qui vous intéresse, copiez-le avec un nom explicite dans le répertoire `/etc/netctl/` et éditez pour renseigner les informations (nom de l'interface, mot de passe…).

    # netctl edit ma-connexion
    # netctl start ma-connexion

Si ça fonctionne, on active la connexion au démarrage du système.

    netctl enable ma-connexion

Et on oublie jusqu'à la prochaine fois où il faut changer les paramètres de connexion.

Pour lister les profils disponibles et démarrer un profil spécifique.

    $ netctl list
    # netctl start ethernet-dhcp

Si le profil contient un mot de passe, il faut le protéger avec un `chmod 0600`.

Plus d'informations https://wiki.archlinux.org/index.php/Netctl
