#! /bin/bash
set -e

gem update --system 3.2.3

gem i bundler && bundle install

echo "Generating tags.."
python scripts/tag_generator.py
echo "Tags generated!"