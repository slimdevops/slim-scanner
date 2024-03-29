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


- `CONNECTOR_ID`: You can find your `CONNECTOR_ID` in the "My Registries" section of the Slim Platform.
- `SLIM_ORG_ID`: Your `SLIM_ORG_ID` can be located in the "Personal Information" section, specifically under "Organizations" in the Slim Platform.
- `SLIM_API_TOKEN`: To obtain your `SLIM_API_TOKEN`, navigate to the "Personal Information" section in the Slim Platform and then proceed to the "Tokens" subsection.  

Sign up [here](https://portal.slim.dev/login)


## About the `.circleci/config.yml` file
The Slim.AI Orb is imported into your project here along with other `orbs`, with a organization identifier and orb slug, for example `slimdevops/slim-scanner@0.0.1`. Other notable areas of the configuration include:
- `parameters` contain CircleCI Orb meta information about the Docker image intended for scanning.
- `jobs` define the execution of scans and the generation of outputs within the CircleCI environment.
- `steps` execute commands for vulnerability scanning, take a snapshot of the container image, run Xray analysis, and generate artifacts, which include the results stored in readme.html.

## CircleCI Artifacts
With each project build, the orb will generate Artifacts viewable in your CircleCI workflows. Find the JSON output of the container profile `xray.json` and vulnerability scan `vuln.json`. Begin by accessing the `readme.html` to navigate to the reports..

## Slim Community
For more information about configuring containers, vulnerability scans, or this orb example, check out the [SlimDevOps Community Discord](https://discord.com/invite/uBttmfyYNB), [SlimDevOps Community Forums](https://community.slim.ai/) and the [blog](https://www.slim.ai/blog/).
