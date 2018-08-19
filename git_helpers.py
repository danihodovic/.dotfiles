import subprocess

def git_cherry_pick_new_branch():
    proc = subprocess.run(
        'git rev-list $(git symbolic-ref --short HEAD) '
        '--not master --no-merges --pretty=oneline --abbrev-commit | fzf',
        shell=True,
        stdout=subprocess.PIPE,
        encoding='utf8')
    git_hash, *commit = proc.stdout.rstrip().split(' ')
    new_branch_name = '-'.join(commit).lower()

    subprocess.run(f'''
        git checkout master
        git pull origin/master
        git checkout -b {new_branch_name}
        git cherry-pick {git_hash}
    ''', shell=True)
