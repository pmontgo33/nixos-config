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

# this is a comment
another-recipe:
  @echo 'This is another recipe.'