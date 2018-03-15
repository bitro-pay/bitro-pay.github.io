#!/usr/bin/env bash
pushd en
docker run --rm -v $PWD:/usr/src/app/source -w /usr/src/app/source apidoc_app bundle exec middleman build --clean
rm -rf ../../en/*
mv build/* ../../en/
pushd ../ko
docker run --rm -v $PWD:/usr/src/app/source -w /usr/src/app/source apidoc_app bundle exec middleman build --clean
rm -rf ../../ko/*
mv build/* ../../ko/
