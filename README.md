# Alias Loader for Teleport Clusters

This repository contains scripts to dynamically load and manage aliases for different Teleport kubernetes clusters. The `alias_loader.sh` script automates the process of:
1. Clearing previously loaded aliases.
2. Fetching updated alias files from this repository.
3. Sourcing the appropriate alias file based on the specified cluster.
4. Logging into the specified Teleport cluster via `tsh kube login`.

## How It Works

1. **Alias Loader Script**:
   - The `alias_loader.sh` script is designed for `zsh` by default but can be adapted for `bash`.
   - Aliases are loaded dynamically into the shell after running the `tkl` command.

2. **Cluster Alias Files**:
   - Each cluster has its own alias file, such as:
     - `load_alias_local.sh` for the `local` cluster.
     - `load_alias_remote.sh` for the `remote` cluster.
   - These files define aliases specific to the cluster, e.g.:
     ```bash
     alias k='kubectl -n teleport'
     alias ka='kubectl -n argocd'
     ```

3. **Login Automation**:
   - The script automatically runs `tsh kube login <cluster>` after loading the aliases.

---

## Usage

1. **Set Up the `tkl` Alias**:
   Add the following to your `~/.zshrc` (or `~/.bashrc` for `bash`):
   ```bash
   alias tkl='source <(curl -s https://raw.githubusercontent.com/<your-username>/<repo-name>/main/alias_loader.sh)'
   ```

2. **Run the Command**:
   Use the `tkl` alias to load aliases and log into a cluster:
   ```bash
   tkl remote
   ```

3. **Validate Aliases**:
   Once the script completes, aliases will be available in your shell. For example:
   ```bash
   ka get po
   ```

---

## Adding or Updating Cluster Alias Files

1. **Create a New Alias File**:
   - Add a new file in the repository for the cluster, e.g., `load_alias_newcluster.sh`.
   - Define cluster-specific aliases in the file:
     ```bash
     alias k='kubectl -n newcluster'
     alias kd='kubectl describe'
     ```

2. **Update the Alias Loader Script**:
   - No script changes are required if the cluster name matches the alias file's suffix (e.g., `tkl newcluster` will automatically look for `load_alias_newcluster.sh`).
   - If a custom mapping is needed, update the logic in `alias_loader.sh` where `ALIAS_FILE` is determined.

3. **Commit and Push Changes**:
   - Commit the new alias file to the repository:
     ```bash
     git add load_alias_newcluster.sh
     git commit -m "Add aliases for newcluster"
     git push
     ```

---

## Compatibility: `zsh` vs `bash`

The current setup is designed for `zsh`. For `bash`, follow these steps:

1. **Update the Local Alias**:
   - Use `source` in `~/.bashrc` for `bash`:
     ```bash
     alias tkl='source <(curl -s https://raw.githubusercontent.com/<your-username>/<repo-name>/main/alias_loader.sh)'
     ```

2. **Modify the Alias Files (if necessary)**:
   - `zsh` and `bash` aliases are generally compatible. However, if differences arise, you can conditionally define them:
     ```bash
     if [ -n "$BASH_VERSION" ]; then
         alias k='kubectl -n bash-specific-namespace'
     else
         alias k='kubectl -n zsh-specific-namespace'
     fi
     ```

---

## Notes

- Ensure the repository is publicly accessible or authenticated (for private repos).
- For non-`zsh` shells, you may need to test compatibility and adjust as needed.

Feel free to reach out if you have questions or issues!