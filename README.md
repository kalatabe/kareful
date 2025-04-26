# kareful

Wraps `kubectl` to prevent automatically running dangerous operations on contexts where that might not be desired.
For example asks for confirmation before draining a node on `production`.
You'll need to press `y` or `Y` to confirm the operation, before it's actually carried out. Any other response will
cancel the command.

This was written as a shell script instead of a kubectl plugin because kubectl currently doesn't allow extending
existing commands. See [Limitations](https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/#limitations).

## Example

```
bash-5.2$ ./kareful.sh drain aks-nodepool-43940673-vmss000000
Are you sure? [y/N] n
Operation cancelled.
```

## Installation

1. Clone the repository
2. Source `kareful.sh` in your shell .rc, for example `echo "source /path/to/kareful.sh >> ~/.zshrc"`

## Configuration

Open `kareful.sh` with your favorite text editor and edit the variables `DANGER_OPS` and `DANGER_CONTEXTS` to your
liking. Don't forget to restart your shell or re-source the RC afterward.
