# Package building
This folder contains tools used to create `rpm` and `deb` packages. 

## Requirements
 - A system with Docker.
 - Internet connection (to download the docker images the first time).

## Builders

### Tarball

To system packages (deb and rpm), a tarball of Cyb3rhq dashboard `.tar.gz` is required.
This tarball contains the [Cyb3rhq plugin][cyb3rhq-plugin], the [Cyb3rhq Security plugin][cyb3rhq-security-plugin], 
a set of OpenSearch plugins and the default configuration for the app. 

The `generate_base.sh` script generates a `.tar.gz` file using the following inputs:
- `-a` | `--app`: URL to the zipped Cyb3rhq plugin.*
- `-b` | `--base`: URL to the Cyb3rhq dashboard `.tar.gz`, as generated with `yarn build --skip-os-packages --release`.*
- `-s` | `--security`: URL to the zipped Cyb3rhq Security plugin, as generated with `yarn build`.*
- `-v` | `--version`: the Cyb3rhq version of the package.
- `-r` | `--revision`: [Optional] Set the revision of the build. By default, it is set to 1.
- `-o` | `--output` [Optional] Set the destination path of package. By default, an output folder will be created in the same directory as the script.

*Note:* use `file://<absolute_path>` to indicate a local file. Otherwise, the script will try to download the file from the given URL.

Example:
```bash
bash generate_base.sh \
    --app https://packages-dev.wazuh.com/pre-release/ui/dashboard/cyb3rhq-4.6.0-1.zip \
    --base file:///home/user/cyb3rhq-dashboard/target/opensearch-dashboards-2.4.1-linux-x64.tar.gz \
    --security file:///home/user/cyb3rhq-security-dashboards-plugin/build/security-dashboards-2.4.1.0.zip \
    --version 4.6.0
```

### DEB

The `launcher.sh` script generates a `.deb` package based on the previously generated `.tar.gz`. 
A Docker container is used to generate the package. It takes the following inputs:
- `-v` | `--version`: the Cyb3rhq version of the package.
- `-p` | `--package`: the location of the `.tar.gz` file. It can be a URL or a PATH, with the format `file://<absolute_path>`
- `-r` | `--revision`: [Optional] Set the revision of the build. By default, it is set to 1.
- `-o` | `--output` [Optional] Set the destination path of package. By default, an output folder will be created in the same directory as the script. 
- `--dont-build-docker`: [Optional] Locally built Docker image will be used instead of generating a new one.

Example:
```bash
bash launcher.sh \
    --version 4.6.0 \
    --package file:///home/user/cyb3rhq-dashboard/dev_tools/build_packages/base/output/cyb3rhq-dashboard-4.6.0-1-linux-x64.tar.gz
```

### RPM

The `launcher.sh` script generates a `.rpm` package based on the previously generated `.tar.gz`. 
A Docker container is used to generate the package. It takes the following inputs:
- `-v` | `--version`: the Cyb3rhq version of the package.
- `-p` | `--package`: the location of the `.tar.gz` file. It can be a URL or a PATH, with the format `file://<absolute_path>`
- `-r` | `--revision`: [Optional] Set the revision of the build. By default, it is set to 1.
- `-o` | `--output` [Optional] Set the destination path of package. By default, an output folder will be created in the same directory as the script. 
- `--dont-build-docker`: [Optional] Locally built Docker image will be used instead of generating a new one.

Example:
```bash
bash launcher.sh \
    --version 4.6.0 \
    --package file:///home/user/cyb3rhq-dashboard/dev_tools/build_packages/base/output/cyb3rhq-dashboard-4.6.0-1-linux-x64.tar.gz
```

[cyb3rhq-plugin]: https://github.com/cyb3rhq/cyb3rhq-kibana-app
[cyb3rhq-security-plugin]: https://github.com/cyb3rhq/cyb3rhq-security-dashboards-plugin