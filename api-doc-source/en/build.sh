#!/usr/bin/env bash
docker run --rm -v $PWD:/usr/src/app/source -w /usr/src/app/source apidoc_app bundle exec middleman build --clean
