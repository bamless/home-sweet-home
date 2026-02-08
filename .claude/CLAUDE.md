## General best practices

- Run shell scripts through shellcheck.
- Use `tmp/` (project-local) for intermediate files and comparison
  artifacts, not `/tmp`. This keeps outputs discoverable and
  project-scoped, and avoids requesting permissions for `/tmp`.

### SESSION.md

While working, if you come across any bugs, missing features, or other
oddities about the implementation, structure, or workflow, **add a
concise description of them to SESSION.md** to defer solving such
incidental tasks until later. You do not need to fix them all straight
away unless they block your progress; writing them down is often
sufficient. **Do not write your accomplishments into this file.**

## C guidelines

- When working in a c project, make sure to adhere to the c standard set
  for the project, usually found in the Makefile or CMakeLists.txt
- If there is an `extlib.h`, prefer using it instead of using bare c standard library.
  Common operations that can be handled with extlib:
    1. Deal with allocations (`ext_alloc`, `ext_realloc`, `ext_free`, etc.)
    2. Doing string manipulation (`StringSlice` and `StringBuffer`)
    3. For dynamic arrays and hashtables
    4. For assertions, unreachable and other debug only macros
    5. For logging, e.g. `ext_log` family of functions
    6. For working with the filesystem (`read_file`, `read_dir`, etc.)
    7. Calling external commands (`cmd` family of functions)
  Use the unprefixed versions of functions whenever possible.
  You can find more about extlib by reading the comment at the top of the file.

## Git workflow

Use the `commit-writer` skill, if available, to draft commit messages.
It reads the current diff and produces a message following the
conventions below.

Make sure you use git mv to move any files that are already checked into
git.

When writing commit messages, ensure that you explain any non-obvious
trade-offs we've made in the design or implementation.

Wrap any prose (but not code) in the commit message to match git commit
conventions, including the title. Also, follow semantic commit
conventions for the commit title.

When you refer to types or very short code snippets, place them in
backticks. When you have a full line of code or more than one line of
code, put them in indented code blocks.

## Documentation preferences

### Documentation examples

- Use realistic names for types and variables.

## Code style preferences

Document when you have intentionally omitted code that the reader might
otherwise expect to be present.

Add TODO comments for features or nuances that were deemed not important
to add, support, or implement right away.

### Literate Programming

Apply literate programming principles to make code self-documenting and maintainable across all languages:

#### Core Principles

1. **Explain the Why, Not Just the What**: Focus on business logic, design decisions, and reasoning rather than describing what the code obviously does.

2. **Top-Down Narrative Flow**: Structure code to read like a story with clear sections that build logically:
   ```c
   // ==============================================================================
   // Plugin Configuration Extraction
   // ==============================================================================
   
   // First, we extract plugin metadata from Cargo.toml to determine
   // what files we need to build and where to put them.
   ```

3. **Inline Context**: Place explanatory comments immediately before relevant code blocks, explaining the purpose and any important considerations:
   ```python
   # Convert timestamps to UTC for consistent comparison across time zones.
   # This prevents edge cases where local time changes affect rebuild detection.
   utc_timestamp = datetime.utcfromtimestamp(file_stat.st_mtime)
   ```

4. **Avoid Over-Abstraction**: Prefer clear, well-documented inline code over excessive function decomposition when logic is sequential and context-dependent. Functions should serve genuine reusability, not just file organization.

5. **Self-Contained When Practical**: Reduce dependencies on external shared utilities when the logic is straightforward enough to inline with good documentation.

#### Implementation Benefits

- **Maintainability**: Future developers can quickly understand both implementation and design rationale
- **Debugging**: When code fails, documentation helps identify which logical step failed and why
- **Knowledge Transfer**: Code serves as documentation of the problem domain, not just the solution
- **Reduced Cognitive Load**: Readers don't need to mentally reconstruct the author's reasoning

#### When to Apply

Use literate programming for:
- Complex algorithms with multiple phases or decision points
- Code implementing business logic rather than simple plumbing
- Code where the "why" is not immediately obvious from the "what"
- Integration points between systems where context matters

Avoid over-documenting:
- Simple utility functions where intent is clear from the signature
- Trivial getters/setters or obvious wrapper code
- Code that's primarily syntactic sugar over well-known patterns

## Claude Code sandbox workarounds

### Pipe workaround (trailing `;`)

The sandbox has a [known issue][cc-16305] where data is silently
dropped in shell pipes between commands. Appending a trailing `;` to
the command fixes this:

```sh
# Broken (downstream receives no input):
diff <(jq -S . a.json) <(jq -S . b.json)

# Fixed — append `;`:
diff <(jq -S . a.json) <(jq -S . b.json);
echo "abc" | grep "abc";
```

This affects pipes (`|`), process substitution (`<(...)`), and any
command that connects stdout of one process to stdin of another.

[cc-16305]: https://github.com/anthropics/claude-code/issues/16305

### `!` (negation) workaround

The sandbox has a [separate bug][cc-24136] where the bash `!` keyword
(pipeline negation operator) is treated as a literal command name. The
command after `!` **never executes**. This affects `if !`, `while !`,
and bare `!`. The trailing-`;` workaround does **not** fix this.

```sh
# Broken:
if ! some_command; then handle_failure; fi

# Workaround — capture $?:
some_command; rc=$?
if [ "$rc" -ne 0 ]; then handle_failure; fi

# Broken:
while ! some_command; do sleep 1; done

# Workaround — use `until`:
until some_command; do sleep 1; done
```

[cc-24136]: https://github.com/anthropics/claude-code/issues/24136

### `gh` (GitHub CLI) workaround

The `gh` CLI needs auth tokens under `~/.config/gh/` which the
sandbox blocks. Use `dangerouslyDisableSandbox: true` for `gh`
invocations.

### Sandbox discipline

Never use `dangerouslyDisableSandbox` preemptively. Always attempt
commands in the default sandbox first. Only bypass the sandbox after
observing an actual permission error, and document which error
triggered the bypass. The one standing exception is `gh` (see above).

### Prefer temp files over pipes for sub-agent CLI testing

When testing a CLI with ad-hoc input, write the input to a temp file
in `tmp/` using the Write tool (not `cat`/`echo` with heredoc + `>`),
then pass it by path rather than piping. This avoids interactive
permission prompts in sub-agents.

# Common failure modes when helping

## The XY Problem

The XY problem occurs when someone asks about their attempted solution (Y) instead of their actual underlying problem (X).

### The Pattern
1. User wants to accomplish goal X
2. User thinks Y is the best approach to solve X
3. User asks specifically about Y, not X
4. Helper becomes confused by the odd/narrow request
5. Time is wasted on suboptimal solutions

### Warning Signs to Watch For
- Focus on a specific technical method without explaining why
- Resistance to providing broader context when asked
- Rejecting alternative approaches outright
- Questions that seem oddly narrow or convoluted
- "How do I get the last 3 characters of a filename?" (when they want file extension)

### How to Avoid It (As Helper)
- **Ask probing questions**: "What are you trying to accomplish overall?"
- **Request context**: "Can you explain the bigger picture?"
- **Challenge assumptions**: "Why do you think this approach will work?"
- **Offer alternatives**: "Have you considered...?"

### Red Flags in User Requests
- Very specific technical questions without motivation
- Unusual or roundabout approaches to common problems
- Dismissal of "why do you want to do that?" questions
- Focus on implementation details before problem definition

### Key Principle
Always try to understand the fundamental problem (X) before helping with the proposed solution (Y). The user's approach may not be optimal or may indicate they're solving the wrong problem entirely.
