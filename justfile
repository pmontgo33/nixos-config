nrs:
  sudo nixos-rebuild switch

secrets:
  -nix-shell -p sops --run "sops secrets/secrets.yaml"

git-acp message:
  git add .
  git commit -m "{{message}}"
  git push origin master

git-cp message:
  git commit -m "{{message}}"
  git push origin master

nextcloud-pull:
  ssh root@100.71.96.74 "cd /etc/nixos && git pull https://github.com/pmontgo33/nixos-config.git"

# this is a comment
another-recipe:
  @echo 'This is another recipe.'