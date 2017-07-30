elm-package install;

rm -rf build;
mkdir build;
# first 3 args to `elm-live` delgate to `elm-make`
elm-live \
  src/Main.elm \
  --output build/elm.js \
  --debug \
  --before-build=./scripts/css.sh \
  --pushstate \
  --open
