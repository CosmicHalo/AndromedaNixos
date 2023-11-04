const fs = require("fs"); // Or `import fs from "fs";` with ESM
const os = require("os");
const path = require("path");
const cp = require("child_process");

const userHomeDir = os.homedir();
const DIRS = [`${userHomeDir}/.config/home-manager`];

function rmDir(dirPath) {
  cp.execSync(`sudo rm -rf ${dirPath}`, { stdio: "inherit" });
}

function createDir(dirPath) {
  cp.execSync(`sudo mkdir -p ${dirPath}`, { stdio: "inherit" });
}

function createSymlink(dirPath) {
  const flakePath = `${dirPath}/flake.nix`;
  const localFlake = `${path.dirname(__dirname)}/flake.nix`;

  console.log(`Creating symlink ${localFlake} -> ${flakePath}`);

  try {
    cp.execSync(`sudo ln -t ${dirPath} -s ${localFlake}`, {
      stdio: "inherit",
    });
  } catch (e) {
    console.log(`Error creating symlink ${localFlake} -> ${flakePath}`);
  }
}

async function run() {
  DIRS.forEach((dirPath) => {
    if (fs.existsSync(dirPath)) {
      console.log(`Directory [${dirPath}] exist, deleting and recreating...`);
      rmDir(dirPath);
      createDir(dirPath);
    } else {
      console.log(`Directory ${dirPath} doesnt exist. Creating...`);
      createDir(dirPath);
    }

    createSymlink(dirPath);
  });
}

run();
