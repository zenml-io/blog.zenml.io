#! /bin/bash
set -e

gem i bundler && bundle install

echo "Generating tags.."
python scripts/tag_generator.py
echo "Tags generated!"