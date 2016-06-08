# Training::Utils

This is a package of git- and github-training scripts into an easily-installed package. This collection of utilities originated [here](https://github.com/matthewmccullough/scripts).

## Installation

If you have Ruby >= 1.9 installed, you can install these scripts into a directory in your `$PATH` by running:

```
$ script/bootstrap
```

## Usage

#### `generaterandomchanges <N> <base> <extension>`

Generates **N** new **commits**, the content of each is a new file named "`<base><I>.<extension>`" with some random text.

```
$ generaterandomchanges 3 file txt
[master f377b54] A random change of 27129 to file1.txt
2 files changed, 7 insertions(+), 1 deletion(-)
create mode 100644 file1.txt
[master fd0965c] A random change of 15808 to file2.txt
1 file changed, 1 insertion(+)
create mode 100644 file2.txt
[master a704698] A random change of 26224 to file3.txt
1 file changed, 1 insertion(+)
create mode 100644 file3.txt

$ ls
README.md  file1.txt  file2.txt  file3.txt

$ git log --oneline
a704698 A random change of 26224 to file3.txt
fd0965c A random change of 15808 to file2.txt
f377b54 A random change of 27129 to file1.txt
ec9bce1 Add readme
```

#### `generaterandomfiles <N> <base> <extension>`

Generates **N** new **files**, each named "`<base><I>.<extension>`" with some random text.

```
$ generaterandomfiles 3 stuff txt

$ ls
README.md  stuff1.txt  stuff2.txt  stuff3.txt

$ git log --oneline
ec9bce1 Add readme

$ cat stuff1.txt
Some random text: 10660
```

#### `git-graphlive <N optional, 10 default>`

Perpetually loop `git --no-pager log -<N> --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s' --abbrev-commit --date=relative`. It's like "tail -f" for `git log`. It's sometimes useful to have this on a split screen, showing the git one-line, ASCII art git graph.

```
$ git graphlive 5
* 6cad0b4 - (HEAD, master) A random change of 19964 to file30.txt
* c9fd401 - A random change of 16742 to file29.txt
* d5794af - A random change of 22469 to file28.txt
* b2110a3 - A random change of 32088 to file27.txt
* 75d01a9 - A random change of 12572 to file26.txt
```

#### `historytailbash` and `historytailzsh`

Perpetually loop through `history`. It's like `tail -f` for history. Comes in `bash` and `zsh` flavors. It's sometimes useful to have this on a split screen, showing the recent history of commands.

#### `transpose <file>.csv`

Generate a transposed `*.csv` file from an input file.

#### `treelive <depth>`

Perpetually loop `tree`, up to `depth` folders deep in the hierarchy.

#### `welcome <name>`

Prints a welcome message:

```
-------------------------------------------------
Welcome to class on: Wed Jan 14 17:00:35 CST 2015
I'm Instructor Name Here, your instructor
-------------------------------------------------
```

## Contributing

1. Fork it ( https://github.com/githubtraining/training-utils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
