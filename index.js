const core = require('@actions/core');
const github = require('@actions/github');
const exec = require('@actions/exec');
const path = require('path');

const repo = core.getInput('repo', { required: true });
const envName = core.getInput('env_name', { required: true });
const ghToken = core.getInput('gh_token', { required: true });
const fileType = core.getInput('file_type', { required: true });

async function run() {
  try {
    // core.info(`My Repo: ${repo}`);
    // Optional: pass arguments to your script
    const scriptPath =  path.join(__dirname, 'script.sh');
    // You can add listeners or env here if needed
    const options = {
      env: {
        ...process.env,
        REPO: repo,
        ENV_NAMES: envName,
        GH_TOKEN: ghToken,
        FILE_TYPE: fileType,
      }
    };

    await exec.exec('bash', [scriptPath], options);

  } catch (error) {
    core.setFailed(`Action failed: ${error.message}`);
  }
}

run();
