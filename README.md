[![CircleCI Build Status](https://circleci.com/gh/slimdevops/slim-scanner.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/slimdevops/slim-scanner) [![CircleCI Orb Version](https://badges.circleci.com/orbs/slimdevops/slim-scanner.svg)](https://circleci.com/orbs/registry/orb/slimdevops/slim-scanner) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/slimdevops/slim-scanner/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

# Slim Scanner Circle CI Orb
The Slim Scanner is a powerful integration tool designed to bring automated security analysis directly into your CI/CD pipeline. With every container build, this orb provides vulnerability scans and container profiles, allowing you to easily access these artifacts from the CircleCI pipeline. As you build and your project scales, all these images and their associated data are available on the Slim platform for in-depth analysis over time.

## Requirements
- CircleCI account 
- Slim Developer Platform account (Free at [www.slim.ai](https://www.slim.ai))

## Quickstart Resources: 
- [Blog: Node.JS Example](https://www.slim.ai/blog/introducing-slim-s-scanner-orb-for-circleci)
- [GitHub Repo: Node.JS Example](https://github.com/slimdevops/orb-demo)

## Project Environment Variables
Your project will need the following environment variables added to your CircleCI environment:

- `CONNECTOR_ID`: You can find your `CONNECTOR_ID` in the "My Registries" section of the Slim Platform.
- `SLIM_ORG_ID`: Your `SLIM_ORG_ID` can be located in the "Personal Information" section, specifically under "Organizations" in the Slim Platform.
- `SLIM_API_TOKEN`: To obtain your `SLIM_API_TOKEN`, navigate to the "Personal Information" section in the Slim Platform and then proceed to the "Tokens" subsection.  

Sign up [here](https://portal.slim.dev/login)


## About the `.circleci/config.yml` file
The Slim.AI Orb is imported into your project here along with other `orbs`, with a organization identifier and orb slug, for example `slimdevops/slim-scanner@0.0.5`. Other notable areas of the configuration include:
- `parameters` contain CircleCI Orb meta information, including details about the Docker image specifications.
- `jobs` oversee the scan execution and output generation within the CircleCI environment. Within jobs, `steps` detail the specific commands, from vulnerability scanning and image snapshot creation to Xray analysis and artifact generation.
- `workflows` dictate the sequence and conditions under which jobs are run.


## CircleCI Artifacts
With each project build, the orb will generate Artifacts viewable in your CircleCI workflows. Discover the JSON output of the container profile (`xray.json`) and vulnerability scan (`vuln.json`). To view the analyses, click on the readme.html and navigate to the Slim's dashboard & vulnerabilities tab in the portal. 

## Slim Community
For more information about configuring containers, vulnerability scans, or this orb example, check out the [SlimDevOps Community Discord](https://discord.com/invite/uBttmfyYNB), [SlimDevOps Community Forums](https://community.slim.ai/) and the [blog](https://www.slim.ai/blog/).
