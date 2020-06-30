name: freesurfer

on:
  push:
    paths:
      - recipes/*
      - recipes/freesurfer/*
      - .github/workflows/freesurfer.yml
      - .github/workflows/build.sh

  pull_request:
    paths:
      - recipes/*
      - recipes/freesurfer/*
      - .github/workflows/freesurfer.yml
      - .github/workflows/build.sh

env:
  APPLICATION: freesurfer
  PYTHON_VER: 3.8

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
        with:
          python-version: ${{ env.PYTHON_VER }}
      - name: Run Recipe and Image builder
        run: |
          echo "${{ secrets.GITHUB_TOKEN }}" | docker login docker.pkg.github.com -u $GITHUB_ACTOR --password-stdin
          echo "${{ secrets.DOCKERHUB_PASSWORD }}" | docker login -u ${{ secrets.DOCKERHUB_USERNAME }} --password-stdin
          bash .github/workflows/build.sh
