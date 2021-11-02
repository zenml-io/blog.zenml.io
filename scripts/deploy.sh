#! /bin/bash
set -e

bundle exec jekyll build --verbose
cd _site && html-minifier --collapse-whitespace --remove-comments --remove-optional-tags --remove-redundant-attributes --remove-script-type-attributes --remove-tag-whitespace --use-short-doctype --minify-css true --minify-js true; cd ../
aws s3 sync ./_site/ s3://$AWS_BUCKET --region eu-central-1 --delete
aws s3 website s3://$AWS_BUCKET --index-document index.html --error-document 404.html  --region eu-central-1
aws cloudfront create-invalidation --distribution-id E1DGKF1NS6BPVZ --paths "/*"