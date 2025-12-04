Set-Location "C:\Users\Cooavil\ACASATOOLS"

# garante que o remote esteja apontando para o repo correto
git remote remove origin 2>$null
git remote add origin "https://github.com/pipocamen/ACASATOOLS.git"

# adiciona, commita e envia para a branch main
git add .
git commit -m "chore: sync local ACASATOOLS to GitHub"
git push -u origin main
