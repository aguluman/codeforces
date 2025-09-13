# OCaml Codeforces Competitive Programming Workspace

A well-structured OCaml development environment for competitive programming, specifically designed for Codeforces contests. This project provides an automated workflow for managing contests, problems, and solutions with built-in-diff testing and validation capabilities.

Codeforces uses OCaml Compiler version 4.02.1, but OCaml is backward compatible, so you can use any version >= 4.02.1 provided you use the libraries available up until 4.02.1, that is the ocaml standard library and str.

## Target Audience

- **OCaml enthusiasts** wanting to practice competitive programming
- **Non-expert level Codeforces competitors** seeking a structured development workflow
- **Competitive programmers** looking for efficient problem setup and testing automation
- **Students and developers** interested in algorithmic problem-solving using functional programming

## Features

- **Automated Contest Management**: Create new contests with proper directory structure
- **Problem Template System**: Rapidly scaffold new problems with boilerplate code
- **Fast I/O Module**: Optimized input/output handling for competitive programming
- **Built-in Testing**: Validate solutions against expected outputs
- **Code Formatting**: Consistent code style using OCaml formatting tools
- **Makefile Automation**: Simple commands for all common tasks


## Quick Start

### Prerequisites

- **OCaml** (>= 4.02.0)
- **Dune** (>= 3.20)
- **Make** (for automation)
- **Git** (for version control)

### Installation
To get started with OCaml development:

- Install Opam using this link: [Opam Installation Guide per OS](https://opam.ocaml.org/doc/Install.html)
- Follow the guidelines on this page to setup OCaml: [OCaml By Example](https://o1-labs.github.io/ocamlbyexample/basics-opam.html)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/aguluman/codeforces.git
   cd codeforces
   ```

2. **Verify OCaml and Dune installation:**
   ```bash
   ocaml --version
   dune --version
   ```

3. **Test the setup:**
   ```bash
   make help
   ```

## Usage Guide

### Creating a New Contest

Start a new contest with the contest number from Codeforces:

```bash
make new-contest
# Enter contest number when prompted (e.g., 1500)
```

This creates a new directory structure under `contests/contest_XXXX/` with the necessary dune configuration files.

### Adding a New Problem

Add a problem to an existing contest:

```bash
make add-problem CONTEST=1500 TITLE="binary-search"
# Or interactive mode:
make add-problem CONTEST=1500
# Enter problem title when prompted
```

This automatically:
- Assigns the next letter (A, B, C, ...)
- Creates the problem directory (`A-binary-search/`)
- Copies the solution template with contest/problem info filled in
- Creates `input.txt` and `expected.txt` files for testing
- You will copy the values of input in `input.txt` and expected output in `expected.txt` from the particular problem statement.

### Implementing Your Solution

1. **Navigate to the problem directory:**
   ```bash
   cd contests/contest_1500/A-binary-search/
   ```

2. **Edit `main.ml`** using the provided template:
   ```ocaml
   (* The template includes FastIO module and solve_one_case function *)
   let solve_one_case () =
     let n = FastIO.read_int () in
     let arr = FastIO.read_n_ints n in
     (* Your solution logic here *)
     Printf.printf "%d\n" result
   ```

3. **Add test data:**
   - Put sample input in `input.txt`
   - Put expected output in `expected.txt`

### Running and Testing

**Run your solution:**
```bash
make run-problem CONTEST=1500 PROBLEM=A
# Use custom input file:
make run-problem CONTEST=1500 PROBLEM=A INPUT=custom_input.txt
```

**Validate against expected output:**
```bash
make validate CONTEST=1500 PROBLEM=A
```

### Code Formatting and Cleanup

**Format all code:**
```bash
make fmt
```

**Clean build artifacts:**
```bash
make clean
```


## Support

If you encounter any issues or have questions:

1. **Check** the help command: `make help`
2. **Review** the examples in `contests/` directory
3. **Open** an issue on GitHub with detailed description
4. **Include** your OCaml and Dune versions

## Goals for Non-Expert Competitors

This workspace is designed to help you:

- **Focus on algorithms** rather than setup boilerplate
- **Quickly iterate** on solutions with fast testing
- **Learn OCaml patterns** commonly used in competitive programming
- **Build confidence** through structured problem-solving workflow
- **Improve gradually** by studying implemented solutions

Happy coding and good luck with your competitive programming journey! 🚀