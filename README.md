[![CircleCI Build Status](https://circleci.com/gh/slimdevops/slim-scanner.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/slimdevops/slim-scanner) [![CircleCI Orb Version](https://badges.circleci.com/orbs/slimdevops/slim-scanner.svg)](https://circleci.com/orbs/registry/orb/slimdevops/slim-scanner) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/slimdevops/slim-scanner/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

# Slim Scanner Circle CI Orb
The Slim Scanner provides vulnerability scans, container profiles, and lets you to easily access these artifacts from the CircleCI pipeline. Find a collection of these images in the Slim.AI platform, to analyze overtime as you build and the project scales. 

## Requirements
- CircleCI account 
- Slim Developer Platform account (Free at [www.slim.ai](https://www.slim.ai))

## Quickstart Resources: 
- [Blog: Node.JS Example](https://www.slim.ai/blog/introducing-slim-s-scanner-orb-for-circleci)
- [GitHub Repo: Node.JS Example](https://github.com/slimdevops/orb-demo)

## Project Environment Variables
Your project will need the following environment variables added to your CircleCI environment:

```
ORG_ID=
SAAS_KEY=
CONNECTOR_ID=
```

- `ORG_ID`, and `SAAS_KEY` are found in the Slim Platform, from your Profile Settings and `CONNECTOR_ID` can be found in Connectors section, in the Tokens and Organization tabs. Sign up [here](https://portal.slim.dev/login)


## About the `.circleci/config.yml` file
The Slim.AI Orb is imported into your project here along with other `orbs`, with a organization identifier and orb slug, for example `slimdevops/slim-scanner@0.0.1`. Other notable areas of the configuration include:
- `parameters` contain CircleCI Orb meta information about the Docker image intended for scanning.
- `jobs` define the execution of scans and the generation of outputs within the CircleCI environment.
- `steps` execute commands for vulnerability scanning, take a snapshot of the container image, run Xray analysis, and generate artifacts, which include the results stored in readme.html.

## CircleCI Artifacts
With each project build, the orb will generate Artifacts viewable in your CircleCI workflows. Find the JSON output of the container profile `xray.json` and vulnerability scan `vuln.json`. Start with the `readme.html` to navigate to your collections of images and reports.

## Slim Community
For more information about configuring containers, vulnerability scans, or this orb example, check out the [SlimDevOps Community Discord](https://discord.com/invite/uBttmfyYNB), [SlimDevOps Community Forums](https://community.slim.ai/) and the [blog](https://www.slim.ai/blog/).
