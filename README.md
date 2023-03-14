[![CircleCI Build Status](https://circleci.com/gh/slimdevops/slim-scanner.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/slimdevops/slim-scanner) [![CircleCI Orb Version](https://badges.circleci.com/orbs/slimdevops/slim-scanner.svg)](https://circleci.com/orbs/registry/orb/slimdevops/slim-scanner) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/slimdevops/slim-scanner/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

# Slim Scanner Circle CI Orb
This public Orb from Slim.AI runs a vulnerability scan, creates a container profile, and makes a report for you to easily access these artifacts from the CircleCI pipeline. Find a collection of these images in the Slim.AI platform, to analyze overtime as you build and the project scales. 

## Requirements
- CircleCI account 
- Slim Developer Platform account (Free at [www.slim.ai](https://www.slim.ai))

## Quickstart Resources: 
- [Blog: Node.JS Example](https://www.slim.ai/blog/introducing-slim-s-scanner-orb-for-circleci)
- [GitHub Repo: Node.JS Example](https://github.com/slimdevops/orb-demo)

## Project Environment Variables
Your project will need the following environment variables added to your CircleCI environment:

```
DOCKERHUB_PASSWORD=
DOCKERHUB_USERNAME=
FAV_COLLECTION_ID=
ORG_ID=
SAAS_KEY=
```

- `DOCKERHUB_PASSWORD` and `DOCKERHUB_USERNAME` are your Docker Hub credentials. Sign up [here](https://hub.docker.com/signup)
- `FAV_COLLECTION_ID`, `ORG_ID`, and `SAAS_KEY` are found in the Slim Platform, from your Profile Settings, in the Tokens and Organization tabs. Sign up [here](https://portal.slim.dev/login)


## About the `.circleci/config.yml` file
The Slim.AI Orb is imported into your project here along with other `orbs`, with a organization identifier and orb slug, for example `slimdevops/slim-scanner@0.0.1`. Other notable areas of the configuration include:
- `parameters` contain CircleCI Orb meta information about the Docker image and connector used by Slim.AI
- `jobs` defines `publishLatestToHub` which runs the scans and creates artifacts to be stored in Slim Platform
- `steps` run commands for vulnerability scan,  takes a snapshot of the container image, and generates artifacts including the results contained in `readme.html`

## CircleCI Artifacts
With each project build, the orb will generate Artifacts viewable in your CircleCI workflows. Find the JSON output of the container profile `XRay.json` and vulnerability scan `vuln.json`. Start with the `readme.html` to navigate to your collections of images and reports.

## Slim Community
For more information about configuring containers, vulnerability scans, or this orb example, check out the [SlimDevOps Community Discord](https://discord.com/invite/uBttmfyYNB), [SlimDevOps Community Forums](https://community.slim.ai/) and the [blog](https://www.slim.ai/blog/).
