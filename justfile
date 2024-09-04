nrs:
  sudo nixos-rebuild switch

secrets:
  -nix-shell -p sops --run "sops secrets/secrets.yaml"

git-acp:
  git add .
  git commit -m >
  git push origin master

# this is a comment
another-recipe:
  @echo 'This is another recipe.'