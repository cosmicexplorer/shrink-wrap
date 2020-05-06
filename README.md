shrink-wrap
===========

An emacs minor mode that makes all indentation look the way you want it to.

# Documentation
## `defcustom`
- `shrink-wrap-desired-indentation`: ???

## `defun`
- `shrink-wrap-mode` -- modifies the presentation of leading space characters on each line to display the desired number and type of space characters per indent depth.

# TODO
- [ ] ?

# Rationale (the Black linter's fateful choice)
If you've ever pushed through an indentation change (with a million one-off manual fixes) to a large python codebase because of the [Black](https://github.com/psf/black) linter's 4-space policy, I'm sorry that you were misled by the siren call of "exactly one way to do it".

If you're responsible for the Black linter, please give a rationale for why 2-space indentation isn't allowed. Saying "Black will not support this style" after a highly knowledgeable pythonista offers a really neat way to support 2-space indent and [closing the ticket without explaining why](https://github.com/psf/black/issues/378) isn't a project I want to have anything to do with at all, and I'm not the only one.

If the Black linter had worked to convert 2->4 spaces automatically, I wouldn't care **at all** about that choice. But as-is it requires fixing a massive amount of Python code, especially in docstrings. [The pants repo](https://github.com/pantsbuild/pants) still has any docstring > 1 line misformatted, in some cases making the meaning unclear. I don't know how anyone goes to sleep with an ok conscience knowing that a tiny amount of work would make it possible for a huge number of people to use the best linter available by far (the last part is the key phrase here).

It's ok, because I've already [forked Black](https://github.com/cosmicexplorer/black/tree/support-2-spaces), and will be consuming this fork inside of Twitter, since that is my job. However, to do my job a little more effectively in the pants repo, which isn't likely to ever change back to 2 spaces, I made this extension.

# LICENSE
[GPL 3.0 (or any later version)](./LICENSE)
