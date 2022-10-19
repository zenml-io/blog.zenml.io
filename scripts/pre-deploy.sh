#! /bin/bash
set -e


apt-get update
apt-get install ruby2.6.8
gem i bundler && bundle install

echo "Generating tags.."
# python scripts/tag_generator.py
echo "Tags generated!"
