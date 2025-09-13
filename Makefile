SHELL := /bin/bash
.PHONY: new-contest add-problem run-problem validate fmt clean help

# Create a new contest by copying templates and adjusting dune-project
new-contest:
	@read -p "Enter contest number (e.g., 1136): " contest_num; \
	contest_dir="contests/contest_$$contest_num"; \
	if [ -d "$$contest_dir" ]; then \
		echo "Contest $$contest_num already exists: $$contest_dir"; \
		exit 1; \
	fi; \
	echo "Creating $$contest_dir..."; \
	mkdir -p "$$contest_dir"; \
	cp -f templates/dune "$$contest_dir/"; \
	cp -f templates/dune-project "$$contest_dir/"; \
	[ -f templates/.ocamlformat ] && cp -f templates/.ocamlformat "$$contest_dir/" || true; \
	# If your template contains a project name, you can rename it here (safe no-op otherwise): \
	sed -i "s/\<contest_template\>/contest_$$contest_num/g" "$$contest_dir/dune-project" || true; \
	echo "✅ Contest $$contest_num created. Now run: make add-problem CONTEST=$$contest_num"

# Add a problem: auto-assign next letter and create file from template
add-problem:
	@if [ -z "$(CONTEST)" ]; then echo "Please provide CONTEST=XXXX"; exit 1; fi; \
	contest_dir="contests/contest_$(CONTEST)"; \
	if [ ! -d "$$contest_dir" ]; then \
		echo "Contest directory not found: $$contest_dir"; \
		echo "Run: make new-contest and choose $(CONTEST)"; \
		exit 1; \
	fi; \
	title="$(TITLE)"; if [ -z "$$title" ]; then read -p "Enter problem title (e.g., mexification): " title; fi; \
	shopt -s nullglob; dirs=("$$contest_dir"/*/); count=$${#dirs[@]}; \
	ascii=$$((65 + count)); letter=$$(printf \\$$(printf '%03o' $$ascii)); \
	title_lower=$$(echo "$$title" | tr '[:upper:]' '[:lower:]'); \
	problem_dir="$$contest_dir/$${letter}-$${title_lower}"; \
	if [ -d "$$problem_dir" ]; then \
		echo "Problem directory already exists: $$problem_dir"; exit 1; \
	fi; \
	mkdir -p "$$problem_dir"; \
	cp templates/dune "$$problem_dir/"; \
	cp templates/dune-project "$$problem_dir/"; \
	[ -f templates/.ocamlformat ] && cp templates/.ocamlformat "$$problem_dir/" || true; \
	cp templates/problem_template.ml "$$problem_dir/main.ml"; \
	title_escaped=$$(printf '%s' "$$title" | sed 's/[\\&/]/\\&/g'); \
	sed -i "s/\[\[CONTEST\]\]/$(CONTEST)/g" "$$problem_dir/main.ml"; \
	sed -i "s/\[\[LETTER\]\]/$${letter}/g" "$$problem_dir/main.ml"; \
	sed -i "s/\[\[TITLE\]\]/$$title_escaped/g" "$$problem_dir/main.ml"; \
	touch "$$problem_dir/input.txt"; \
	touch "$$problem_dir/expected.txt"; \
	echo "✅ Added problem $$letter: $$title"; \
	echo "   Directory: $$problem_dir"; \
	echo "   Source: $$problem_dir/main.ml"

# Run a specific problem with input=input or a file path
run-problem:
	@if [ -z "$(CONTEST)" ] || [ -z "$(PROBLEM)" ]; then echo "Usage: make run-problem CONTEST=XXXX PROBLEM=A [INPUT=input|path]"; exit 1; fi; \
	contest_dir="contests/contest_$(CONTEST)"; \
	[ ! -d "$$contest_dir" ] && { echo "Contest directory not found: $$contest_dir"; exit 1; }; \
	shopt -s nullglob; \
	problem_path=""; \
	for d in "$$contest_dir"/$(PROBLEM)-*/; do \
		if [ -d "$$d" ]; then problem_path="$$d"; break; fi; \
	done; \
	shopt -u nullglob; \
	[ -z "$$problem_path" ] && { echo "Problem directory not found matching: $$contest_dir/$(PROBLEM)-*"; exit 1; }; \
	# strip trailing slash if present \
	problem_path="$${problem_path%/}"; \
	# Default to input.txt when INPUT is omitted or explicitly 'input' \
	if [ -z "$(INPUT)" ] || [ "$(INPUT)" = "input" ]; then \
		input_file="input.txt"; \
	else \
		input_file="$(INPUT)"; \
		# If INPUT is not a full path, try relative to problem dir \
		[ ! -f "$$problem_path/$$input_file" ] && [ ! -f "$$input_file" ] && { echo "Input not found: $$input_file"; exit 1; }; \
	fi; \
	cd "$$problem_path" && dune build && \
	if [ -f "$$input_file" ]; then \
		cat "$$input_file" | dune exec ./main.exe; \
	else \
		cat "../$$input_file" | dune exec ./main.exe; \
	fi

# Validate output against expected
validate:
	@if [ -z "$(CONTEST)" ] || [ -z "$(PROBLEM)" ]; then echo "Usage: make validate CONTEST=XXXX PROBLEM=A"; exit 1; fi; \
	contest_dir="contests/contest_$(CONTEST)"; \
	problem_dir="$$contest_dir/$(PROBLEM)-*"; \
	prob_dirs=($${problem_dir}); \
	if [ ! -d "$${prob_dirs[0]}" ]; then echo "Problem directory not found matching: $$problem_dir"; exit 1; fi; \
	problem_path="$${prob_dirs[0]}"; \
	cd "$$problem_path"; \
	[ ! -f "input.txt" ] && { echo "Missing input: input.txt"; exit 1; }; \
	[ ! -f "expected.txt" ] && { echo "Missing expected: expected.txt"; exit 1; }; \
	dune build; \
	actual=$$(cat "input.txt" | dune exec ./main.exe); \
	expected_content=$$(cat "expected.txt" | sed 's/[[:space:]]*$$//'); \
	actual_content=$$(echo "$$actual" | sed 's/[[:space:]]*$$//'); \
	if [ "$$actual_content" = "$$expected_content" ]; then \
		echo "✅ Validation passed"; \
	else \
		echo "❌ Validation failed"; \
		echo "Expected:"; cat "expected.txt"; \
		echo "Actual:"; echo "$$actual"; \
		exit 1; \
	fi

# Format and clean helpers across all contests
fmt:
	@# Run dune fmt in every problem directory that actually has a dune-project
	@find contests -maxdepth 3 -type f -name dune-project | while read -r proj; do \
		dir=$$(dirname "$$proj"); \
		echo "Formatting $$dir"; \
		( cd "$$dir" && dune fmt --auto-promote ) || echo "(warn) fmt failed in $$dir"; \
	done; echo "✅ Formatting complete"

clean:
	@# Clean build artifacts in each problem directory containing a dune-project
	@find contests -maxdepth 3 -type f -name dune-project | while read -r proj; do \
		dir=$$(dirname "$$proj"); \
		echo "Cleaning $$dir"; \
		( cd "$$dir" && dune clean ) || echo "(warn) clean failed in $$dir"; \
	done; echo "✅ Clean complete"

help:
	@echo "Manual Codeforces workflow (no auto submission)"; \
	echo "  make new-contest"; \
	echo "  make add-problem CONTEST=XXXX"; \
	echo "  make run-problem CONTEST=XXXX PROBLEM=A INPUT=input"; \
	echo "  make validate CONTEST=XXXX PROBLEM=A"; \
	echo "  make fmt | make clean"